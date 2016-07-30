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
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIStackView *ratingStackView;

@end

@implementation SwipeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSwipe:(Swipe *)swipe {
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", swipe.price];
    self.mainImageView.image = swipe.sellerImage;
    self.nameLabel.text = swipe.sellerName;
    self.timeLabel.text = @"TIME";
    self.locationLabel.text = swipe.locationName;
    
    UIImage *ratingImage = [UIImage imageNamed:@"buy-star"];
    for (int i = 0; i < swipe.sellerRating; i++) {
        UIImageView *ratingImageView = [[UIImageView alloc] initWithImage:ratingImage];
        [self.ratingStackView addSubview:ratingImageView];
    }
}

@end