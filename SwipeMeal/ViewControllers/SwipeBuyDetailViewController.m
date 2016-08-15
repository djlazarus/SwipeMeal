//
//  SwipeBuyDetailViewController.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "SwipeBuyDetailViewController.h"
#import "SwipeBuyConfirmDialogViewController.h"
#import "SwipeMeal-Swift.h"

@import IncipiaKit;
@import Firebase;

@interface SwipeBuyDetailViewController ()

@property (weak, nonatomic) IBOutlet SwipeMealAddProfileImageButton *buyButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
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
    
    self.buyButton.backgroundColor = [[UIColor alloc] initWithHexString:@"6BB739"];
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
    FIRStorage *storage = [FIRStorage storage];
    NSString *imagePath = [NSString stringWithFormat:@"profileImages/%@.jpg", _swipe.uid];
    FIRStorageReference *pathRef = [storage referenceWithPath:imagePath];
    [pathRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.mainImageView.image = image;
			  self.backgroundImageView.image = [image applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1.2 maskImage:nil];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Segue_SwipeBuyDetailViewController_SwipeBuyConfirmDialogViewController"]) {
        SwipeBuyConfirmDialogViewController *swipeBuyConfirmDialogViewController = (SwipeBuyConfirmDialogViewController *)[segue destinationViewController];
        swipeBuyConfirmDialogViewController.swipe = self.swipe;
    }
}

- (IBAction)didTapBuyButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"Segue_SwipeBuyDetailViewController_SwipeBuyConfirmDialogViewController" sender:nil];
}

@end