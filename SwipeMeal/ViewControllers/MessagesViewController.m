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
#import "MessagesDetailViewController.h"
#import "SwipeMeal-Swift.h"
@import Firebase;

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *messageHeights;
@property (strong, nonatomic) Message *selectedMessage;
@property (nonatomic) CGFloat defaultMessageHeight;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;

@end

@implementation MessagesViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//static func setTestValue(complete: Bool, forUser user: SwipeMealUser)
//{
//    let ref = FIRDatabase.database().reference()
//    let userInfoRef = ref.child(kUsersPathName).child("\(user.uid)/\(kUserInfoPathName)")
//    userInfoRef.updateChildValues([kUserConversationsPathName : complete])
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // Get the database
//    self.dbRef = [[FIRDatabase database] reference];
//    
//    // Message test
//    NSString *message = @"Hello world!";
//    NSString *userID = [FIRAuth auth].currentUser.uid;
//    [self createNewMessage:userID messageBody:message];
    
    self.navBarView.translucent = NO;
    self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Set the default height for a message
    self.defaultMessageHeight = 60.0; // 60 == message cell's main image
    self.messageHeights = [NSMutableDictionary dictionary];
    
    // Listen for notifications telling us that a message detail window has been tapped to close
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMessageDetail) name:@"didTapToCloseMessageDetail" object:nil];
}

- (void)createNewMessage:(NSString *)userID messageBody:(NSString *)body {
    NSString *key = [[self.dbRef child:@"messages"] childByAutoId].key;
    NSDictionary *message = @{@"uid":userID,
                              @"body":body};
    
    NSDictionary *childUpdates = @{[@"/messages/" stringByAppendingString:key] : message,
                                   [NSString stringWithFormat:@"/user-messages/%@/%@/", userID, key] : message};
    
    [self.dbRef updateChildValues:childUpdates];
}

- (void)closeMessageDetail {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)messages {
    Message *msg1 = [[Message alloc] init];
    msg1.unread = YES;
    msg1.mainImage = [UIImage imageNamed:@"temp-gabe"];
    msg1.nameText = @"Gabe Kwakyi";
    msg1.dateTimeText = @"9:41a";
    msg1.messageText = @"I just received your Swipe request. I'm currently on my way to the main dining hall. I just received your Swipe request. I'm currently on my way to the main dining hall.";
    
    Message *msg2 = [[Message alloc] init];
    msg2.unread = NO;
    msg2.mainImage = [UIImage imageNamed:@"temp-greg"];
    msg2.nameText = @"Gregory Klein";
    msg2.dateTimeText = @"5/6/16";
    msg2.messageText = @"$15 has been deposited into your Swipes Wallet. You can deposit those funds into PayPal or use them for future Swipes. $15 has been deposited into your Swipes Wallet. You can deposit those funds into PayPal or use them for future Swipes. $15 has been deposited into your Swipes Wallet. You can deposit those funds into PayPal or use them for future Swipes.";
    
    Message *msg3 = [[Message alloc] init];
    msg3.unread = NO;
    msg3.mainImage = [UIImage imageNamed:@"temp-gabe"];
    msg3.nameText = @"Gabe Kwakyi";
    msg3.dateTimeText = @"5/2/16";
    msg3.messageText = @"Where are you?";

    NSArray *messages = @[msg1, msg2, msg3];
    return messages;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self messages];
    return [rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Compare the stored message height to the default message height.
    // If the stored height is greater, return it. Otherwise, return the default height.
    CGFloat height = [[self.messageHeights objectForKey:indexPath] floatValue];
    if (height > self.defaultMessageHeight) {
        return height;
    }
    
    return self.defaultMessageHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MessagesTableViewCell" forIndexPath:indexPath];
    Message *message = [[self messages] objectAtIndex:indexPath.row];
    
    [cell setUpWithMessage:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    }
    
    // Force cell layout so we get an accurate message height.
    [cell layoutIfNeeded];

    // Compare the cell's message height to our stored message height.
    // If they're different (i.e. the cell's message height has changed), store the new height.
    CGFloat height = [[self.messageHeights objectForKey:indexPath] floatValue];
    if (cell.messageHeight != height) {
        [self.messageHeights setObject:@(cell.messageHeight) forKey:indexPath];
        // Reload this row so the cell gets a proper height.
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [[self messages] objectAtIndex:indexPath.row];
    self.selectedMessage = message;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"MessagesViewController_MessagesDetailViewController" sender:nil];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessagesViewController_MessagesDetailViewController"]) {
        MessagesDetailViewController *messagesDetailViewController = (MessagesDetailViewController *)[segue destinationViewController];
        messagesDetailViewController.message = self.selectedMessage;
    }
}

@end