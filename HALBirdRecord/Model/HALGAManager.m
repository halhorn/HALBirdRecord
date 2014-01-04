//
//  HALGAManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/04.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALGAManager.h"
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

#define kHALGAID @"UA-46849208-1"
#define kHALFirstLaunchDateKey @"FirstLaunchDate"

@implementation HALGAManager

+ (void)setup
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kHALGAID];
#ifdef DEBUG
    [GAI sharedInstance].optOut = YES;
#endif
    
    [self setFirstActivationDate:tracker];
}

+ (void)setFirstActivationDate:(id<GAITracker>)tracker
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunchDate = [setting objectForKey:kHALFirstLaunchDateKey];
    if (firstLaunchDate == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        firstLaunchDate = [dateFormatter stringFromDate:[NSDate date]];
        [setting setObject:firstLaunchDate forKey:kHALFirstLaunchDateKey];
    }
    [tracker set:[GAIFields customDimensionForIndex:1] value:firstLaunchDate];
}

+ (void)sendView:(NSString *)page
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:page];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    [tracker set:kGAIScreenName value:nil];
}

+ (void)sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(double)value
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    NSMutableDictionary *params = [[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:@(value)] build];
    [tracker send:params];
}

@end
