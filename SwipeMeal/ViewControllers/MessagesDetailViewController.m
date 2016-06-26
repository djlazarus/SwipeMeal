//
//  MessagesDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import "MessagesDetailReplyViewController.h"

@interface MessagesDetailViewController ()

@end

@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSegueWithIdentifier:@"MessagesDetailViewController_MessagesDetailReplyViewController" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessagesDetailViewController_MessagesDetailReplyViewController"]) {
        MessagesDetailReplyViewController *messagesDetailReplyViewController = (MessagesDetailReplyViewController *)[segue destinationViewController];
        messagesDetailReplyViewController.message = self.message;
    }
}

@end