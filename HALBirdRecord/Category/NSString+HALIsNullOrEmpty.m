//
//  NSString+HALIsNullOrEmpty.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/31.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "NSString+HALIsNullOrEmpty.h"

@implementation NSString (HALIsNullOrEmpty)

+ (BOOL)isNullOrEmpty:(NSString *)string
{
    return !string || [string isEqualToString:@""];
}

@end
