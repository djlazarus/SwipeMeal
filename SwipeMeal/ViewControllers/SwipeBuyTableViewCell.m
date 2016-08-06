//
//  SwipeBuyTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyTableViewCell.h"
@import Firebase;

@interface SwipeBuyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIStackView *ratingStackView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView5;

@end

@implementation SwipeBuyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSwipe:(Swipe *)swipe {
    [self startDownloadingProfileImage];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)swipe.price];
    self.nameLabel.text = swipe.sellerName;
    self.timeLabel.text = @"TIME";
    self.locationLabel.text = swipe.locationName;

    UIImage *locationImage = [UIImage imageNamed:@"buy-location"];
    self.locationImageView.image = [locationImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.locationImageView.tintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1.0];
    
    UIImage *timeImage = [UIImage imageNamed:@"buy-time"];
    self.timeImageView.image = [timeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.timeImageView.tintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1.0];
    
    NSArray *stars = @[self.ratingImageView1, self.ratingImageView2, self.ratingImageView3, self.ratingImageView4, self.ratingImageView5];
    for (int i = 0; i < swipe.sellerRating; i++) {
        UIImage *starImage = [UIImage imageNamed:@"buy-star"];
        UIImageView *starImageView = [stars objectAtIndex:i];
        starImageView.image = [starImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        starImageView.tintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1.0];
    }
}

- (void)startDownloadingProfileImage {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    FIRStorage *storage = [FIRStorage storage];
    NSString *imagePath = [NSString stringWithFormat:@"profileImages/%@.jpg", userID];
    FIRStorageReference *pathRef = [storage referenceWithPath:imagePath];
    [pathRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.mainImageView.image = image;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end