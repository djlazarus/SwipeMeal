//
//  SwipeService.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Swipe.h"

@protocol SwipeServiceDelegate;

@interface SwipeService : NSObject

@property (weak, nonatomic) id <SwipeServiceDelegate> delegate;
@property (strong, nonatomic, readonly) NSArray *swipes;
+ (SwipeService *)sharedSwipeService;
- (void)listenForEvents;
- (void)createNewSwipeWithValues:(NSDictionary *)values withCompletionBlock:(void (^)(void))completionBlock;

@end

@protocol SwipeServiceDelegate <NSObject>

- (void)swipeServiceDidAddSwipe:(SwipeService *)service;
- (void)swipeServiceDidRemoveSwipe:(SwipeService *)service;
- (void)swipeService:(SwipeService *)service didUpdateSwipeAtIndexPath:(NSIndexPath *)indexPath;

@end