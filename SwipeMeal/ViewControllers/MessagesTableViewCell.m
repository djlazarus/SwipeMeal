//
//  MessagesTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesTableViewCell.h"

@interface MessagesTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MessagesTableViewCell

- (void)setUpWithMessage:(Message *)message {
    self.mainImageView.image = message.mainImage;
    self.nameLabel.text = message.nameText;
    self.dateTimeLabel.text = message.dateTimeText;
    self.messageLabel.text = message.messageText;
}

@end