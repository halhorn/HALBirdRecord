//
//  UIDevice+HALOSVersion.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "UIDevice+HALOSVersion.h"

@implementation UIDevice (HALOSVersion)

- (int)majorVersion
{
    NSArray *versionStrs = [self.systemVersion componentsSeparatedByString:@"."];
    NSString *version = versionStrs[0];
    return [version intValue];
}

- (int)minorVersion
{
    NSArray *versionStrs = [self.systemVersion componentsSeparatedByString:@"."];
    NSString *version = versionStrs[1];
    return [version intValue];
}

@end
