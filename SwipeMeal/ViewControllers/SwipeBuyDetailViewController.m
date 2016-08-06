//
//  SwipeBuyDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyDetailViewController.h"
#import "SwipeMeal-Swift.h"
@import Firebase;

@interface SwipeBuyDetailViewController ()

@property (weak, nonatomic) IBOutlet CircularImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *swipesLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView5;

@end

@implementation SwipeBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startDownloadingProfileImage];
    
    self.nameLabel.text = self.swipe.sellerName;
    self.swipesLabel.text = @"7";
    self.salesLabel.text = @"42";
    
    NSArray *stars = @[self.ratingImageView1, self.ratingImageView2, self.ratingImageView3, self.ratingImageView4, self.ratingImageView5];
    for (int i = 0; i < self.swipe.sellerRating; i++) {
        UIImage *starImage = [UIImage imageNamed:@"buy-star"];
        UIImageView *starImageView = [stars objectAtIndex:i];
        starImageView.image = [starImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        starImageView.tintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1.0];
    }
}

- (void)startDownloadingProfileImage {
    NSString *userID = [FIRAuth auth].currentUser.uid;
    FIRStorage *storage = [FIRStorage storage];
    NSString *imagePath = [NSString stringWithFormat:@"profileImages/%@.jpg", userID];
    FIRStorageReference *pathRef = [storage referenceWithPath:imagePath];
    [pathRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.mainImageView.image = image;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end