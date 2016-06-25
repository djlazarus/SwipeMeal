//
//  MessagesTableViewCell.h
//  SwipeMeal
//
//  Created by Jacob Harris on 6/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessagesTableViewCell : UITableViewCell

- (void)setUpWithMessage:(Message *)message;

@end