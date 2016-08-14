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
#import "SwipeService.h"
@import Firebase;

@interface SwipeBuyViewController () <SwipeServiceDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SwipeService *swipeService;
@property (strong, nonatomic) Swipe *selectedSwipe;

@end

@implementation SwipeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeService = [SwipeService sharedSwipeService];
    self.swipeService.delegate = self;
    [self.swipeService listenForEvents];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_SwipeBuyViewController_SwipeBuyDetailViewController"]) {
        SwipeBuyDetailViewController *swipeBuyDetailViewController = (SwipeBuyDetailViewController *)[segue destinationViewController];
        swipeBuyDetailViewController.swipe = self.selectedSwipe;
    }
}

#pragma mark - SwipeServiceDelegate

- (void)swipeServiceDidAddSwipe:(SwipeService *)service {
    [self.tableView reloadData];
}

- (void)swipeServiceDidRemoveSwipe:(SwipeService *)service {
    [self.tableView reloadData];
}

- (void)swipeService:(SwipeService *)service didUpdateSwipeAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.swipeService.swipes count];
    return count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwipeBuyTableViewCell *cell = (SwipeBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwipeBuyTableViewCell"];
    Swipe *swipe = [self.swipeService.swipes objectAtIndex:indexPath.row];
    cell.swipe = swipe;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSwipe = [self.swipeService.swipes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Segue_SwipeBuyViewController_SwipeBuyDetailViewController" sender:nil];
}


@end