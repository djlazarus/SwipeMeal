//
//  AddCardViewController.h
//  SwipeMeal
//
//  Created by Jacob Harris on 9/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Stripe;

@protocol AddCardViewControllerDelegate;

@interface AddCardViewController : UIViewController

@property (weak, nonatomic) id <AddCardViewControllerDelegate> delegate;

@end

@protocol AddCardViewControllerDelegate <NSObject>

- (void)addCardViewControllerDidCancel:(AddCardViewController *)addCardViewController;
- (void)addCardViewController:(AddCardViewController *)addCardViewController didCreateToken:(STPToken *)token;

@end