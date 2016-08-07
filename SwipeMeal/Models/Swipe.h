//
//  Swipe.h
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Swipe : NSObject

@property (strong, nonatomic) NSString *swipeID;
@property (nonatomic) NSInteger price;
@property (strong, nonatomic) UIImage *sellerImage;
@property (strong, nonatomic) NSString *sellerName;
@property (strong, nonatomic) NSString *locationName;
@property (nonatomic) NSTimeInterval availableTime;
@property (nonatomic) NSTimeInterval listingTime;
@property (nonatomic) NSTimeInterval soldTime;
@property (nonatomic) NSTimeInterval expireTime;
@property (nonatomic) NSInteger sellerRating;
@property (nonatomic, getter=isValid) BOOL valid;

@end