//
//  MessagesDetailReplyViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailReplyViewController.h"
#import "MessagesDetailReplyTableViewCell.h"
#import "SwipeMeal-Swift.h"

@interface MessagesDetailReplyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mainMessageView;
@property (weak, nonatomic) IBOutlet UILabel *toNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSDate *replyDate;

@end

@implementation MessagesDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toNameLabel.text = [NSString stringWithFormat:@"To: %@", self.message.nameText];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];

    self.sendButton.enabled = NO;
    self.sendButton.layer.borderWidth = 1.0;
    self.sendButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.datePicker addTarget:self action:@selector(updateTime:) forControlEvents:UIControlEventValueChanged];
    
    // Tap to close
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    [tapView addGestureRecognizer:recognizer];
    [self.view insertSubview:tapView belowSubview:self.mainMessageView];
}

- (NSArray *)rows {
    NSArray *rows = @[@"Ok, I'm on my way", @"Ok, I'm here", @"Ok, I'll be there at:"];
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[self rows] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesDetailReplyTableViewCell *cell = (MessagesDetailReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessagesDetailReplyTableViewCell" forIndexPath:indexPath];
    
    NSString *rowText = [[self rows] objectAtIndex:indexPath.row];
    NSString *timeString;
    if (indexPath.row == 2) {
        if (self.replyDate) {
            timeString = [self timeStringFromTimeInterval:self.replyDate];
            cell.mainText = [NSString stringWithFormat:@"%@ %@", rowText, timeString];
        } else {
            cell.mainText = rowText;
        }
    } else {
         cell.mainText = rowText;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Variable date/time row?
    if (indexPath.row == 2) {
        [self showDatePicker];
    } else {
        [self hideDatePicker];
    }
    
    self.sendButton.enabled = YES;
}

- (void)updateTime:(id)sender {
    if ([sender isKindOfClass:[UIDatePicker class]]) {
        // Store the time in seconds
        self.replyDate = ((UIDatePicker *)sender).date;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSString *)timeStringFromTimeInterval:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (void)showDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = NO;
        self.datePickerTopConstraint.constant = 40;
        self.datePickerBottomConstraint.constant = 216;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.hidden = YES;
        self.datePickerTopConstraint.constant = 117;
        self.datePickerBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapToCloseMessageDetail" object:nil];
}

- (IBAction)didTapSendButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapSendButton" object:nil];
}

- (IBAction)didTapCancelTransactionButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapCancelTransactionButton" object:nil];
}

@end