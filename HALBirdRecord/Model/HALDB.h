//
//  HALDB.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecord.h"
#import "HALActivity.h"

@interface HALDB : NSObject

- (void)showRecordInTable:(NSString *)tableName;
- (NSArray *)selectActivityRows;
- (NSArray *)selectBirdRecordListWithActivityDBID:(int)dbID;
- (int)selectLastIdOfActivityTable;
- (int)insertActivityRecord:(HALActivity *)activity;
- (int)insertBirdRecordList:(NSArray *)birdRecordList activityID:(int)activityID;
- (int)updateActivity:(HALActivity *)activity;
- (int)deleteBirdRecordsInActivity:(HALActivity *)activity;
- (int)deleteActivity:(HALActivity *)activity;
- (void)dropTables;

@end
