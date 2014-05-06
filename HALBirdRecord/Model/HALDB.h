//
//  HALDB.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecord.h"
@class HALActivity;

typedef NS_ENUM(NSUInteger, HALBirdRecordOrder) {
    HALBirdRecordOrderDateTime,
    HALBirdrecordOrderBirdID,
};

@interface HALDB : NSObject

+ (instancetype)sharedDB;
- (void)showRecordInTable:(NSString *)tableName;
- (NSArray *)selectActivityRows;
- (NSArray *)selectBirdRecordListWithActivityDBID:(int)dbID order:(HALBirdRecordOrder)order;
- (int)selectLastIdOfActivityTable;
- (int)countTotalBirdKinds;
- (int)countTotalPrefectures;
- (int)countTotalCities;
- (int)insertActivityRecord:(HALActivity *)activity;
- (int)insertBirdRecordList:(NSArray *)birdRecordList activityID:(int)activityID;
- (int)updateActivity:(HALActivity *)activity;
- (int)deleteBirdRecordsInActivity:(HALActivity *)activity;
- (int)deleteActivity:(HALActivity *)activity;
- (int)updateBirdRecord:(HALBirdRecord *)record;
- (void)dropTables;

// Statistics Methods ///////////////////////////////////////////////////
- (NSArray *)selectTotalBirdKind;
- (NSArray *)selectTotalPrefectureAndCity;

@end
