//
//  PersonalInfoViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 9/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *ssnTextField;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ssnTextField.delegate = self;
    self.dobTextField.delegate = self;
    self.doneButton.enabled = NO;
    [self.datePicker addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
    [self.ssnTextField addTarget:self action:@selector(checkFormValidity) forControlEvents:UIControlEventEditingChanged];
}

- (void)showDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = NO;
        self.datePickerBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = YES;
        self.datePickerBottomConstraint.constant = -self.datePicker.frame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)updateDate:(id)sender {
    if ([sender isKindOfClass:[UIDatePicker class]]) {
        NSDate *dob = ((UIDatePicker *)sender).date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        
        NSString *dateString = [formatter stringFromDate:dob];
        self.dobTextField.text = dateString;
        
        [self checkFormValidity];
    }
}

- (void)checkFormValidity {
    if (self.ssnTextField.text.length == 9 && self.dobTextField.text.length > 0) {
        self.doneButton.enabled = YES;
    } else {
        self.doneButton.enabled = NO;
    }
}

- (IBAction)didTapCancelButton:(UIBarButtonItem *)sender {
    [self.ssnTextField resignFirstResponder];
    [self.dobTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapDoneButton:(UIBarButtonItem *)sender {
    // call the API
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Show the keyboard if editing the location text field.
    if (textField != self.dobTextField) {
        [self.dobTextField resignFirstResponder];
        [self hideDatePicker];
        return YES;
    }
    
    // Otherwise, show the date picker.
    [self.ssnTextField resignFirstResponder];
    [self showDatePicker];
    return NO;
}

@end