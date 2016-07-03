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
@property (weak, nonatomic) IBOutlet UILabel *toNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *response1Label;
@property (weak, nonatomic) IBOutlet UILabel *response2Label;
@property (weak, nonatomic) IBOutlet UILabel *response3Label;
@property (weak, nonatomic) IBOutlet UILabel *response4Label;

@end

@implementation MessagesDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toNameLabel.text = [NSString stringWithFormat:@"To: %@", self.message.nameText];
    self.response1Label.text = @"Ok, I'm on my way";
    self.response2Label.text = @"Ok, I'm here";
    self.response3Label.text = @"Ok, I'll be there at...";
    self.response4Label.text = @"Cancel Transaction";
    
}

@end