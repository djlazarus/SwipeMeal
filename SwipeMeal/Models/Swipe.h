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
@property (strong, nonatomic) NSString *swipeTransactionID;
@property (nonatomic) NSInteger listPrice;
@property (strong, nonatomic) NSString *listingUserID;
@property (strong, nonatomic) NSString *listingUserName;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSArray *messages;
@property (nonatomic) NSTimeInterval availableTime;
@property (nonatomic) NSTimeInterval listingTime;
@property (nonatomic) NSTimeInterval soldTime;
@property (nonatomic) NSTimeInterval expireTime;
@property (nonatomic) NSInteger listingUserRating;
@property (nonatomic, getter=isValid) BOOL valid;

@end
