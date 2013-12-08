//
//  HALBirdRecord.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecord.h"
#import "HALBirdRecordEntity.h"
#import "HALBirdKind.h"
#import "HALBirdKindEntity.h"

@implementation HALBirdRecord

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    HALBirdKind *kind = [HALBirdKind sharedBirdKind];
    NSMutableArray *record = [[NSMutableArray alloc] init];
    for (NSArray *birdGroup in kind.birdKindList) {
        NSMutableArray *recordGroup = [[NSMutableArray alloc] init];
        for (HALBirdKindEntity *kindEntity in birdGroup) {
            HALBirdRecordEntity *recordEntity = [HALBirdRecordEntity birdRecordWithBirdID:kindEntity.birdID];
            [recordGroup addObject:recordEntity];
        }
        [record addObject:[NSArray arrayWithArray:recordGroup]];
    }
    
    self.birdRecordList = [NSArray arrayWithArray:record];
}
@end
