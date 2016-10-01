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
#import "AddCardViewController.h"
#import "PersonalInfoViewController.h"
#import "StripePaymentService.h"
#import "SwipeMeal-Swift.h"
@import Stripe;
@import Firebase;
@import IncipiaKit;

typedef enum : NSUInteger {
    WalletCellTypeHeader,
    WalletCellTypePendingTransactions,
    WalletCellTypeCashOut,
    WalletCellTypeUpdateCreditCard,
    WalletCellTypeUpdateBankAccount
} WalletCellType;

@interface WalletViewController () <AddCardViewControllerDelegate, PersonalInfoViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) AddCardViewController *addCardViewController;
@property (strong, nonatomic) PersonalInfoViewController *personalInfoViewController;

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
    
    self.dbRef = [[FIRDatabase database] reference];
    
    // Listen for a notification telling us that a Swipe has been either sold or listed and the confirmation screen has been closed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseConfirmation) name:@"didCloseConfirmation" object:nil];

    UIColor* color = [[UIColor alloc] initWithHexString:@"272D2F"];
	UIImage* tabBarBackgroundImage = [UIImage imageWithColorWithColor:color];
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
                [self performSegueWithIdentifier:@"Segue_WalletViewController_AddCardViewController" sender:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_WalletViewController_AddCardViewController"]) {
        self.addCardViewController = (AddCardViewController *)[segue destinationViewController];
        self.addCardViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"Segue_WalletViewController_PersonalInfoViewController"]) {
        self.personalInfoViewController = (PersonalInfoViewController *)[segue destinationViewController];
        self.personalInfoViewController.delegate = self;
    }
}

- (UIAlertController *)alertControllerAddCardError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Card issue"
                                                                             message:@"There was an issue adding your card. Please make sure you're using a debit card. Double check the details and try again."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:action];
    
    return alertController;
}

- (UIAlertController *)alertControllerAddCardSuccess {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Card added"
                                                                             message:@"Your card has been added successfully."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:action];
    
    return alertController;
}

- (UIAlertController *)alertControllerPersonalInfoError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to add information"
                                                                             message:@"We were unable to add your information. Please check everything and try again."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:action];
    
    return alertController;
}

- (UIAlertController *)alertControllerPersonalInfoSuccess {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Information added"
                                                                             message:@"Your information has been added successfully."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:action];
    
    return alertController;
}

#pragma mark - AddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(AddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(AddCardViewController *)addCardViewController didCreateToken:(STPToken *)token error:(NSError *)error {
    if (error) {
        [self.presentedViewController presentViewController:[self alertControllerAddCardError] animated:YES completion:nil];
        return;
    }
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSString *name = token.card.name ? token.card.name : @"";
    NSString *address1 = token.card.addressLine1 ? token.card.addressLine1 : @"";
    NSString *address2 = token.card.addressLine2 ? token.card.addressLine2 : @"";
    NSString *city = token.card.addressCity ? token.card.addressCity : @"";
    NSString *state = token.card.addressState ? token.card.addressState : @"";
    NSString *zip = token.card.addressZip ? token.card.addressZip : @"";
   
    StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
    [paymentService addPaymentMethodWithToken:token.tokenId
                                       userID:userID
                                         name:name
                                     address1:address1
                                     address2:address2
                                         city:city
                                        state:state
                                          zip:zip
                              completionBlock:^(NSDictionary *response, NSError *error) {
                                  if (error) {
                                      [self.presentedViewController presentViewController:[self alertControllerAddCardError] animated:YES completion:nil];
                                  } else {
                                      [self.presentedViewController presentViewController:[self alertControllerAddCardSuccess] animated:YES completion:nil];
                                  }
                              }
     ];
}

#pragma mark - PersonalInfoViewControllerDelegate

- (void)personalInfoViewControllerDidCancel:(PersonalInfoViewController *)personalInfoViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)personalInfoViewController:(PersonalInfoViewController *)personalInfoViewController didCreatePersonalInfo:(NSDictionary *)info {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSString *month = [info objectForKey:@"month"] ? [info objectForKey:@"month"] : @"";
    NSString *day = [info objectForKey:@"day"] ? [info objectForKey:@"day"] : @"";
    NSString *year = [info objectForKey:@"year"] ? [info objectForKey:@"year"] : @"";
    NSString *ssn = [info objectForKey:@"ssn"] ? [info objectForKey:@"ssn"] : @"";
    
    StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
    [paymentService addPayoutVerificationWithUserID:userID
                                           dobMonth:month
                                             dobDay:day
                                            dobYear:year
                                                ssn:ssn
                                    completionBlock:^(NSDictionary *response, NSError *error) {
                                        if (error) {
                                            [self.presentedViewController presentViewController:[self alertControllerPersonalInfoError] animated:YES completion:nil];
                                        } else {
                                            [self.presentedViewController presentViewController:[self alertControllerPersonalInfoSuccess] animated:YES completion:nil];
                                        }
                                    }
     ];
}

@end
