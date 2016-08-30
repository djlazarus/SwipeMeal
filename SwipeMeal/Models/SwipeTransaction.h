//
//  SwipeTransaction.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwipeTransaction : NSObject

@property (strong, nonatomic) NSString *transactionID;
@property (strong, nonatomic) NSString *swipeID;
@property (strong, nonatomic) NSString *sellerID;
@property (strong, nonatomic) NSString *sellerName;
@property (strong, nonatomic) NSString *buyerID;
@property (strong, nonatomic) NSString *buyerName;
@property (strong, nonatomic) NSString *locationName;
@property (nonatomic) NSInteger salePrice;
@property (nonatomic) NSTimeInterval timestamp;

@end