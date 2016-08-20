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

@end

@implementation SwipeBuyConfirmDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Listen for a notification telling us that a Swipe has been either sold or listed and the confirmation screen has been closed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCloseConfirmation) name:@"didCloseConfirmation" object:nil];

    self.dbRef = [[FIRDatabase database] reference];
    self.swipeService = [SwipeService sharedSwipeService];
    self.messageService = [MessageService sharedMessageService];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld Swipe", (long)self.swipe.price];
    self.locationLabel.text = [NSString stringWithFormat:@"@ %@", self.swipe.locationName];
    self.sellerLabel.text = [NSString stringWithFormat:@"Sold by: %@", self.swipe.sellerName];
    self.timeLabel.text = [NSString stringWithFormat:@"Available: %f", self.swipe.availableTime];
    
    self.acceptButton.layer.borderWidth = 1.0;
    self.acceptButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)buySwipe {
    NSString *userName = [FIRAuth auth].currentUser.displayName;
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSDictionary *swipeDict = @{@"uid":userID,
                                @"sold_time":@(timestamp),
                                @"price":@(self.swipe.price),
                                @"seller_name":self.swipe.sellerName,
                                @"listing_time":@(self.swipe.listingTime),
                                @"location_name":self.swipe.locationName,
                                @"seller_rating":@(self.swipe.sellerRating)};
    NSDictionary *childUpdates = @{[@"/swipes-sold/" stringByAppendingString:self.swipe.swipeID]: swipeDict,
                                   [NSString stringWithFormat:@"/user-swipes-sold/%@/%@/", userID, self.swipe.swipeID]: swipeDict};
    
    [self.dbRef updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            // Remove the listing
            [[[self.dbRef child:@"swipes-listed"] child:self.swipe.swipeID] removeValue];
            [[[[self.dbRef child:@"user-swipes-listed"] child:userID] child:self.swipe.swipeID] removeValue];
            
            // Create initial message
            NSString *body = [NSString stringWithFormat:@"Hello, I'd like to purchase your Swipe for $%ld.", (long)self.swipe.price];
            NSDictionary *messageValues = @{@"swipe_id":self.swipe.swipeID,
                                            @"from_uid":userID,
                                            @"from_name":userName,
                                            @"to_uid":self.swipe.uid,
                                            @"timestamp":@(timestamp),
                                            @"unread":@(YES),
                                            @"body":body};
            [self.messageService createNewMessageWithValues:messageValues withCompletionBlock:nil];
            
            SwipeBuyConfirmationViewController *swipeBuyConfirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeBuyConfirmationViewController"];
            swipeBuyConfirmationViewController.swipe = self.swipe;
            [self presentViewController:swipeBuyConfirmationViewController animated:YES completion:nil];
        }
    }];
}

- (void)didCloseConfirmation {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)didTapAcceptButton:(UIButton *)sender {
    [self buySwipe];
}

- (IBAction)didTapCancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end