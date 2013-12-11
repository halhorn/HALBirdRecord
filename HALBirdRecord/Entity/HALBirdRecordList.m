//
//  HALBirdRecordList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecordList.h"
#import "HALDB.h"

@implementation HALBirdRecordList

- (id)init
{
    self = [super init];
    if (self) {
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

- (void)save
{
    int activityID = 0;
    HALDB *db = [[HALDB alloc] init];
    if (self.activityRecord) {
        [db insertActivityRecord:self.activityRecord];
        activityID = [db selectLastIdOfActivityTable];
    }
    [db insertBirdRecordList:self.birdRecordList activityID:activityID];
}

@end
