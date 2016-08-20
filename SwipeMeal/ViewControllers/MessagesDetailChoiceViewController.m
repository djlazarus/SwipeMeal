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
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) MessageService *messageService;

@end

@implementation MessagesDetailChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageService = [MessageService sharedMessageService];
    
    self.mainImageView.image = self.message.mainImage;
    self.dateTimeLabel.text = self.message.dateTimeText;
    self.nameLabel.text = self.message.nameText;
    self.messageLabel.text = self.message.messageText;
    
    if (self.message.canReply) {
        self.replyButton.hidden = NO;
        self.replyButton.layer.borderWidth = 1.0;
        self.replyButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    } else {
        self.replyButton.hidden = YES;
    }
    
    self.deleteButton.layer.borderWidth = 1.0;
    self.deleteButton.layer.borderColor = [UIColor redColor].CGColor;
    
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

- (IBAction)didTapReplyButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapReplyButton" object:nil];
}

- (IBAction)didTapDeleteButton:(UIButton *)sender {
    [self.messageService removeMessageWithKey:self.message.messageID completionBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end