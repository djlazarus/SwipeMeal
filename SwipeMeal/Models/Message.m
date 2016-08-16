//
//  Message.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSString *)dateTimeText {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
    return [self timeStringFromDate:date];
}

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

@end