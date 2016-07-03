//
//  MessagesDetailChildViewController.h
//  SwipeMeal
//
//  Created by Jacob Harris on 7/2/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessagesDetailChildViewController : UIViewController

@property (nonatomic) NSInteger index;
@property (strong, nonatomic) Message *message;

@end