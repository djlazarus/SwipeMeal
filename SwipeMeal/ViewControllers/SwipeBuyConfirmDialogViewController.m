//
//  SwipeBuyConfirmDialogViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyConfirmDialogViewController.h"
#import "SwipeBuyConfirmationViewController.h"
#import "SwipeService.h"
#import "StripePaymentService.h"
#import "MessageService.h"
#import "SwipeMeal-Swift.h"
@import Firebase;

@interface SwipeBuyConfirmDialogViewController ()

@property (weak, nonatomic) IBOutlet CircularImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) SwipeService *swipeService;
@property (strong, nonatomic) MessageService *messageService;
@property (strong, nonatomic) StripePaymentService *paymentService;

@end

@implementation SwipeBuyConfirmDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Listen for a notification telling us that a Swipe has been either sold or listed and the confirmation screen has been closed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseConfirmation) name:@"didCloseConfirmation" object:nil];

    self.dbRef = [[FIRDatabase database] reference];
    self.swipeService = [SwipeService sharedSwipeService];
    self.messageService = [MessageService sharedMessageService];
    self.paymentService = [StripePaymentService sharedPaymentService];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld Swipe", (long)self.swipe.listPrice / 100];
    self.locationLabel.text = [NSString stringWithFormat:@"@ %@", self.swipe.locationName];
    self.sellerLabel.text = [NSString stringWithFormat:@"Sold by: %@", self.swipe.listingUserName];
    self.timeLabel.text = [NSString stringWithFormat:@"Available: %f", self.swipe.availableTime];
    
    self.acceptButton.layer.borderWidth = 1.0;
    self.acceptButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)notifySwipeSeller {
    NSString *userName = [FIRAuth auth].currentUser.displayName;
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];

    // Create initial message
    NSString *body = [NSString stringWithFormat:@"Hello, I'd like to purchase your Swipe for $%ld.", (long)self.swipe.listPrice / 100];
    NSDictionary *messageValues = @{@"swipe_id":self.swipe.swipeID,
                                    @"from_uid":userID,
                                    @"from_name":userName,
                                    @"to_uid":self.swipe.listingUserID,
                                    @"timestamp":@(timestamp),
                                    @"unread":@(YES),
                                    @"is_offer_message":@(YES),
                                    @"body":body};
    
    [self.messageService createNewMessageWithValues:messageValues withCompletionBlock:^{
        SwipeBuyConfirmationViewController *swipeBuyConfirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeBuyConfirmationViewController"];
        swipeBuyConfirmationViewController.swipe = self.swipe;
        [self presentViewController:swipeBuyConfirmationViewController animated:YES completion:nil];
    }];
}

- (void)didCloseConfirmation {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didTapAcceptButton:(UIButton *)sender {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[self.dbRef child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *stripeCustomerID = [snapshot.value objectForKey:@"stripe_customer_id"];
        if (stripeCustomerID.length > 0) {
            StripePaymentService *paymentService = [StripePaymentService sharedPaymentService];
            [paymentService requestPurchaseWithSwipeID:self.swipe.swipeID buyerID:stripeCustomerID completionBlock:^(SwipeTransaction *transaction, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    // save to Firebase
                    [self notifySwipeSeller];
                    NSLog(@"%@", transaction);
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
}

- (IBAction)didTapCancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end