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
#import "SwipeTransaction.h"
#import "SwipeMeal-Swift.h"
@import Stripe;
@import IncipiaKit;

typedef enum : NSUInteger {
    WalletCellTypeHeader,
    WalletCellTypePendingTransactions,
    WalletCellTypeCashOut,
    WalletCellTypeUpdateCreditCard,
    WalletCellTypeUpdateBankAccount
} WalletCellType;

@interface WalletViewController () <STPAddCardViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = [UIView new];
    
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
//    NSArray *rows = @[@(WalletCellTypeHeader), @(WalletCellTypePendingTransactions), @(WalletCellTypeCashOut), @(WalletCellTypeUpdateCreditCard), @(WalletCellTypeUpdateBankAccount)];
    NSArray *rows = @[@(WalletCellTypeHeader), @(WalletCellTypeUpdateCreditCard), @(WalletCellTypeUpdateBankAccount)];
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
            return 145;
            
        default:
            return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self dataRows];
    NSNumber *cellType = [rows objectAtIndex:indexPath.row];
    
    if ([cellType isEqual:@(WalletCellTypeHeader)]) {
        WalletHeaderTableViewCell *cell = (WalletHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WalletHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.mainText = [NSString stringWithFormat:@"YOU HAVE $%@ IN YOUR WALLET", @225];
        return cell;
//    } else if ([cellType isEqual:@(WalletCellTypePendingTransactions)]) {
//        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.iconImage = [UIImage imageNamed:@"wallet-pending"];
//        cell.headlineText = @"Pending Transactions";
//        cell.subheadText = @"Pending SwipeMeal transactions";
//        return cell;
//    } else if ([cellType isEqual:@(WalletCellTypeCashOut)]) {
//        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.iconImage = [UIImage imageNamed:@"wallet-cashout"];
//        cell.headlineText = @"Cash Out";
//        cell.subheadText = @"Cash out your wallet";
//        return cell;
    } else if ([cellType isEqual:@(WalletCellTypeUpdateCreditCard)]) {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"wallet-update-credit-card"];
        cell.headlineText = @"Update Debit Card";
        cell.subheadText = @"Edit your debit card information to enable buying";
        return cell;
    } else if ([cellType isEqual:@(WalletCellTypeUpdateBankAccount)]) {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage = [UIImage imageNamed:@"wallet-update-credit-card"];
        cell.headlineText = @"Update Personal Info";
        cell.subheadText = @"Edit your personal information to enable selling";
        return cell;
    } else {
        WalletMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletMainTableViewCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (indexPath.row) {
//            case 1:
//                [self performSegueWithIdentifier:@"Segue_WalletViewController_TransactionsViewController" sender:nil];
//                break;
//                
//            case 2:
//                [self performSegueWithIdentifier:@"Segue_WalletViewController_CashOutViewController" sender:nil];
//                break;
                
            case 1: {
                STPPaymentConfiguration *config = [STPPaymentConfiguration sharedConfiguration];
                config.requiredBillingAddressFields = STPBillingAddressFieldsFull;
                
                STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] initWithConfiguration:config theme:[STPTheme defaultTheme]];
                addCardViewController.delegate = self;

                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
                [self presentViewController:navigationController animated:YES completion:nil];
                break;
            }
            
            case 2:
                [self performSegueWithIdentifier:@"Segue_WalletViewController_PersonalInfoViewController" sender:nil];
                break;

            default:
                break;
        }
    });
}

#pragma mark - STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController didCreateToken:(STPToken *)token completion:(STPErrorBlock)completion {
    StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
    [paymentService requestPurchaseWithSwipeID:@"12345" buyerID:@"cus_93GqKatuD8AzK4" sellerID:@"acct_18l26cKNe9fQVF0o" completionBlock:^(SwipeTransaction *transaction, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            // save to Firebase
            NSLog(@"%@", transaction);
        }
    }];
}

@end