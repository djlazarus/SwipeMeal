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
@import Firebase;

@interface SwipeBuyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *swipes;
@property (strong, nonatomic) Swipe *selectedSwipe;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@end

@implementation SwipeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbRef = [[FIRDatabase database] reference];
    self.swipes = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getInitialData];
}

- (void)getInitialData {
    [[self.dbRef child:@"swipes"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@", snapshot.value);
        
        for (NSString *key in snapshot.value ) {
            NSDictionary *swipeDict = [snapshot.value objectForKey:key];
            Swipe *swipe = [self swipeWithAttrs:swipeDict];
            [self.swipes addObject:swipe];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.swipes count] - 1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

//- (void)listenForEvents {
//    [self.dbRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSLog(@"ADDED: %@", snapshot);
//    }];
//    
//    [self.dbRef observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSLog(@"REMOVED: %@", snapshot);
//    }];
//}

- (Swipe *)swipeWithAttrs:(NSDictionary *)attrs {
    Swipe *swipe = [[Swipe alloc] init];
    swipe.sellerName = [attrs objectForKey:@"seller_name"];
    swipe.sellerRating = [[attrs objectForKey:@"seller_rating"] integerValue];
    swipe.price = [[attrs objectForKey:@"price"] integerValue];
    swipe.locationName = [attrs objectForKey:@"location_name"];
    swipe.listingTime = [[attrs objectForKey:@"listing_time"] floatValue];
    
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
    NSInteger count = [self.swipes count];
    return count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeBuyTableViewCell *cell = (SwipeBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwipeBuyTableViewCell"];
    Swipe *swipe = [self.swipes objectAtIndex:indexPath.row];
    cell.swipe = swipe;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSwipe = [self.swipes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Segue_SwipeBuyViewController_SwipeBuyDetailViewController" sender:nil];
}


@end