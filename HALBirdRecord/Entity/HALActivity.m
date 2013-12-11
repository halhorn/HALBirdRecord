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
        self.dbID = -1;
        self.datetime = [NSDate date];
        self.title = @"";
        self.location = @"";
        self.comment = @"";
        _birdRecordList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)birdExists:(int)birdID
{
    return [self birdRecordWithID:birdID] != nil;
}

- (HALBirdRecord *)birdRecordWithID:(int)birdID
{
    for (HALBirdRecord *birdRecord in self.birdRecordList) {
        if (birdRecord.birdID == birdID) {
            return birdRecord;
        }
    }
    return nil;
}

- (void)addBird:(int)birdID
{
    HALBirdRecord *birdRecord = [self birdRecordWithID:birdID];
    if (birdRecord) {
        birdRecord.count++;
    } else {
        HALBirdRecord *record = [HALBirdRecord birdRecordWithBirdID:birdID];
        [self.birdRecordList addObject:record];
    }
}

- (void)removeBird:(int)birdID
{
    HALBirdRecord *remove;
    for (HALBirdRecord *birdRecord in self.birdRecordList) {
        if (birdRecord.birdID == birdID) {
            remove = birdRecord;
            break;
        }
    }
    if (remove) {
        [self.birdRecordList removeObject:remove];
    }
}

@end
