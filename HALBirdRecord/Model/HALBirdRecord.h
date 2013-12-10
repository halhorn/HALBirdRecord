//
//  HALBirdRecord.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdRecordEntity.h"

@interface HALBirdRecord : NSObject

@property(nonatomic) NSMutableArray *birdRecordList;

- (BOOL)birdExists:(int)birdID;
- (HALBirdRecordEntity *)birdRecordWithID:(int)birdID;
- (void)addBird:(int)birdID;
- (void)removeBird:(int)birdID;

@end
