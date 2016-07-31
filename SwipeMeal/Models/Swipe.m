//
//  Swipe.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "Swipe.h"

@implementation Swipe

- (BOOL)isValid {
    BOOL valid = NO;
    if (self.price > 0 && self.locationName.length > 0 && self.availableTime > 0) {
        valid = YES;
    }
    
    return valid;
}

@end