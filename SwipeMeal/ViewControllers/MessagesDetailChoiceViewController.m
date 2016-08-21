//
//  MessagesDetailChoiceViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/2/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailChoiceViewController.h"
#import "MessagesDetailReplyViewController.h"
#import "MessageService.h"
#import "SwipeMeal-Swift.h"

@interface MessagesDetailChoiceViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainMessageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) MessageService *messageService;

@end

@implementation MessagesDetailChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageService = [MessageService sharedMessageService];
    
    self.mainImageView.image = self.message.mainImage;
    self.dateTimeLabel.text = self.message.dateTimeText;
    self.nameLabel.text = self.message.fromName;
    self.messageLabel.text = self.message.messageText;
    
    if (self.message.isOfferMessage) {
        [self.button1 setTitle:@"Accept" forState:UIControlStateNormal];
        [self.button2 setTitle:@"Decline" forState:UIControlStateNormal];
    } else {
        if (self.message.canReply) {
            self.button1.hidden = NO;
            self.button1.layer.borderWidth = 1.0;
            self.button1.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
        } else {
            self.button1.hidden = YES;
        }
    }
    
    self.button1.layer.borderWidth = 1.0;
    self.button1.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.button2.layer.borderWidth = 1.0;
    self.button2.layer.borderColor = [UIColor redColor].CGColor;
    
    // Tap to close
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    [tapView addGestureRecognizer:recognizer];
    [self.view insertSubview:tapView belowSubview:self.mainMessageView];
}

- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapToCloseMessageDetail" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessagesDetailChoiceViewController_MessagesDetailReplyViewController"]) {
        MessagesDetailReplyViewController *messagesDetailReplyViewController = (MessagesDetailReplyViewController *)segue.destinationViewController;
        messagesDetailReplyViewController.message = self.message;
    }
}

- (IBAction)didTapButton1:(UIButton *)sender {
    if (self.message.isOfferMessage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapAcceptButton" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapReplyButton" object:nil];
    }
}

- (IBAction)didTapButton2:(UIButton *)sender {
    if (self.message.isOfferMessage) {
        [self.messageService removeMessageWithKey:self.message.messageID completionBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [self.messageService removeMessageWithKey:self.message.messageID completionBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end