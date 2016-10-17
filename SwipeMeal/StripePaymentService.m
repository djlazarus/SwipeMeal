//
//  StripePaymentService.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "StripePaymentService.h"
#import "AFNetworking/AFNetworking.h"
#import "Constants.h"
@import Stripe;


#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface StripePaymentService ()

@end

@implementation StripePaymentService

- (NSString *)getIPAddress:(BOOL)preferIPv4
{
	NSArray *searchArray = preferIPv4 ?
	@[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
	@[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
	
	NSDictionary *addresses = [self getIPAddresses];
	NSLog(@"addresses: %@", addresses);
	
	__block NSString *address;
	[searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
	 {
		 address = addresses[key];
		 if(address) *stop = YES;
	 } ];
	return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
	NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
	
	// retrieve the current interfaces - returns 0 on success
	struct ifaddrs *interfaces;
	if(!getifaddrs(&interfaces)) {
		// Loop through linked list of interfaces
		struct ifaddrs *interface;
		for(interface=interfaces; interface; interface=interface->ifa_next) {
			if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
				continue; // deeply nested code harder to read
			}
			const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
			char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
			if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
				NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
				NSString *type;
				if(addr->sin_family == AF_INET) {
					if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
						type = IP_ADDR_IPv4;
					}
				} else {
					const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
					if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
						type = IP_ADDR_IPv6;
					}
				}
				if(type) {
					NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
					addresses[key] = [NSString stringWithUTF8String:addrBuf];
				}
			}
		}
		// Free memory
		freeifaddrs(interfaces);
	}
	return [addresses count] ? addresses : nil;
}

+ (StripePaymentService *)sharedPaymentService {
    static StripePaymentService *paymentService = nil;
    if (!paymentService) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            paymentService = [[StripePaymentService alloc] init];
        });
    }
	
    return paymentService;
}

- (void)createCustomerWithUserID:(NSString *)userID
                           email:(NSString *)email
                       ipAddress:(NSString *)ipAddress
                 completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"userId":userID,
                             @"email":email,
                             @"ip":ipAddress,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/user/add"];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil); // WHAT TO RETURN HERE?
        }
    }];
    
    [dataTask resume];
}

- (void)addPaymentMethodWithToken:(NSString *)token
                           userID:(NSString *)userID
                             name:(NSString *)name
                         address1:(NSString *)address1
                         address2:(NSString *)address2
                             city:(NSString *)city
                            state:(NSString *)state
                              zip:(NSString *)zip
                  completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"token":token,
                             @"userId":userID,
                             @"name":name,
                             @"address1":address1,
                             @"address2":address2,
                             @"city":city,
                             @"state":state,
                             @"zip":zip,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/method/add"];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil);
        }
    }];
    
    [dataTask resume];
}

- (void)addPayoutVerificationWithUserID:(NSString *)userID
                               dobMonth:(NSString *)dobMonth
                                 dobDay:(NSString *)dobDay
                                dobYear:(NSString *)dobYear
                                    ssn:(NSString *)ssn
                        completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"userId":userID,
                             @"dobMonth":dobMonth,
                             @"dobDay":dobDay,
                             @"dobYear":dobYear,
                             @"ssn":ssn,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/verification/add"];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil);
        }
    }];
    
    [dataTask resume];
}

- (void)requestPurchaseWithSwipeID:(NSString *)swipeID
                           buyerID:(NSString *)buyerID
                   completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"swipeId":swipeID,
                             @"buyerId":buyerID,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/purchase"];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil);
        }
    }];
    
    [dataTask resume];
}

- (void)requestRefundWithTransactionID:(NSString *)transactionID
                       completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"swipeTransactionId":transactionID,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/refund"];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil);
        }
    }];
    
    [dataTask resume];
}

- (void)requestReferralPaymentWithReferralID:(NSString *)referralID
                                      userID:(NSString *)userID
                                      amount:(NSNumber *)amount
                             completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"userId":userID,
                             @"referralId":referralID,
                             @"referralFee":amount,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingString:@"/payments/referral"];
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            completionBlock(responseObject, nil);
        }
    }];
    
    [dataTask resume];
}

@end
