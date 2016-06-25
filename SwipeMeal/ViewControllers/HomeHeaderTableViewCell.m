//
//  HomeHeaderTableViewCell.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "HomeHeaderTableViewCell.h"

@interface HomeHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation HomeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setMainImage:(UIImage *)image {
    self.mainImageView.image = image;
}

- (UIImage *)mainImage {
    return self.mainImageView.image;
}

@end