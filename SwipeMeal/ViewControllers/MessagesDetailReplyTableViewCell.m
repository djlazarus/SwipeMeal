//
//  MessagesDetailReplyTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/3/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailReplyTableViewCell.h"

@interface MessagesDetailReplyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *checkboxView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation MessagesDetailReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkboxView.layer.borderColor = [UIColor blackColor].CGColor;
    self.checkboxView.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.checkboxView.backgroundColor = [UIColor blackColor];
    } else {
        self.checkboxView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setMainText:(NSString *)text {
    self.mainLabel.text = text;
}

@end