//
//  Constants.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "Constants.h"

// System user ID
NSString * const kSwipeMealSystemUserID = @"ADJUaO9J9aRdp1l9mZWv4n5h5s52";

// Payment server environment
NSString * const kPaymentServerEndpoint = @"https://api.swipemeal.com/v1";
NSString * const kPaymentServerDevParameter = @"dev";

#ifdef DEBUG
#define PAYMENT_SERVER_DEV_VALUE @"1";
#else
#define PAYMENT_SERVER_DEV_VALUE @"0";
#endif

NSString * const kPaymentServerDevValue = PAYMENT_SERVER_DEV_VALUE;

@implementation Constants

@end