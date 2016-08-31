//
//  SwipeTransaction.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwipeTransaction : NSObject

@property (strong, nonatomic) NSString *swipeTransactionID;
@property (strong, nonatomic) NSString *stripeTransactionID;
@property (strong, nonatomic) NSString *swipeID;
@property (strong, nonatomic) NSString *sellerID;
@property (strong, nonatomic) NSString *buyerID;
@property (nonatomic) NSInteger salePrice;
@property (nonatomic) NSTimeInterval timestamp;

@end