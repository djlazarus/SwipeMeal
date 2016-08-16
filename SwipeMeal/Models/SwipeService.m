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
        self.dbRef = [[FIRDatabase database] reference];
    }
    
    return self;
}

- (NSArray *)swipes {
    return [self.swipeStore swipesSortedByPriceAscending];
}

- (void)listenForEventsWithAddBlock:(void (^)(void))addBlock removeBlock:(void (^)(void))removeBlock updateBlock:(void (^)(void))updateBlock {
    [[self.dbRef child:@"/swipes-listed/"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Test for expired Swipe
        if (![self snapshotIsExpired:snapshot]) {
            // Build Swipe
            Swipe *swipe = [self swipeWithKey:snapshot.key values:snapshot.value];
            if ([self.swipeStore containsSwipeKey:swipe.swipeID]) {
                updateBlock();
            } else {
                [self.swipeStore addSwipe:swipe forKey:swipe.swipeID];
                NSLog(@"Added Swipe: %@", swipe);
                addBlock();
            }
        }
    }];
    
    [[self.dbRef child:@"/swipes-listed/"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Swipe *swipe = [self swipeWithKey:snapshot.key values:snapshot.value];
        [self.swipeStore removeSwipe:swipe forKey:swipe.swipeID];
        NSLog(@"Removed Swipe: %@", snapshot);
        removeBlock();
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

- (void)createNewSwipeWithValues:(NSDictionary *)values withCompletionBlock:(void (^)(void))completionBlock {
    NSString *key = [[self.dbRef child:@"swipes-listed"] childByAutoId].key;
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSDictionary *childUpdates = @{[@"/swipes-listed/" stringByAppendingString:key]: values,
                                   [NSString stringWithFormat:@"/user-swipes-listed/%@/%@/", userID, key]: values};
    
    [self.dbRef updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            completionBlock();
        }
    }];
}

//- (void)buySwipe:(Swipe *)swipe withValues:(NSDictionary *)values completionBlock:(void (^)(void))completionBlock {
//    NSString *key = [[self.dbRef child:@"swipes-listed"] childByAutoId].key;
//    NSString *userID = [FIRAuth auth].currentUser.uid;
//    NSDictionary *childUpdates = @{[@"/swipes-listed/" stringByAppendingString:key]: values,
//                                   [NSString stringWithFormat:@"/user-swipes-listed/%@/%@/", userID, key]: values};
//    
//    [self.dbRef updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        if (error) {
//            NSLog(@"%@", error);
//        } else {
//            // Remove the listing
//            [[[self.dbRef child:@"swipes-listed"] child:self.swipe.swipeID] removeValue];
//            [[[[self.dbRef child:@"user-swipes-listed"] child:userID] child:self.swipe.swipeID] removeValue];
//        }
//    }];
//}

@end