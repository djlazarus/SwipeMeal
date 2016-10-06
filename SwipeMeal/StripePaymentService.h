//
//  StripePaymentService.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StripePaymentService : NSObject

+ (StripePaymentService *)sharedPaymentService;

- (void)createCustomerWithUserID:(NSString *)userID
                           email:(NSString *)email
                       ipAddress:(NSString *)ipAddress
                 completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)addPaymentMethodWithToken:(NSString *)token
                           userID:(NSString *)userID
                             name:(NSString *)name
                         address1:(NSString *)address1
                         address2:(NSString *)address2
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
                   completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)requestRefundWithTransactionID:(NSString *)transactionID
                 completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

- (void)requestReferralPaymentWithReferralID:(NSString *)referralID
                                      userID:(NSString *)userID
                                      amount:(NSNumber *)amount
                             completionBlock:(void (^)(NSDictionary *response, NSError *error))completionBlock;

@end
