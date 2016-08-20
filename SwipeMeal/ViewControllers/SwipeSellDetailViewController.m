//
//  SwipeSellDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/31/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellDetailViewController.h"
#import "SwipeSellConfirmationViewController.h"
#import "SwipeService.h"
#import "MessageService.h"
@import Firebase;

@interface SwipeSellDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) SwipeService *swipeService;
@property (strong, nonatomic) MessageService *messageService;

@end

@implementation SwipeSellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.topImageView.layer.masksToBounds = YES;
    self.swipeService = [SwipeService sharedSwipeService];
    self.messageService = [MessageService sharedMessageService];

    self.confirmPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.swipe.price];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.swipe.availableTime];
    self.confirmTimeLabel.text = [self timeStringFromDate:date];
    self.confirmLocationLabel.text = self.swipe.locationName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    
//    CGSize size = self.topImageView.frame.size;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://placehold.it/%@x%@", @(size.width), @(size.height)]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    self.topImageView.image = [UIImage imageWithData:data];
}

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (void)createNewSwipe {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSString *userName = [FIRAuth auth].currentUser.displayName;
    
    // Listing timestamp
    NSDate *listingDate = [NSDate date];
    NSTimeInterval listingTimestamp = [listingDate timeIntervalSince1970];

    // Expiration timestamp
    NSDate *expirationDate = [[NSDate dateWithTimeIntervalSince1970:self.swipe.availableTime] dateByAddingTimeInterval:60 * 60 * 24];
    NSTimeInterval expirationTimestamp = [expirationDate timeIntervalSince1970];
    
    NSDictionary *swipeDict = @{@"uid":userID,
                                @"seller_name":userName,
                                @"listing_time":@(listingTimestamp),
                                @"expiration_time":@(expirationTimestamp),
                                @"available_time":@(self.swipe.availableTime),
                                @"price":@(self.swipe.price),
                                @"location_name":self.swipe.locationName,
                                @"seller_rating":@(self.swipe.sellerRating)};
    
    [self.swipeService createNewSwipeWithValues:swipeDict withCompletionBlock:^(NSString *swipeKey) {
        // Create initial message
        NSString *body = @"Your Swipe has been posted. You can accept Swipe requests via Messages.";
        NSDictionary *messageValues = @{@"swipe_id":swipeKey,
                                        @"from_uid":kSwipeMealSystemUserID,
                                        @"to_uid":userID,
                                        @"timestamp":@(listingTimestamp),
                                        @"unread":@(YES),
                                        @"body":body};
        [self.messageService createNewMessageWithValues:messageValues withCompletionBlock:^{
            SwipeSellConfirmationViewController *swipeSellConfirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeSellConfirmationViewController"];
            [self.tabBarController presentViewController:swipeSellConfirmationViewController animated:YES completion:nil];
        }];
    }];
}

- (IBAction)didTapContinueButton:(UIButton *)sender {
    [self createNewSwipe];
}

@end