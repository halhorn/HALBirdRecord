//
//  NSDate+HALDateString.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "NSDate+HALDateString.h"

@implementation NSDate (HALDateString)

- (NSString *)dateString
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [outputFormatter stringFromDate:[NSDate date]];
}

@end
