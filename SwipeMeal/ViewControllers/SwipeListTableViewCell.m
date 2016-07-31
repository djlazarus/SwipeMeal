//
//  SwipeListTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeListTableViewCell.h"

@interface SwipeListTableViewCell ()

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

@implementation SwipeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSwipe:(Swipe *)swipe {
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)swipe.price];
    self.mainImageView.image = swipe.sellerImage;
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

@end