//
//  MessageService.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessageService.h"
#import "MessageStore.h"
@import Firebase;

NSString * const kSwipeMealSystemUserID = @"ADJUaO9J9aRdp1l9mZWv4n5h5s52";

@interface MessageService ()

@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (strong, nonatomic) MessageStore *messageStore;

@end

@implementation MessageService

+ (MessageService *)sharedMessageService {
    static MessageService *messageService = nil;
    if (!messageService) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            messageService = [[MessageService alloc] init];
        });
    }
    
    return messageService;
}

- (instancetype)init {
    if (self = [super init]) {
        self.messageStore = [MessageStore sharedMessageStore];
        self.dbRef = [[FIRDatabase database] reference];
    }
    
    return self;
}

- (NSArray *)messages {
    return [self.messageStore messagesSortedByDateDescending];
}

- (void)replaceMessageWithKey:(NSString *)key withMessage:(Message *)message {
    if ([self.messageStore containsMessageKey:key]) {
        [self.messageStore removeMessageForKey:key];
        [self.messageStore addMessage:message forKey:key];
    }
}

- (void)listenForEventsWithAddBlock:(void (^)(void))addBlock removeBlock:(void (^)(void))removeBlock updateBlock:(void (^)(void))updateBlock {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[self.dbRef child:@"/user-messages/"] child:userID] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Build Message
        Message *message = [self messageWithKey:snapshot.key values:snapshot.value];
        if ([self.messageStore containsMessageKey:message.messageID]) {
            updateBlock();
        } else {
            [self.messageStore addMessage:message forKey:message.messageID];
            NSLog(@"Added Message: %@", message);
            addBlock();
        }
    }];
    
    [[[self.dbRef child:@"/user-messages/"] child:userID] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        Message *message = [self messageWithKey:snapshot.key values:snapshot.value];
        [self.messageStore removeMessageForKey:message.messageID];
        NSLog(@"Removed Message: %@", snapshot);
        removeBlock();
    }];
}

- (Message *)messageWithKey:(NSString *)key values:(NSDictionary *)values {
    Message *message = [[Message alloc] init];
    message.messageID = key;
    message.messageText = [values objectForKey:@"body"];
    message.toUID = [values objectForKey:@"to_uid"];
    message.fromUID = [values objectForKey:@"from_uid"];
    message.swipeID = [values objectForKey:@"swipe_id"];
    message.unread = [[values objectForKey:@"unread"] boolValue];
    message.timestamp = [[values objectForKey:@"timestamp"] integerValue];
    message.canReply = YES;
    
    // Disable reply if this is message is from the system user.
    if ([message.fromUID isEqualToString:kSwipeMealSystemUserID]) {
        message.canReply = NO;
    }

    return message;
}

- (void)createNewMessageWithValues:(NSDictionary *)values withCompletionBlock:(void (^)(void))completionBlock {
    NSString *key = [[self.dbRef child:@"messages"] childByAutoId].key;
    NSString *fromUserID = [FIRAuth auth].currentUser.uid;
    NSDictionary *childUpdates = @{[@"/messages/" stringByAppendingString:key]: values,
                                   [NSString stringWithFormat:@"/user-messages/%@/%@/", fromUserID, key]: values};
    
    [self.dbRef updateChildValues:childUpdates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

@end