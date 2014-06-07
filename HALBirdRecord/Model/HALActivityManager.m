//
//  HALActivityManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/12.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityManager.h"
#import "HALProductManager.h"
#import "HALDB.h"
#import "HALProductManager.h"
#import "HALBirdKindLoader.h"
#import "NSNotificationCenter+HALDataUpdateNotification.h"

#define kHALDefaultActivityCapacity 20
#define kHALDummyActivityName @"__DummyActivity__"

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
        self.db = [HALDB sharedDB];
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

- (int)activityCapacity
{
    int capacity = kHALDefaultActivityCapacity;
    HALProductManager *productManager = [HALProductManager sharedManager];
    for (HALProduct *product in [productManager productList]) {
        if (product.productType == HALProductTypeExpandActivity) {
            capacity += product.value;
        }
    }
    return capacity;
}


- (HALActivity *)activityWithIndex:(int)index
{
    if (!self.activityList) {
        [self loadActivityList];
    }
    HALActivity *activity = self.activityList[index];
    if (!activity.birdRecordList.count) {
        [activity loadBirdRecordListByOrder:HALBirdRecordOrderDateTime];
    }
    return activity;
}

- (int)totalBirdKindCount
{
    return [self.db countTotalBirdKinds];
}

- (int)totalPrefectureCount
{
    return [self.db countTotalPrefectures];
}

- (int)totalCityCount
{
    return [self.db countTotalCities];
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
    [self.db insertActivityRecord:activity];
    activity.dbID = [self.db selectLastIdOfActivityTable];
    [self.db insertBirdRecordList:activity.birdRecordList activityID:activity.dbID];
    [self loadActivityList];
    [self notifyActivityUpdate];
}

- (void)updateExistingActivity:(HALActivity *)activity
{
    [self.db deleteBirdRecordsInActivity:activity];
    [self.db insertBirdRecordList:activity.birdRecordList activityID:activity.dbID];
    [self.db updateActivity:activity];
    [self loadActivityList];
    [self notifyActivityUpdate];
}

- (void)deleteActivity:(HALActivity *)activity
{
    [self.db deleteBirdRecordsInActivity:activity];
    [self.db deleteActivity:activity];
    [self loadActivityList];
    [self notifyActivityUpdate];
}

- (void)notifyActivityUpdate
{
    [[NSNotificationCenter defaultCenter] postDataUpdateNotification];
}

#pragma mark - dummy data maker
- (void)makeDummyDataWithActivityCount:(NSInteger)activityCount birdRecordCount:(NSInteger)birdRecordCount
{
    for (int i=0; i < activityCount; i++) {
        HALActivity *activity = [[HALActivity alloc] init];
        activity.title = kHALDummyActivityName;
        for (int j=0; j < birdRecordCount; j++) {
            NSInteger birdID = arc4random() % 800;
            HALBirdRecord *record = [HALBirdRecord birdRecordWithBirdID:birdID];
            int lat = (arc4random() % 25) + 20;
            int lng = (arc4random() % 30) + 122;
            record.coordinate = CLLocationCoordinate2DMake(lat, lng);
            [activity addBirdRecord:record];
            NSLog(@"activity:%d",i);
        }
        [self registNewActivity:activity];
        for (int j=0; j < birdRecordCount; j++) {
            HALBirdRecord *record = activity.birdRecordList[j];
            [record updatePlacemarkAndDBAsync];
        }
    }
}

- (void)removeDummyData
{
    for (HALActivity *activity in self.activityList) {
        if ([activity.title isEqualToString:kHALDummyActivityName]) {
            [self deleteActivity:activity];
        }
    }
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

- (id)removeNSNull:(id)var
{
    return [var isEqual:[NSNull null]] ? nil : var;
}

@end
