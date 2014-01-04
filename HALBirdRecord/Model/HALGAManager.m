//
//  HALGAManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/04.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALGAManager.h"
#import "HALActivityManager.h"
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

#define kHALGAID @"UA-46849208-1"
#define kHALFirstLaunchDateKey @"FirstLaunchDate"
#define kHALStateRecordedDateKey @"StateRecordedDate"

@implementation HALGAManager

+ (void)setup
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    
#ifdef DEBUG
    [GAI sharedInstance].optOut = YES;
#endif
}

+ (void)sendFirstActivationDate
{
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kHALGAID];
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

+ (void)sendState
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    NSDate *recordedDate = [setting objectForKey:kHALStateRecordedDateKey];
    if (!recordedDate || ![[formatter stringFromDate:recordedDate] isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
        // 日付をまたいだ時のみ状態を報告
        [HALGAManager sendFirstActivationDate];
        
        HALActivityManager *manager = [HALActivityManager sharedManager];
        [HALGAManager sendState:@"Count: Activity" value:manager.activityCount];
        [HALGAManager sendState:@"Count: Total Bird Kind" value:manager.totalBirdKindCount];
        [HALGAManager sendState:@"Count: Total Prefecture" value:manager.totalPrefectureCount];
        [HALGAManager sendState:@"Count: Total City" value:manager.totalCityCount];
        [HALGAManager sendState:@"GPS Enabled" value:[CLLocationManager locationServicesEnabled] ? 1 : 0];
        [setting setObject:[NSDate date] forKey:kHALStateRecordedDateKey];
    }
}

+ (void)sendView:(NSString *)page
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:page];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    [tracker set:kGAIScreenName value:nil];
}

+ (void)sendAction:(NSString *)action label:(NSString *)label value:(double)value
{
    [HALGAManager sendEventWithCategory:@"Action" action:action label:label value:value];
}

+ (void)sendState:(NSString *)state label:(NSString *)label value:(double)value
{
    [HALGAManager sendEventWithCategory:@"State" action:state label:label value:value];
}

+ (void)sendState:(NSString *)state value:(int)value
{
    [HALGAManager sendState:state
                      label:[NSString stringWithFormat:@"%d", value]
                      value:value];
}

+ (void)sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(double)value
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    NSMutableDictionary *params = [[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:@(value)] build];
    [tracker send:params];
}

@end
