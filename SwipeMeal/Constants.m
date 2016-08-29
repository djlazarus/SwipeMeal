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
#ifdef DEBUG
#define PAYMENT_SERVER_ENDPOINT @"https://dev.api.swipemeal.com/v1";
#else
#define PAYMENT_SERVER_ENDPOINT @"https://api.swipemeal.com/v1";
#endif

NSString * const kPaymentServerEndpoint = PAYMENT_SERVER_ENDPOINT;

@implementation Constants

@end