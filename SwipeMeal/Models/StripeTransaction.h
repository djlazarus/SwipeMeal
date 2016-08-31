//
//  StripeTransaction.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/31/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StripeTransaction : NSObject

@property (strong, nonatomic) NSString *stripeTransactionID;
@property (strong, nonatomic) NSString *stripeCustomerID;
@property (strong, nonatomic) NSString *stripeAccountID;

@end