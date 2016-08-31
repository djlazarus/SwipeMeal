//
//  WalletViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletHeaderTableViewCell.h"
#import "WalletMainTableViewCell.h"
#import "StripePaymentService.h"
#import "SwipeMeal-Swift.h"

@import IncipiaKit;

typedef enum : NSUInteger {
    WalletCellTypeHeader,
    WalletCellTypePendingTransactions,
    WalletCellTypeCashOut,
    WalletCellTypeUpdateCreditCard
} WalletCellType;

@interface WalletViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StripePaymentService *paymentService = [[StripePaymentService alloc] init];
    [paymentService requestPurchaseWithSwipeID:@"12345" buyerID:@"cus_93GqKatuD8AzK4" sellerID:@"acct_18l26cKNe9fQVF0o" completionBlock:^(NSString *stripeTransactionID, NSError *error) {
        if (error) {
            // do something
        } else {
            // Create a SwipeTransaction object and save to Firebase
        }
    }];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    // Listen for a notification telling us that a Swipe has been either sold or listed and the confirmation screen has been closed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseConfirmation) name:@"didCloseConfirmation" object:nil];
    
    UIColor* color = [[UIColor alloc] initWithHexString:@"272D2F"];
    UIImage* tabBarBackgroundImage = [UIImage imageWithColor:color];
    [self.tabBarController.tabBar setBackgroundImage:tabBarBackgroundImage];
}

- (void)didCloseConfirmation {
    // Switch to Messages
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.tabBarController.selectedIndex = 1;
}

- (NSArray *)dataRows {
    NSArray *rows = @[@(WalletCellTypeHeader), @(WalletCellTypePendingTransactions), @(WalletCellTypeCashOut), @(WalletCellTypeUpdateCreditCard)];
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
        case WalletCellTypeHeader:
            return 175;
            
        default:
            return 125;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self dataRows];
    NSNumber *cellType = [rows objectAtIndex:indexPath.row];
    
    if ([cellType isEqual:@(WalletCellTypeHeader)]) {
        WalletHeaderTableViewCell *cell = (WalletHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WalletHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.mainText = [NSString stringWithFormat:@"YOU HAVE $%@ IN YOUR WALLET", @225];
        return cell;
    } else if ([cellType isEqual:@(WalletCellTypePendingTransactions)]) {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"wallet-pending"];
        cell.headlineText = @"Pending Transactions";
        cell.subheadText = @"Pending SwipeMeal transactions";
        return cell;
    } else if ([cellType isEqual:@(WalletCellTypeCashOut)]) {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"wallet-cashout"];
        cell.headlineText = @"Cash Out";
        cell.subheadText = @"Cash out your wallet";
        return cell;
    } else if ([cellType isEqual:@(WalletCellTypeUpdateCreditCard)]) {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"wallet-update-credit-card"];
        cell.headlineText = @"Update Credit Card";
        cell.subheadText = @"Edit your credit card information";
        return cell;
    } else {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            [self performSegueWithIdentifier:@"Segue_WalletViewController_TransactionsViewController" sender:nil];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"Segue_WalletViewController_CashOutViewController" sender:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"Segue_WalletViewController_UpdateCardViewController" sender:nil];
            break;
            
        default:
            break;
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"Segue_HomeViewController_SwipeBuyViewController"]) {
//        SwipeBuyViewController *swipeBuyViewController = (SwipeBuyViewController *)[segue destinationViewController];
//        // ?
//    }
//}

@end