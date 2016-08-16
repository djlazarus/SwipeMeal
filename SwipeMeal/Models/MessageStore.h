//
//  MessageStore.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageStore : NSObject

+ (MessageStore *)sharedMessageStore;
- (BOOL)containsMessageKey:(NSString *)key;
- (void)addMessage:(Message *)message forKey:(NSString *)key;
- (void)removeMessage:(Message *)message forKey:(NSString *)key;
- (Message *)messageForKey:(NSString *)key;
- (NSArray *)messagesSortedByPriceAscending;

@end