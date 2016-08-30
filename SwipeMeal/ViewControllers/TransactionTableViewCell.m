//
//  TransactionTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "TransactionTableViewCell.h"
@import Firebase;

@interface TransactionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpWithSwipe:(Swipe *)swipe {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    if ([userID isEqualToString:swipe.uid]) {
        self.nameLabel.text = swipe.sellerName;
    }
}

@end