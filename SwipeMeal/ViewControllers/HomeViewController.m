//
//  HomeViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderTableViewCell.h"
#import "HomeMainTableViewCell.h"
#import "SwipeListViewController.h"
#import "SwipeMeal-Swift.h"

typedef enum : NSUInteger {
    HomeCellTypeHeader,
    HomeCellTypeBuy,
    HomeCellTypeSell
} HomeCellType;

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.translucent = NO;
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
}

- (NSArray *)dataRows {
    NSArray *rows = @[@(HomeCellTypeHeader), @(HomeCellTypeBuy), @(HomeCellTypeSell)];
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self dataRows];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self dataRows];
    NSNumber *cellType = [rows objectAtIndex:indexPath.row];
    
    switch (cellType.integerValue) {
        case HomeCellTypeHeader:
            return 240;
            
        default:
            return 145;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self dataRows];
    NSNumber *cellType = [rows objectAtIndex:indexPath.row];
    
    if ([cellType isEqual:@(HomeCellTypeHeader)]) {
        HomeHeaderTableViewCell *cell = (HomeHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainImage = [UIImage imageNamed:@"home-header"];
        return cell;
    } else if ([cellType isEqual:@(HomeCellTypeBuy)]) {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"home-buy"];
        cell.headlineText = @"Buy Swipes";
        cell.subheadText = @"Search for Swipes near you";
        return cell;
    } else if ([cellType isEqual:@(HomeCellTypeSell)]) {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"home-sell"];
        cell.headlineText = @"Sell Swipes";
        cell.subheadText = @"Sell your extra Swipes";
        return cell;
    } else {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            [self performSegueWithIdentifier:@"Segue_HomeViewController_SwipeListViewController" sender:nil];
            break;
            
        case 2:
            break;
            
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_HomeViewController_SwipeListViewController"]) {
        SwipeListViewController *swipeListViewController = (SwipeListViewController *)[segue destinationViewController];
        // ?
    }
}

@end