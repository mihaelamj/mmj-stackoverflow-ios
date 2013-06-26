//
//  GlobalNetworkActivity.m
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/26/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "GlobalNetworkActivity.h"

@implementation GlobalNetworkActivity

+ (void)changeCounter:(NSUInteger)change
{
    static NSUInteger counter = 0;
    static dispatch_queue_t queue;
    if (!queue) {
        queue = dispatch_queue_create("GlobalNetworkActivity Queue", NULL);
    }
    dispatch_sync(queue, ^{
        if (counter + change <= 0) {
            counter = 0;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } else {
            counter += change;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    });
}


+ (void)show
{
    [self changeCounter:1];
}

+ (void)hide
{
    [self changeCounter:-1];
}

@end
