//
//  HALActivityManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/12.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityManager.h"
#import "HALDB.h"

@implementation HALActivityManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static HALActivityManager *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALActivityManager alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadActivityList];
    }
    return self;
}

- (void)loadActivityList
{
    
}

- (void)registActivity:(HALActivity *)activity
{
    int activityID = 0;
    HALDB *db = [[HALDB alloc] init];
    [db insertActivityRecord:activity];
    activityID = [db selectLastIdOfActivityTable];
    [db insertBirdRecordList:activity.birdRecordList activityID:activityID];
    [self loadActivityList];
}

@end
