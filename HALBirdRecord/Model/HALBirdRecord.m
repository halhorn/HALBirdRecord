//
//  HALBirdRecord.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecord.h"
#import "HALDB.h"

@implementation HALBirdRecord

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

- (HALBirdRecordEntity *)birdRecordWithID:(int)birdID
{
    for (HALBirdRecordEntity *birdRecord in self.birdRecordList) {
        if (birdRecord.birdID == birdID) {
            return birdRecord;
        }
    }
    return nil;
}

- (void)addBird:(int)birdID
{
    HALBirdRecordEntity *birdRecord = [self birdRecordWithID:birdID];
    if (birdRecord) {
        birdRecord.count++;
    } else {
        HALBirdRecordEntity *record = [HALBirdRecordEntity birdRecordWithBirdID:birdID];
        [self.birdRecordList addObject:record];
    }
}

- (void)removeBird:(int)birdID
{
    HALBirdRecordEntity *remove;
    for (HALBirdRecordEntity *birdRecord in self.birdRecordList) {
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
