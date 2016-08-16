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
    return [self.messageStore messagesSortedByPriceAscending];
}

//- (void)listenForEventsWithAddBlock:(void (^)(void))addBlock removeBlock:(void (^)(void))removeBlock updateBlock:(void (^)(void))updateBlock {
//    [[self.dbRef child:@"/messages/"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        // Build Message
//        Message *message = [self swipeWithKey:snapshot.key values:snapshot.value];
//        if ([self.swipeStore containsSwipeKey:swipe.swipeID]) {
//            updateBlock();
//        } else {
//            [self.swipeStore addSwipe:swipe forKey:swipe.swipeID];
//            NSLog(@"Added Swipe: %@", swipe);
//            addBlock();
//        }
//    }];
//    
//    [[self.dbRef child:@"/swipes-listed/"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        Swipe *swipe = [self swipeWithKey:snapshot.key values:snapshot.value];
//        [self.swipeStore removeSwipe:swipe forKey:swipe.swipeID];
//        NSLog(@"Removed Swipe: %@", snapshot);
//        removeBlock();
//    }];
//}

- (Message *)messageWithKey:(NSString *)key values:(NSDictionary *)values {
    Message *message = [[Message alloc] init];
    message.unread = [[values objectForKey:@"unread"] boolValue];
//    message.mainImage = [UIImage imageNamed:@"temp-gabe"];
//    message.nameText = @"Gabe Kwakyi";
//    message.dateTimeText = @"9:41a";
    message.messageText = [values objectForKey:@"body"];

    return message;
}

@end