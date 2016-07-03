//
//  MessagesDetailReplyViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailReplyViewController.h"
#import "SwipeMeal-Swift.h"

@interface MessagesDetailReplyViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainMessageView;
@property (weak, nonatomic) IBOutlet UILabel *toNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *response1Label;
@property (weak, nonatomic) IBOutlet UILabel *response2Label;
@property (weak, nonatomic) IBOutlet UILabel *response3Label;
@property (weak, nonatomic) IBOutlet UILabel *response4Label;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MessagesDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toNameLabel.text = [NSString stringWithFormat:@"To: %@", self.message.nameText];
    self.response1Label.text = @"Ok, I'm on my way";
    self.response2Label.text = @"Ok, I'm here";
    self.response3Label.text = @"Ok, I'll be there at...";
    self.response4Label.text = @"Cancel Transaction";
   
    self.sendButton.layer.borderWidth = 1.0;
    self.sendButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
    
    // Tap to close
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    [tapView addGestureRecognizer:recognizer];
    [self.view insertSubview:tapView belowSubview:self.mainMessageView];
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