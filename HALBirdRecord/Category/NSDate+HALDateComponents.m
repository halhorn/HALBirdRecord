//
//  NSDate+HALDateComponents.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "NSDate+HALDateComponents.h"

@implementation NSDate (HALDateComponents)

+ (NSDate *)dateWithYear:(int)year
                   month:(int)month
                     day:(int)day
                    hour:(int)hour
                  minute:(int)minute
                  second:(int)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    return [calendar dateFromComponents:components];
}

+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSYearCalendarUnit |
            NSMonthCalendarUnit  |
            NSDayCalendarUnit    |
            NSHourCalendarUnit   |
            NSMinuteCalendarUnit |
            NSSecondCalendarUnit
                       fromDate:date];
}

+ (NSDateComponents *)dateComponentsForCurrentDate
{
    return [self dateComponentsWithDate:[self date]];
}

@end
