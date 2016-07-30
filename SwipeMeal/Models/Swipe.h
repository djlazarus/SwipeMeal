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

@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) UIImage *sellerImage;
@property (strong, nonatomic) NSString *sellerName;
@property (strong, nonatomic) NSString *locationName;
@property (nonatomic) NSTimeInterval listingTime;
@property (nonatomic) NSInteger sellerRating;

@end