//
//  SwipeSellDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/31/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellDetailViewController.h"
#import "SwipeSellConfirmationViewController.h"
@import Firebase;

@interface SwipeSellDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@end

@implementation SwipeSellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbRef = [[FIRDatabase database] reference];
    self.swipe.sellerName = @"Jacob H.";
    self.swipe.sellerRating = 5;
    
    self.confirmPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.swipe.price];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.swipe.availableTime];
    self.confirmTimeLabel.text = [self timeStringFromDate:date];
    self.confirmLocationLabel.text = self.swipe.locationName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize size = self.topImageView.frame.size;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://placehold.it/%@x%@", @(size.width), @(size.height)]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.topImageView.image = [UIImage imageWithData:data];
}

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (void)createNewSwipe {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    NSString *key = [[self.dbRef child:@"swipes"] childByAutoId].key;
    NSDictionary *swipeDict = @{@"uid":userID,
                                @"price":@(self.swipe.price),
                                @"seller_name":self.swipe.sellerName,
                                @"listing_time":@(self.swipe.listingTime),
                                @"location_name":self.swipe.locationName,
                                @"seller_rating":@(self.swipe.sellerRating)};
    NSDictionary *childUpdates = @{[@"/swipes/" stringByAppendingString:key]: swipeDict,
                                   [NSString stringWithFormat:@"/user-swipes/%@/%@/", userID, key]: swipeDict};
    
    [self.dbRef updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            SwipeSellConfirmationViewController *swipeSellConfirmationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeSellConfirmationViewController"];
            [self presentViewController:swipeSellConfirmationViewController animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        }
    }];
}

- (IBAction)didTapContinueButton:(UIButton *)sender {
    [self createNewSwipe];
}

@end