//
//  SwipeBuyConfirmationViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyConfirmationViewController.h"

@interface SwipeBuyConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;

@end

@implementation SwipeBuyConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationLabel.text = self.swipe.locationName;
    self.sellerLabel.text = self.swipe.listingUserName;
}

- (IBAction)didTapMessagesButton:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		 [[NSNotificationCenter defaultCenter] postNotificationName:@"didCloseConfirmation" object:nil];
    }];
}

@end