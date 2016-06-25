//
//  HomeMainTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "HomeMainTableViewCell.h"

@interface HomeMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadLabel;

@end

@implementation HomeMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.headlineLabel.textColor = [UIColor whiteColor];
    self.subheadLabel.textColor = [UIColor whiteColor];
}

- (void)setIconImage:(UIImage *)image {
    self.iconImageView.image = image;
}

- (void)setHeadlineText:(NSString *)text {
    self.headlineLabel.text = text;
}

- (void)setSubheadText:(NSString *)text {
    self.subheadLabel.text = text;
}

@end