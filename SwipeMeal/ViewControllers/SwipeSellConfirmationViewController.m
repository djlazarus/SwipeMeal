//
//  SwipeSellConfirmationViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/31/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellConfirmationViewController.h"

@interface SwipeSellConfirmationViewController ()

@end

@implementation SwipeSellConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapMessagesButton:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didCloseListingConfirmation" object:nil];
    }];
}


@end