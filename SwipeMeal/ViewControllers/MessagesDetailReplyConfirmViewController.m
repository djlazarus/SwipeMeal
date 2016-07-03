//
//  MessagesDetailReplyConfirmViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 7/2/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailReplyConfirmViewController.h"

@interface MessagesDetailReplyConfirmViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainMessageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation MessagesDetailReplyConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainImageView.image = self.message.mainImage;
    self.mainLabel.text = @"Your message has been sent!";
    
    // Tap to close
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    [tapView addGestureRecognizer:recognizer];
    [self.view insertSubview:tapView belowSubview:self.mainMessageView];
}

- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapToCloseMessageDetail" object:nil];
}

@end