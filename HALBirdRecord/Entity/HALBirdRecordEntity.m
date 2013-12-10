//
//  HALRecordEntity.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecordEntity.h"

@implementation HALBirdRecordEntity

#pragma mark getter/setter

-(void)setDbID:(int)dbID
{
    NSAssert(_dbID == -1, @"dbIDは一度設定すると変更不可能です。");
    _dbID = dbID;
}

#pragma mark initializer

+ (id)birdRecordWithBirdID:(int)birdID
{
    return [[self alloc] initWithBirdID:birdID];
}

- (id)initWithBirdID:(int)birdID
{
    self = [super init];
    if (self) {
        _dbID = -1;
        _birdID = birdID;
        _datetime = [NSDate date];
        _count = 1;
    }
    return self;
}

#pragma mark methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALBirdRecordEntity birdID:%d count:%d datetime:%@ coordinate:(%f,%f)", self.birdID, self.count, self.datetime, self.coordinate.latitude, self.coordinate.longitude];
}
@end
