//
//  TransactionTableViewCell.h
//  SwipeMeal
//
//  Created by Jacob Harris on 8/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Swipe.h"

@interface TransactionTableViewCell : UITableViewCell

- (void)setUpWithSwipe:(Swipe *)swipe;

@end