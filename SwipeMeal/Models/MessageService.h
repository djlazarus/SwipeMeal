//
//  MessageService.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageService : NSObject

@property (strong, nonatomic, readonly) NSArray *messages;
+ (MessageService *)sharedMessageService;
- (void)listenForEventsWithAddBlock:(void(^)(void))addBlock removeBlock:(void(^)(void))removeBlock updateBlock:(void(^)(void))updateBlock;
- (void)createNewMessageWithValues:(NSDictionary *)values withCompletionBlock:(void (^)(void))completionBlock;

@end