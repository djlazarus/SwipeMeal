//
//  SwipeSellViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellViewController.h"
#import "SwipeSellDetailViewController.h"
#import "Swipe.h"
#import "SwipeMeal-Swift.h"

@interface SwipeSellViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) Swipe *swipe;

@end

@implementation SwipeSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.topImageView.layer.masksToBounds = YES;
	
    // Swipe
    self.swipe = [[Swipe alloc] init];
    
    // Slider
    [self.slider addTarget:self action:@selector(updatePrice:) forControlEvents:UIControlEventAllEvents];
    self.slider.thumbTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.slider.minimumTrackTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.slider.value = 7.0;
    self.slider.minimumValue = 5.0;
    self.slider.maximumValue = 10.0;
    [self updatePrice:self.slider];
    
    // Text fields
    self.locationTextField.delegate = self;
    self.timeTextField.delegate = self;
    
    // Date picker
    [self.datePicker addTarget:self action:@selector(updateTime:) forControlEvents:UIControlEventValueChanged];
	self.datePicker.backgroundColor = [UIColor whiteColor];
    
    // Continue button
    self.continueButton.enabled = NO;
    self.continueButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)updatePrice:(UISlider *)slider {
    [self.locationTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    if (self.datePickerBottomConstraint.constant >= 0) {
        [self hideDatePicker];
    }
    
    self.swipe.listPrice = (NSInteger)slider.value * 100;
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.swipe.listPrice / 100];
    
    [self checkFormValidity];
}

- (void)updateLocation:(NSString *)location {
    self.swipe.locationName = location;
    
    [self checkFormValidity];
}

- (void)updateTime:(UIDatePicker *)datePicker {
    // Store the time in seconds
    self.swipe.availableTime = [datePicker.date timeIntervalSince1970];
    self.timeTextField.text = [self timeStringFromDate:datePicker.date];
    
    [self checkFormValidity];
}

- (void)checkFormValidity {
    if (self.swipe.valid) {
        self.continueButton.enabled = YES;
        self.continueButton.backgroundColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    } else {
        self.continueButton.enabled = NO;
        self.continueButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (void)showDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = NO;
        self.datePickerBottomConstraint.constant = 50;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
		 [self updateTime:self.datePicker];
        //
    }];
}

- (IBAction)viewTapped:(UIGestureRecognizer*)recognizer {
	[self hideDatePicker];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = YES;
        self.datePickerBottomConstraint.constant = -216;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_SwipeSellViewController_SwipeSellDetailViewController"]) {
        SwipeSellDetailViewController *swipeSellDetailViewController = (SwipeSellDetailViewController *)[segue destinationViewController];
        swipeSellDetailViewController.swipe = self.swipe;
    }
}

- (IBAction)didTapContinueButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"Segue_SwipeSellViewController_SwipeSellDetailViewController" sender:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Show the keyboard if editing the location text field.
    if (textField != self.timeTextField) {
        [self.timeTextField resignFirstResponder];
        [self hideDatePicker];
        return YES;
    }
    
    // Otherwise, show the date picker.
    [self.locationTextField resignFirstResponder];
    [self showDatePicker];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.locationTextField) {
        [self updateLocation:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self checkFormValidity];
    
    return NO;
}

@end
