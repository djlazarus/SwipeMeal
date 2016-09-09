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

@interface StripePaymentService ()

@end

@implementation StripePaymentService

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
                   completionBlock:(void (^)(SwipeTransaction *transaction, NSError *error))completionBlock {
    
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
            SwipeTransaction *transaction = [[SwipeTransaction alloc] init];
            transaction.swipeTransactionID = @"";
            transaction.stripeTransactionID = @"";
            //            transaction.sellerID = sellerID;
            transaction.buyerID = buyerID;
            
            completionBlock(transaction, nil);
        }
    }];
    
    [dataTask resume];
}

@end