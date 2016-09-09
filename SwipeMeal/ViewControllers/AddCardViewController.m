//
//  AddCardViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 9/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self test];
}

- (void)test {
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    cardParams.number = @"4000056655665556";
    cardParams.expMonth = 10;
    cardParams.expYear = 2018;
    cardParams.cvc = @"123";
    cardParams.currency = @"usd";
    cardParams.name = @"Jacob Harris";
    cardParams.addressLine1 = @"1600 E Central Blvd";
    cardParams.addressCity = @"Orlando";
    cardParams.addressState = @"FL";
    cardParams.addressZip = @"32803";
    
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Card issue"
                                                                                     message:@"There was an issue adding your card. Please make sure you're using a debit card. Double check the details and try again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [alertController dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alertController addAction:action];
            [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            id <AddCardViewControllerDelegate> delegate = self.delegate;
            [delegate addCardViewController:self didCreateToken:token];
        }
    }];
}

- (IBAction)didTapCancelButton:(UIBarButtonItem *)sender {
//    [self.ssnTextField resignFirstResponder];
//    [self.dobTextField resignFirstResponder];
    
    id <AddCardViewControllerDelegate> delegate = self.delegate;
    [delegate addCardViewControllerDidCancel:self];
}

- (IBAction)didTapDoneButton:(UIBarButtonItem *)sender {
    //
}

@endΩ