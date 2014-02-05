//
//  NSNotificationCenter+HALDataUpdateNotification.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "NSNotificationCenter+HALDataUpdateNotification.h"

#define kHALDataUpdateNotificationName @"DataUpdateNotification"

@implementation NSNotificationCenter (HALDataUpdateNotification)

-(void) addDataUpdateObserver:(id)observer
                     selector:(SEL)selector
{
    [self addObserver:observer selector:selector name:kHALDataUpdateNotificationName object:self];
}

-(void) postDataUpdateNotification;
{
    [self postNotificationName:kHALDataUpdateNotificationName object:self];
}

@end
