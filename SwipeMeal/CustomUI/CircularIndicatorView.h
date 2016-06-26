//
//  CircularIndicatorView.h
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularIndicatorView : UIView

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor;
@property (strong, nonatomic) UIColor *fillColor;

@end