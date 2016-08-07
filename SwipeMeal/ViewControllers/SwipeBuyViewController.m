//
//  SwipeBuyViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyViewController.h"
#import "Swipe.h"
#import "SwipeBuyTableViewCell.h"
#import "SwipeBuyDetailViewController.h"
#import "SwipeStore.h"
@import Firebase;

@interface SwipeBuyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SwipeStore *swipeStore;
@property (strong, nonatomic) Swipe *selectedSwipe;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@end

@implementation SwipeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbRef = [[FIRDatabase database] referenceWithPath:@"/swipes-listed/"];
    self.swipeStore = [SwipeStore sharedSwipeStore];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self listenForEvents];
}

- (void)listenForEvents {
    [self.dbRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Test for expired Swipe
        if (![self snapshotIsExpired:snapshot]) {
            // Build Swipe
            Swipe *swipe = [self swipeWithSnapshot:snapshot];
            if ([_swipeStore containsSwipeKey:swipe.swipeID]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[self.swipeStore swipesSortedByPriceAscending] count] - 1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.swipeStore addSwipe:swipe forKey:swipe.swipeID];
                NSLog(@"ADDED: %@", swipe);
                [self.tableView reloadData];
            }
        }
    }];
    
    [self.dbRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Swipe *swipe = [self swipeWithSnapshot:snapshot];
        [self.swipeStore removeSwipe:swipe forKey:swipe.swipeID];
        NSLog(@"REMOVED: %@", snapshot);
        [self.tableView reloadData];
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

- (Swipe *)swipeWithSnapshot:(FIRDataSnapshot *)snapshot {
    Swipe *swipe = [[Swipe alloc] init];
    swipe.swipeID = snapshot.key;
    swipe.sellerName = [snapshot.value objectForKey:@"seller_name"];
    swipe.sellerRating = [[snapshot.value objectForKey:@"seller_rating"] integerValue];
    swipe.price = [[snapshot.value objectForKey:@"price"] integerValue];
    swipe.locationName = [snapshot.value objectForKey:@"location_name"];
    swipe.listingTime = [[snapshot.value objectForKey:@"listing_time"] floatValue];
    swipe.expireTime = [[snapshot.value objectForKey:@"expiration_time"] floatValue];
    
    return swipe;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_SwipeBuyViewController_SwipeBuyDetailViewController"]) {
        SwipeBuyDetailViewController *swipeBuyDetailViewController = (SwipeBuyDetailViewController *)[segue destinationViewController];
        swipeBuyDetailViewController.swipe = self.selectedSwipe;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[self.swipeStore swipesSortedByPriceAscending] count];
    return count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeBuyTableViewCell *cell = (SwipeBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwipeBuyTableViewCell"];
    Swipe *swipe = [[self.swipeStore swipesSortedByPriceAscending] objectAtIndex:indexPath.row];
    cell.swipe = swipe;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSwipe = [[self.swipeStore swipesSortedByPriceAscending] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Segue_SwipeBuyViewController_SwipeBuyDetailViewController" sender:nil];
}


@end