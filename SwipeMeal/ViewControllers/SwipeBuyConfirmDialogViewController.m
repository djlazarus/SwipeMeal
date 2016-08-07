//
//  SwipeBuyConfirmDialogViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyConfirmDialogViewController.h"
#import "SwipeMeal-Swift.h"

@interface SwipeBuyConfirmDialogViewController ()
@property (weak, nonatomic) IBOutlet CircularImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation SwipeBuyConfirmDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld Swipe", (long)self.swipe.price];
    self.locationLabel.text = [NSString stringWithFormat:@"@ %@", self.swipe.locationName];
    self.sellerLabel.text = [NSString stringWithFormat:@"Sold by: %@", self.swipe.sellerName];
    self.timeLabel.text = [NSString stringWithFormat:@"Available: %f", self.swipe.availableTime];
    
    self.acceptButton.layer.borderWidth = 1.0;
    self.acceptButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
}

- (IBAction)didTapAcceptButton:(UIButton *)sender {
}

- (IBAction)didTapCancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end