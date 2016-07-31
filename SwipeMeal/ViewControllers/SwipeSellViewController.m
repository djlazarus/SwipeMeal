//
//  SwipeSellViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeSellViewController.h"
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

@property (nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) NSTimeInterval time;

@end

@implementation SwipeSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Slider
    [self.slider addTarget:self action:@selector(updatePrice:) forControlEvents:UIControlEventAllEvents];
    self.slider.thumbTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.slider.minimumTrackTintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.slider.value = 4.0;
    self.slider.minimumValue = 1.0;
    self.slider.maximumValue = 10.0;
    [self updatePrice:self.slider];
    
    // Text fields
    self.locationTextField.delegate = self;
    self.timeTextField.delegate = self;
    
    // Date picker
    [self.datePicker addTarget:self action:@selector(updateTime:) forControlEvents:UIControlEventValueChanged];
    
    // Continue button
    self.continueButton.enabled = NO;
    self.continueButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize size = self.topImageView.frame.size;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://placehold.it/%@x%@", @(size.width), @(size.height)]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.topImageView.image = [UIImage imageWithData:data];
}

- (void)updatePrice:(UISlider *)slider {
    [self.locationTextField resignFirstResponder];
    [self.timeTextField resignFirstResponder];
    if (self.datePickerBottomConstraint.constant >= 0) {
        [self hideDatePicker];
    }
    
    self.price = slider.value;
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.price];
    
    [self checkFormValidity];
}

- (void)updateTime:(UIDatePicker *)datePicker {
    // Store the time in seconds
    self.time = [datePicker.date timeIntervalSince1970];
    self.timeTextField.text = [self timeStringFromDate:datePicker.date];
    
    [self checkFormValidity];
}

- (void)checkFormValidity {
    if ([self formIsValid]) {
        self.continueButton.enabled = YES;
        self.continueButton.backgroundColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    } else {
        self.continueButton.enabled = NO;
        self.continueButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (BOOL)formIsValid {
    BOOL valid = NO;
    if (self.locationTextField.text.length > 0 && self.timeTextField.text.length > 0) {
        valid = YES;
    }
    
    return valid;
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
        //
    }];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self checkFormValidity];
    
    return NO;
}

@end