//
//  NSString+HALURLEncode.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "NSString+HALURLEncode.h"

@implementation NSString (HALURLEncode)
- (NSString *)urlEncodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)urlDecodedString
{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                NULL,
                                                                                (__bridge CFStringRef)self,
                                                                                CFSTR(""),
                                                                                kCFStringEncodingUTF8);
}
@end
