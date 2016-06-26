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
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation MessagesDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainImageView.image = self.message.mainImage;
    self.dateTimeLabel.text = self.message.dateTimeText;
    self.nameLabel.text = self.message.nameText;
    self.messageLabel.text = self.message.messageText;
    
    self.replyButton.layer.borderWidth = 1.0;
    self.replyButton.layer.borderColor = [[UIColor alloc] initWithHexString:@"6BB739"].CGColor;
    
    self.deleteButton.layer.borderWidth = 1.0;
    self.deleteButton.layer.borderColor = [UIColor redColor].CGColor;
    

//    CGRect outsideMessageFrame = CGRect
    UIGestureRecognizer *recognizer = [[UIGestureRecognizer alloc] init];
}

- (IBAction)didTapReplyButton:(UIButton *)sender {
}

- (IBAction)didTapDeleteButton:(UIButton *)sender {
}

@end