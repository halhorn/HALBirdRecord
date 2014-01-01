//
//  HALRecord.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecord.h"
#import "HALBirdKindList.h"
#import "HALLocationManager.h"

@interface HALBirdRecord()

@property(nonatomic) HALLocationManager *locationManager;

@end

@implementation HALBirdRecord {
    HALBirdKind *_kind;
}

#pragma mark getter/setter

-(void)setDbID:(int)dbID
{
    NSAssert(_dbID == 0, @"dbIDは一度設定すると変更不可能です。");
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
        self.locationManager = [HALLocationManager sharedManager];
        _dbID = 0;
        _birdID = birdID;
        _datetime = [NSDate date];
        _count = 1;
        _kind = nil;
        [self.locationManager getCurrentLocationWithCompletion:^(CLLocationCoordinate2D coordinate){
            _coordinate = coordinate;
        }];
    }
    return self;
}

- (HALBirdKind *)kind
{
    if (!_kind) {
        _kind = [[HALBirdKindList sharedBirdKindList] birdKindFromBirdID:self.birdID];
    }
    return _kind;
}

#pragma mark methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALBirdRecord birdID:%d count:%d datetime:%@ coordinate:(%f,%f)", self.birdID, self.count, self.datetime, self.coordinate.latitude, self.coordinate.longitude];
}
@end
