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

@end

@implementation WalletHeaderTableViewCell

- (void)setMainImage:(UIImage *)image {
    self.mainImageView.image = image;
}

- (UIImage *)mainImage {
    return self.mainImageView.image;
}

@end
