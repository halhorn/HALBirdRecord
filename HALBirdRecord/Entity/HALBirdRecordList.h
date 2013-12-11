//
//  HALBirdRecordList.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecord.h"
#import "HALActivity.h"

@interface HALBirdRecordList : NSObject

@property(nonatomic) NSMutableArray *birdRecordList;
@property(nonatomic) HALActivity *activityRecord;

- (BOOL)birdExists:(int)birdID;
- (HALBirdRecord *)birdRecordWithID:(int)birdID;
- (void)addBird:(int)birdID;
- (void)removeBird:(int)birdID;
- (void)save;

@end
