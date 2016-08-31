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

- (void)requestPurchaseWithSwipeID:(NSString *)swipeID buyerID:(NSString *)buyerID sellerID:(NSString *)sellerID completionBlock:(void (^)(SwipeTransaction *transaction, NSError *error))completionBlock {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSDictionary *params = @{@"swipe_id":swipeID,
                             @"buyer":buyerID,
                             @"seller":sellerID,
                             kPaymentServerDevParameter:kPaymentServerDevValue};
    NSString *urlString = [kPaymentServerEndpoint stringByAppendingPathComponent:@"/swipe/buy"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            completionBlock(nil, error);
        } else {
            NSLog(@"%@", responseObject);
            SwipeTransaction *transaction = [[SwipeTransaction alloc] init];
            transaction.swipeTransactionID = @"";
            transaction.stripeTransactionID = @"";
            transaction.sellerID = sellerID;
            transaction.buyerID = buyerID;
            
            completionBlock(transaction, nil);
        }
    }];

    [dataTask resume];
}

@end