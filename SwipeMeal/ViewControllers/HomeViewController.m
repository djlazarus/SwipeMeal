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

typedef enum : NSUInteger {
    HomeCellTypeHeader,
    HomeCellTypeBuy,
    HomeCellTypeSell
} HomeCellType;

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
        cell.mainImage = [UIImage imageNamed:@"temp-food-image"];
        return cell;
    } else if ([cellType isEqual:@(HomeCellTypeBuy)]) {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"temp-home-icon"];
        cell.headlineText = @"Buy Swipes";
        cell.subheadText = @"Search for Swipes near you";
        return cell;
    } else if ([cellType isEqual:@(HomeCellTypeSell)]) {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"temp-home-icon"];
        cell.headlineText = @"Sell Swipes";
        cell.subheadText = @"Sell your extra Swipes";
        return cell;
    } else {
        HomeMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMainTableViewCell" forIndexPath:indexPath];
        return cell;
    }
}

@end