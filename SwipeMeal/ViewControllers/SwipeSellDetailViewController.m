//
//  SwipeSellDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/31/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellDetailViewController.h"

@interface SwipeSellDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation SwipeSellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.swipe.price];
    self.confirmTimeLabel.text = [NSString stringWithFormat:@"%f", self.swipe.availableTime];
    self.confirmLocationLabel.text = self.swipe.locationName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize size = self.topImageView.frame.size;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://placehold.it/%@x%@", @(size.width), @(size.height)]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.topImageView.image = [UIImage imageWithData:data];
}

- (IBAction)didTapContinueButton:(UIButton *)sender {
    
}

@end