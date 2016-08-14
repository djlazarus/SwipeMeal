//
//  SwipeService.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeService.h"
#import "SwipeStore.h"
@import Firebase;

@interface SwipeService ()

@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) SwipeStore *swipeStore;

@end

@implementation SwipeService

+ (SwipeService *)sharedSwipeService {
    static SwipeService *swipeService = nil;
    if (!swipeService) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            swipeService = [[SwipeService alloc] init];
        });
    }
    
    return swipeService;
}

- (instancetype)init {
    if (self = [super init]) {
        self.swipeStore = [SwipeStore sharedSwipeStore];
        self.dbRef = [[FIRDatabase database] referenceWithPath:@"/swipes-listed/"];
    }
    
    return self;
}

- (NSArray *)swipes {
    return [self.swipeStore swipesSortedByPriceAscending];
}

- (void)listenForEvents {
    [self.dbRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Test for expired Swipe
        if (![self snapshotIsExpired:snapshot]) {
            // Build Swipe
            Swipe *swipe = [self swipeWithKey:snapshot.key values:snapshot.value];
            if ([self.swipeStore containsSwipeKey:swipe.swipeID]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self.swipeStore swipesSortedByPriceAscending] count] - 1 inSection:0];
                id <SwipeServiceDelegate> delegate = self.delegate;
                [delegate swipeService:self didUpdateSwipeAtIndexPath:indexPath];
            } else {
                [self.swipeStore addSwipe:swipe forKey:swipe.swipeID];
                NSLog(@"ADDED: %@", swipe);
                id <SwipeServiceDelegate> delegate = self.delegate;
                [delegate swipeServiceDidAddSwipe:self];
            }
        }
    }];
    
    [self.dbRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Swipe *swipe = [self swipeWithKey:snapshot.key values:snapshot.value];
        [self.swipeStore removeSwipe:swipe forKey:swipe.swipeID];
        NSLog(@"REMOVED: %@", snapshot);
        id <SwipeServiceDelegate> delegate = self.delegate;
        [delegate swipeServiceDidRemoveSwipe:self];
    }];
}

- (BOOL)snapshotIsExpired:(FIRDataSnapshot *)snapshot {
    NSTimeInterval expirationTimestamp = [[snapshot.value objectForKey:@"expiration_time"] floatValue];
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if (currentTimestamp >= expirationTimestamp) {
        return YES;
    }
    
    return NO;
}

- (Swipe *)swipeWithKey:(NSString *)key values:(NSDictionary *)values {
    Swipe *swipe = [[Swipe alloc] init];
    swipe.swipeID = key;
    swipe.uid = [values objectForKey:@"uid"];
    swipe.sellerName = [values objectForKey:@"seller_name"];
    swipe.sellerRating = [[values objectForKey:@"seller_rating"] integerValue];
    swipe.price = [[values objectForKey:@"price"] integerValue];
    swipe.locationName = [values objectForKey:@"location_name"];
    swipe.listingTime = [[values objectForKey:@"listing_time"] floatValue];
    swipe.expireTime = [[values objectForKey:@"expiration_time"] floatValue];

    return swipe;
}

@end