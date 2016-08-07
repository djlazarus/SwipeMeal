//
//  SwipeStore.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Swipe.h"

@interface SwipeStore : NSObject

+ (SwipeStore *)sharedSwipeStore;
- (BOOL)containsSwipeKey:(NSString *)key;
- (void)addSwipe:(Swipe *)swipe forKey:(NSString *)key;
- (void)removeSwipe:(Swipe *)swipe forKey:(NSString *)key;
- (Swipe *)swipeForKey:(NSString *)key;
- (NSArray *)swipesSortedByPriceAscending;

@end