//
//  WalletHeaderTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "WalletHeaderTableViewCell.h"

@interface WalletHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation WalletHeaderTableViewCell

- (void)setMainImage:(UIImage *)image {
    self.mainImageView.image = image;
}

- (UIImage *)mainImage {
    return self.mainImageView.image;
}

- (void)setMainText:(NSString *)text {
    self.mainLabel.text = text;
}

- (NSString *)mainText {
    return self.mainLabel.text;
}

@end