//
//  Constants.m
//  SwipeMeal
//
//  Created by Jacob Harris on 8/29/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

#import "Constants.h"

// System user ID
NSString * const kSwipeMealSystemUserID = @"9j3E0HKlXaNeUfpch0mN4Bs3uNy1";

// Payment server environment
//NSString * const kPaymentServerEndpoint = @"https://api.swipemeal.com/v1";
NSString * const kPaymentServerEndpoint = @"http://54.68.29.117/api/v1";
NSString * const kPaymentServerDevParameter = @"dev";

#ifdef DEBUG
#define PAYMENT_SERVER_DEV_VALUE @"1";
#else
#define PAYMENT_SERVER_DEV_VALUE @"0";
#endif

NSString * const kPaymentServerDevValue = PAYMENT_SERVER_DEV_VALUE;

@implementation Constants

@end