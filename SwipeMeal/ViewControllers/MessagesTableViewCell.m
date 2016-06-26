//
//  MessagesTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesTableViewCell.h"
#import "CircularIndicatorView.h"

@interface MessagesTableViewCell ()

@property (weak, nonatomic) IBOutlet CircularIndicatorView *unreadIndicatorView;
@property (weak, nonatomic) IBOutlet UIStackView *messageStackView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MessagesTableViewCell

- (void)setUpWithMessage:(Message *)message {
    if (message.isUnread) {
        self.unreadIndicatorView.fillColor = [UIColor colorWithRed:0.523 green:0.772 blue:0.964 alpha:1.0];
        self.unreadIndicatorView.backgroundColor = [UIColor clearColor];
    } else {
        self.unreadIndicatorView.hidden = YES;
    }
    
    self.mainImageView.image = message.mainImage;
    self.nameLabel.text = message.nameText;
    self.dateTimeLabel.text = message.dateTimeText;
    self.messageLabel.text = message.messageText;
}

- (CGFloat)messageHeight {
    // Return the height of the message (plus some padding)
    CGFloat height = self.messageStackView.frame.size.height;
    return height + 60;
}

@end