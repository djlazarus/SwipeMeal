//
//  MessagesDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import "MessagesDetailReplyViewController.h"
#import "MessagesDetailChildViewController.h"
#import "SwipeService.h"
#import "StripePaymentService.h"
#import "SwipeMeal-Swift.h"
@import Firebase;

@interface MessagesDetailViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonnull) SwipeService *swipeService;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@end

@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sellSwipe) name:@"didTapAcceptButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReplyViewController) name:@"didTapReplyButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadConfirmationViewController) name:@"didTapSendButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTransaction) name:@"didTapCancelTransactionButton" object:nil];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];

    self.pageViewController.view.frame = self.view.bounds;
    [self setViewControllerAtIndex:0];
    
    self.swipeService = [SwipeService sharedSwipeService];
    self.dbRef = [[FIRDatabase database] reference];
}

- (void)sellSwipe {
    NSString *userID = self.message.fromUID;
    [[[self.dbRef child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *stripeCustomerStatus = [snapshot.value objectForKey:@"stripe_customer_status"];
        if ([stripeCustomerStatus isEqualToString:@"active"]) {
            StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
            [paymentService requestPurchaseWithSwipeID:self.message.swipeID buyerID:userID completionBlock:^(NSDictionary *response, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    [SMDatabaseLayer getReferralUIDForUserWithUID:userID callback:^(NSString *referralID) {
                        if (referralID) {
                            BOOL hasMadeFirstPurchaseOrSale = [SwipeMealUserStorage hasMadeFirstPurchaseOrSale];
                            if (!hasMadeFirstPurchaseOrSale && referralID) {
                                [paymentService requestReferralPaymentWithReferralID:referralID userID:userID amount:@100 completionBlock:^(NSDictionary *response, NSError *error) {
                                    if (error) {
                                        NSLog(@"Referral error: %@", error);
                                    } else {
                                        NSLog(@"Referral response: %@", response);
                                        [SwipeMealUserStorage setHasMadeFirstPurchaseOrSale:YES];
                                    }
                                }];
                            }
                        }
                    }];

                    NSLog(@"Payments response: %@", response);
                }
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"More info needed"
                                                                                     message:@"Please enter your debit card information on the Wallet screen in order to buy this Swipe."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    [self.swipeService buySwipeWithSwipeID:self.message.swipeID completionBlock:^(NSError *error) {
        if (!error) {
            [self loadReplyViewController];
        }
    }];
}

- (void)loadReplyViewController {
    [self setViewControllerAtIndex:1];
}

- (void)loadConfirmationViewController {
    [self setViewControllerAtIndex:2];
}

- (void)cancelTransaction {
    [self.swipeService getSwipeWithSwipeID:self.message.swipeID completionBlock:^(Swipe *swipe) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cancel Swipe"
                                                                                 message:@"Are you sure you want to cancel this Swipe?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Yes, Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
            [paymentService requestRefundWithTransactionID:swipe.swipeTransactionID completionBlock:^(NSDictionary *response, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Swipe Cancelled"
                                                                                             message:@"This Swipe has been cancelled successfully."
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alertController addAction:action1];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
        
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)setViewControllerAtIndex:(NSInteger)index {
    NSArray *viewControllersIDs = @[@"MessagesDetailChoiceViewController",
                                    @"MessagesDetailReplyViewController",
                                    @"MessagesDetailReplyConfirmViewController"];
    
    NSString *viewControllerID = [viewControllersIDs objectAtIndex:index];
    MessagesDetailChildViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    viewController.index = index;
    viewController.message = self.message;
    
    NSArray *viewControllers = @[viewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


@end
