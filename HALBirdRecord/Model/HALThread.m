//
//  HALThread.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/04.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALThread.h"

@implementation HALThread

+ (void)waitUntil:(BOOL(^)())prediction do:(void(^)(BOOL))block maxWait:(NSTimeInterval)maxWaitTime
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDate *startTime = [NSDate date];
        BOOL success = YES;
        while (!prediction()) {
            if ([[NSDate date] timeIntervalSinceDate:startTime] > maxWaitTime) {
                success = NO;
                break;
            }
            [NSThread sleepForTimeInterval:0.1];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(success);
        });
    });
}

@end
