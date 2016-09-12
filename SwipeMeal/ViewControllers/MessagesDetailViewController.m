//
//  MessagesDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 6/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import "MessagesDetailReplyViewController.h"
#import "MessagesDetailChildViewController.h"
#import "SwipeService.h"

@interface MessagesDetailViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonnull) SwipeService *swipeService;

@end

@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySwipe) name:@"didTapAcceptButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReplyViewController) name:@"didTapReplyButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadConfirmationViewController) name:@"didTapSendButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTransaction) name:@"didTapCancelTransactionButton" object:nil];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];

    self.pageViewController.view.frame = self.view.bounds;
    [self setViewControllerAtIndex:0];
    
    self.swipeService = [SwipeService sharedSwipeService];
}

- (void)buySwipe {
    Swipe *swipe = [self.swipeService swipeForKey:self.message.swipeID];
    if (swipe) {
        [self.swipeService buySwipe:swipe withCompletionBlock:^{
            [self loadReplyViewController];
        }];
    } else {
        [self.swipeService getSwipeWithSwipeID:self.message.swipeID completionBlock:^(Swipe *swipe) {
            [self.swipeService buySwipe:swipe withCompletionBlock:^{
                [self loadReplyViewController];
            }];
        }];
    }
}

- (void)loadReplyViewController {
    [self setViewControllerAtIndex:1];
}

- (void)loadConfirmationViewController {
    [self setViewControllerAtIndex:2];
}

- (void)cancelTransaction {

}

- (void)setViewControllerAtIndex:(NSInteger)index {
    NSArray *viewControllersIDs = @[@"MessagesDetailChoiceViewController",
                                    @"MessagesDetailReplyViewController",
                                    @"MessagesDetailReplyConfirmViewController"];
    
    NSString *viewControllerID = [viewControllersIDs objectAtIndex:index];
    MessagesDetailChildViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    viewController.index = index;
    viewController.message = self.message;
    
    NSArray *viewControllers = @[viewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


@end