//
//  MessagesViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesTableViewCell.h"
#import "Message.h"
#import "SwipeMeal-Swift.h"

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessagesViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.translucent = NO;
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSArray *)messages {
    Message *msg1 = [[Message alloc] init];
    msg1.mainImage = [UIImage imageNamed:@"temp-gabe"];
    msg1.nameText = @"Gabe Kwakyi";
    msg1.dateTimeText = @"9:41a";
    msg1.messageText = @"I just received your Swipe request. I'm currently on my way to the main dining hall.";
    
    Message *msg2 = [[Message alloc] init];
    msg2.mainImage = [UIImage imageNamed:@"temp-greg"];
    msg2.nameText = @"Gregory Klein";
    msg2.dateTimeText = @"5/6/16";
    msg2.messageText = @"$15 has been deposited into your Swipes Wallet. You can deposit those funds into PayPal or use them for future Swipes.";
    
    Message *msg3 = [[Message alloc] init];
    msg3.mainImage = [UIImage imageNamed:@"temp-gabe"];
    msg3.nameText = @"Gabe Kwakyi";
    msg3.dateTimeText = @"5/2/16";
    msg3.messageText = @"Where are you?";

    NSArray *messages = @[msg1, msg2, msg3];
    return messages;
}

//- (CGFloat)heightForMessageAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *messages = [self messages];
//    Message *message = [messages objectAtIndex:indexPath.row];
//    CGFloat baseHeight = 145.0;
//    
//    NSDictionary *textAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
//    CGSize stringSize = [message.messageText sizeWithAttributes:textAttrs];
//    
//    return stringSize.height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self messages];
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessagesTableViewCell" forIndexPath:indexPath];
    Message *message = [[self messages] objectAtIndex:indexPath.row];
    
    [cell setUpWithMessage:message];
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    }
    
    return cell;
}

@end