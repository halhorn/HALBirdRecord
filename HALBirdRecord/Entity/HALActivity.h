//
//  HALActivity.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecord.h"

@interface HALActivity : NSObject

@property(nonatomic) int dbID;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *location;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSDate *datetime;
@property(nonatomic) NSMutableArray *birdRecordList;

- (BOOL)birdExists:(int)birdID;
- (HALBirdRecord *)birdRecordWithID:(int)birdID;
- (void)addBird:(HALBirdRecord *)birdRecord;
- (void)addBirdWithID:(int)birdID;
- (void)removeBird:(int)birdID;

@end
