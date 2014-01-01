//
//  HALActivityManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/12.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityManager.h"
#import "HALDB.h"

@interface HALActivityManager()

@property(nonatomic) NSArray *activityList;
@property(nonatomic) HALDB *db;

@end

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
        self.db = [[HALDB alloc] init];
    }
    return self;
}

- (int)activityCount
{
    if (!self.activityList) {
        [self loadActivityList];
    }
    return self.activityList.count;
}

- (HALActivity *)activityWithIndex:(int)index
{
    if (!self.activityList) {
        [self loadActivityList];
    }
    HALActivity *activity = self.activityList[index];
    if (!activity.birdRecordList.count) {
        [self loadBirdListForActivity:activity];
    }
    return activity;
}

- (void)saveActivity:(HALActivity *)activity
{
    if (activity.dbID) {
        [self updateExistingActivity:activity];
    } else {
        [self registNewActivity:activity];
    }
}

- (void)registNewActivity:(HALActivity *)activity
{
    int activityID = 0;
    [self.db insertActivityRecord:activity];
    activityID = [self.db selectLastIdOfActivityTable];
    [self.db insertBirdRecordList:activity.birdRecordList activityID:activityID];
    [self loadActivityList];
}

- (void)updateExistingActivity:(HALActivity *)activity
{
    [self.db deleteBirdRecordsInActivity:activity];
    [self.db insertBirdRecordList:activity.birdRecordList activityID:activity.dbID];
    [self.db updateActivity:activity];
    [self loadActivityList];
}

- (void)deleteActivity:(HALActivity *)activity
{
    [self.db deleteBirdRecordsInActivity:activity];
    [self.db deleteActivity:activity];
    [self loadActivityList];
}

#pragma mark - private method

- (void)loadActivityList
{
    NSMutableArray *activityList = [[NSMutableArray alloc] init];
    NSArray *activityRows = [self.db selectActivityRows];
    for (NSDictionary *activityRow in activityRows) {
        NSNumber *activityDBID = activityRow[@"id"];
        
        HALActivity *activity = [[HALActivity alloc] init];
        activity.title = [self removeNSNull:activityRow[@"title"]];
        activity.comment = [self removeNSNull:activityRow[@"comment"]];
        activity.dbID = [activityDBID intValue];
        // birdListは後で読み込む
        [activityList addObject:activity];
    }
    _activityList = activityList;
}

- (void)loadBirdListForActivity:(HALActivity *)activity
{
    NSArray *birdRows = [self.db selectBirdRecordListWithActivityDBID:activity.dbID];
    for (NSDictionary *birdRow in birdRows) {
        NSNumber *birdID = [self removeNSNull:birdRow[@"birdID"]];
        NSNumber *count = [self removeNSNull:birdRow[@"count"]];
        NSNumber *latitude = [self removeNSNull:birdRow[@"latitude"]];
        NSNumber *longitude = [self removeNSNull:birdRow[@"longitude"]];
        NSNumber *birdUnixtime = [self removeNSNull:birdRow[@"datetime"]];
        NSNumber *birdDBID = birdRow[@"id"];
        
        HALBirdRecord *bird = [[HALBirdRecord alloc] initWithBirdID:[birdID intValue]];
        bird.dbID = [birdDBID intValue];
        bird.count = [count intValue];
        bird.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        bird.datetime = [NSDate dateWithTimeIntervalSince1970:[birdUnixtime doubleValue]];
        [activity addBirdRecord:bird];
    }
}

- (id)removeNSNull:(id)var
{
    return [var isEqual:[NSNull null]] ? nil : var;
}

@end
