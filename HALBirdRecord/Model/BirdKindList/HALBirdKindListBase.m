//
//  HALBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindListBase.h"

@interface HALBirdKindListBase()

@end

@implementation HALBirdKindListBase

+ (instancetype)sharedBirdKindList
{
    static dispatch_once_t onceToken;
    static HALBirdKindListBase *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALBirdKindListBase alloc] init];
    });
    return sharedObject;
}

- (int)numberOfGroups
{
    return self.birdKindList.count;
}

- (NSString *)groupNameForGroupIndex:(int)index
{
    return @"";
}

@end
