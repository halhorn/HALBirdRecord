//
//  NSDate+HALDateComponents.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HALDateComponents)

+ (NSDate *)dateWithYear:(int)year
                   month:(int)month
                     day:(int)day
                    hour:(int)hour
                  minute:(int)minute
                  second:(int)second;
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;
+ (NSDateComponents *)dateComponentsForCurrentDate;

@end
