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
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingPathComponent:@"/payments/user/add"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            //            completionBlock(transaction, nil);
        }
    }];
    
    [dataTask resume];
}

- (void)addPaymentMethodsWithFirstToken:(NSString *)firstToken
                            secondToken:(NSString *)secondToken
                                 userID:(NSString *)userID
                              firstName:(NSString *)firstName
                               lastName:(NSString *)lastName
                                address:(NSString *)address
                                   city:(NSString *)city
                                  state:(NSString *)state
                                    zip:(NSString *)zip
                        completionBlock:(void (^)(NSDictionary *, NSError *))completionBlock {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"token1":firstToken,
                             @"token2":secondToken,
                             @"userId":userID,
                             @"firstName":firstName,
                             @"lastName":lastName,
                             @"address":address,
                             @"city":city,
                             @"state":state,
                             @"zip":zip,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingPathComponent:@"/payments/method/add"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            //            completionBlock(transaction, nil);
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
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingPathComponent:@"/payments/verification/add"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
//            completionBlock(transaction, nil);
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
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingPathComponent:@"/payments/purchase"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    
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