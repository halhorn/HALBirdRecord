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

- (NSArray *)birdKindListWithRawBirdList:(NSArray *)rawBirdKindList
{
    NSSortDescriptor *familySortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:YES];
    NSSortDescriptor *nameSortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedList = [rawBirdKindList sortedArrayUsingDescriptors:@[familySortDescripter, nameSortDescripter]];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int groupID = -1;
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    for (HALBirdKind *kind in sortedList) {
        if (kind.groupID != groupID) {
            groupID = kind.groupID;
            groupArray = [[NSMutableArray alloc] init];
            [array addObject:groupArray];
        }
        [groupArray addObject:kind];
    }
    return [NSArray arrayWithArray:array];
}

- (NSString *)groupNameForGroupIndex:(int)index
{
    HALBirdKind *kind = self.birdKindList[index][0];
    return kind.groupName;
}
@end
