//
//  HALActivity.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivity.h"

@implementation HALActivity

- (id)init
{
    self = [super init];
    if (self) {
        self.dbID = 0;
        self.title = @"";
        self.comment = @"";
        _birdRecordList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addBirdRecord:(HALBirdRecord *)birdRecord
{
    [self.birdRecordList addObject:birdRecord];
}

- (void)addBirdRecordList:(NSArray *)birdRecordList
{
    for (HALBirdRecord *record in birdRecordList) {
        [self addBirdRecord:record];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Activity: dbID:%d title:%@ comment:%@ birds:%@", self.dbID, self.title, self.comment, self.birdRecordList];
}

@end
