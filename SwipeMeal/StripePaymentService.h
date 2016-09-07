//
//  StripePaymentService.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwipeTransaction.h"

@interface StripePaymentService : NSObject

+ (StripePaymentService *)sharedPaymentService;

- (void)createCustomerWithUserID:(NSString *)userID
                           email:(NSString *)email
                       ipAddress:(NSString *)ipAddress
                 completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)addPaymentMethodWithToken:(NSString *)token
                           userID:(NSString *)userID
                        firstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                          address:(NSString *)address
                             city:(NSString *)city
                            state:(NSString *)state
                              zip:(NSString *)zip
                  completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)addPayoutVerificationWithUserID:(NSString *)userID
                               dobMonth:(NSString *)dobMonth
                                 dobDay:(NSString *)dobDay
                                dobYear:(NSString *)dobYear
                                    ssn:(NSString *)ssn
                        completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)requestPurchaseWithSwipeID:(NSString *)swipeID
                           buyerID:(NSString *)buyerID
                   completionBlock:(void (^)(SwipeTransaction *transaction, NSError *error))completionBlock;

@end