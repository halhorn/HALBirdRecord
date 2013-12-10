//
//  HALDB.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecordEntity.h"
#import "HALActivityRecordEntity.h"

@interface HALDB : NSObject

- (void)showRecordInTable:(NSString *)tableName;
- (int)selectLastIdOfActivityTable;
- (int)insertActivityRecord:(HALActivityRecordEntity *)entity;
- (int)insertBirdRecordList:(NSArray *)entityList activityID:(int)activityID;

@end
