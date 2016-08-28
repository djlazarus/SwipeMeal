//
//  StripeAPIClient.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/27/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StripeAPIClient : NSObject

- (void)requestPurchaseWithSwipeID:(NSString *)swipeID
                           buyerID:(NSString *)buyerID
                          sellerID:(NSString *)sellerID
                   completionBlock:(void (^)(void))completionBlock;

@end