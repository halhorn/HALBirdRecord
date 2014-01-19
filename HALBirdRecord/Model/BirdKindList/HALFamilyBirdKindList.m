//
//  HALFamillyBirdKind.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/22.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALFamilyBirdKindList.h"

@implementation HALFamilyBirdKindList

+ (instancetype)sharedBirdKindList
{
    static dispatch_once_t onceToken;
    static HALFamilyBirdKindList *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALFamilyBirdKindList alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.birdKindList = [self birdKindListWithRawBirdList:[HALBirdKindLoader sharedLoader].birdKindList];
    }
    return self;
}

- (NSString *)groupNameForGroupIndex:(int)index
{
    HALBirdKind *kind = self.birdKindList[index][0];
    return kind.groupName;
}

- (NSArray *)birdKindListWithRawBirdList:(NSArray *)rawBirdKindList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int groupID = -1;
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    for (HALBirdKind *kind in rawBirdKindList) {
        if (kind.groupID != groupID) {
            groupID = kind.groupID;
            groupArray = [[NSMutableArray alloc] init];
            [array addObject:groupArray];
        }
        [groupArray addObject:kind];
    }
    return [NSArray arrayWithArray:array];
}

@end
