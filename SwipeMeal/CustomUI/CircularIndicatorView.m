//
//  CircularIndicatorView.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "CircularIndicatorView.h"

@implementation CircularIndicatorView {
    UIColor *_fillColor;
}

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor {
    if (self = [super initWithFrame:frame]) {
        _fillColor = fillColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect insetFrame = CGRectInset(rect, 2, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, insetFrame);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextFillEllipseInRect(context, insetFrame);
    
    UIGraphicsEndImageContext();
}

- (void)setFillColor:(UIColor *)color {
    _fillColor = color;
    [self setNeedsDisplay];
}

- (UIColor *)fillColor {
    return _fillColor;
}

@end