//
//  PersonalInfoViewController.h
//  SwipeMeal
//
//  Created by Jacob Harris on 9/6/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalInfoViewControllerDelegate;

@interface PersonalInfoViewController : UIViewController

@property (weak, nonatomic) id <PersonalInfoViewControllerDelegate> delegate;

@end

@protocol PersonalInfoViewControllerDelegate <NSObject>

- (void)personalInfoViewControllerDidCancel:(PersonalInfoViewController *)personalInfoViewController;
- (void)personalInfoViewController:(PersonalInfoViewController *)personalInfoViewController didCreatePersonalInfo:(NSDictionary *)info;

@end