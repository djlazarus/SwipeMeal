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

@property (weak, nonatomic) IBOutlet UILabel *bottomPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLocationLabel;

@end

@implementation SwipeBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startDownloadingProfileImage];
    
    self.buyButton.backgroundColor = [[UIColor alloc] initWithHexString:@"6BB739"];
    self.nameLabel.text = self.swipe.listingUserName;
    self.swipesLabel.text = @"7";
    self.salesLabel.text = @"42";
	
	self.bottomPriceLabel.text = [NSString stringWithFormat:@"$%ld", (long)_swipe.listPrice / 100];
	self.bottomLocationLabel.text = _swipe.locationName;
}

- (void)startDownloadingProfileImage {
    FIRStorage *storage = [FIRStorage storage];
    NSString *imagePath = [NSString stringWithFormat:@"profileImages/%@.jpg", _swipe.listingUserID];
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