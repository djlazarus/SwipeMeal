//
//  SwipeStore.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeStore.h"

@implementation SwipeStore {
    NSMutableDictionary *_swipesBySwipeID;
}

+ (SwipeStore *)sharedSwipeStore {
    static SwipeStore *swipeStore = nil;
    if (!swipeStore) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            swipeStore = [[SwipeStore alloc] init];
        });
    }
    
    return swipeStore;
}

- (instancetype)init {
    if (self = [super init]) {
        _swipesBySwipeID = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)containsSwipeKey:(NSString *)key {
    if ([_swipesBySwipeID objectForKey:key]) {
        return YES;
    }
    
    return NO;
}

- (void)addSwipe:(Swipe *)swipe forKey:(NSString *)key {
    [_swipesBySwipeID setObject:swipe forKey:key];
}

- (void)removeSwipe:(Swipe *)swipe forKey:(NSString *)key {
    [_swipesBySwipeID removeObjectForKey:key];
}

- (Swipe *)swipeForKey:(NSString *)key {
    Swipe *swipe = [_swipesBySwipeID objectForKey:key];
    return swipe;
}

- (NSArray *)swipesSortedByPriceAscending {
    NSArray *swipeKeys = [_swipesBySwipeID keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Swipe *swipe1 = (Swipe *)obj1;
        Swipe *swipe2 = (Swipe *)obj2;
        
        return [@(swipe1.price) compare:@(swipe2.price)];
    }];

    NSMutableArray *swipes = [NSMutableArray array];
    for (NSString *key in swipeKeys) {
        Swipe *swipe = [_swipesBySwipeID objectForKey:key];
        [swipes addObject:swipe];
    }
    
    return swipes;
}

@end