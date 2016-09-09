//
//  AddCardViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 9/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()

@property (strong, nonatomic) STPPaymentCardTextField *paymentCardTextField;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Insert the Stripe card text field into the form stack
    self.paymentCardTextField = [[STPPaymentCardTextField alloc] init];
    self.paymentCardTextField.placeholderColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.paymentCardTextField.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.paymentCardTextField.textColor = [UIColor whiteColor];
    [self.stackView insertArrangedSubview:self.paymentCardTextField atIndex:0];
}

- (void)createToken {
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    cardParams.number = self.paymentCardTextField.cardNumber;
    cardParams.expMonth = self.paymentCardTextField.expirationMonth;
    cardParams.expYear = self.paymentCardTextField.expirationYear;
    cardParams.cvc = self.paymentCardTextField.cvc;
    cardParams.name = self.nameTextField.text;
    cardParams.addressLine1 = self.address1TextField.text;
    cardParams.addressLine2 = self.address2TextField.text;
    cardParams.addressCity = self.cityTextField.text;
    cardParams.addressState = self.stateTextField.text;
    cardParams.addressZip = self.zipTextField.text;
    cardParams.currency = @"usd";
    
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
    [self createToken];
}

@end