//
//  SwipeListTableViewCell.h
//  SwipeMeal
//
//  Created by Jacob Harris on 7/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swipe.h"

@interface SwipeListTableViewCell : UITableViewCell

@property (strong, nonatomic) Swipe *swipe;

@end