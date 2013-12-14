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
        [self loadActivityList];
    }
    return self;
}

- (void)loadActivityList
{
    NSMutableArray *activityList = [[NSMutableArray alloc] init];
    NSArray *activityRows = [self.db selectActivityRows];
    for (NSDictionary *activityRow in activityRows) {
        NSNumber *activityID = activityRow[@"id"];
        NSNumber *activityUnixTime = activityRow[@"datetime"];
        NSNumber *activityDBID = activityRow[@"id"];
        
        HALActivity *activity = [[HALActivity alloc] init];
        activity.title = activityRow[@"title"];
        activity.location = activityRow[@"location"];
        activity.comment = activityRow[@"comment"];
        activity.datetime = [NSDate dateWithTimeIntervalSince1970:[activityUnixTime doubleValue]];
        activity.dbID = [activityDBID intValue];
        
        NSArray *birdRows = [self.db selectBirdRecordListWithActivityDBID:[activityID intValue]];
        for (NSDictionary *birdRow in birdRows) {
            NSNumber *birdID = birdRow[@"birdID"];
            NSNumber *count = birdRow[@"count"];
            NSNumber *latitude = birdRow[@"latitude"];
            NSNumber *longitude = birdRow[@"longitude"];
            NSNumber *birdUnixtime = birdRow[@"datetime"];
            NSNumber *birdDBID = birdRow[@"id"];
            
            HALBirdRecord *bird = [[HALBirdRecord alloc] initWithBirdID:[birdID intValue]];
            bird.dbID = [birdDBID intValue];
            bird.count = [count intValue];
            bird.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
            bird.datetime = [NSDate dateWithTimeIntervalSince1970:[birdUnixtime doubleValue]];
            [activity addBird:bird];
        }
        [activityList addObject:activity];
    }
    _activityList = activityList;
}

- (void)registActivity:(HALActivity *)activity
{
    int activityID = 0;
    [self.db insertActivityRecord:activity];
    activityID = [self.db selectLastIdOfActivityTable];
    [self.db insertBirdRecordList:activity.birdRecordList activityID:activityID];
    [self loadActivityList];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.activityList];
}

@end
