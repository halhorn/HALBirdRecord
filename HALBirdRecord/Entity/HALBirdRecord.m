//
//  HALRecord.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdRecord.h"
#import "HALBirdKindListBase.h"
#import "HALLocationManager.h"
#import "HALDB.h"

#define kHALUpdateBirdRecordNotificationName @"HALBirdRecordManagerUpdateActivity"

@interface HALBirdRecord()

@property(nonatomic) HALDB *db;
@property(nonatomic) HALLocationManager *locationManager;
@property(nonatomic) int processingCount;

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

+ (NSString *)updateBirdRecordNotificationName
{
    return kHALUpdateBirdRecordNotificationName;
}

+ (id)birdRecordWithBirdID:(int)birdID
{
    return [[self alloc] initWithBirdID:birdID];
}

- (id)initWithBirdID:(int)birdID
{
    self = [super init];
    if (self) {
        self.db = [HALDB sharedDB];
        self.locationManager = [[HALLocationManager alloc] init];
        _dbID = 0;
        _birdID = birdID;
        _datetime = [NSDate date];
        _count = 1;
        _kind = nil;
        _coordinate = CLLocationCoordinate2DMake(0, 0);
        _prefecture = @"";
        _city = @"";
        _comment = @"";
        _processingCount = 0;
    }
    return self;
}

- (HALBirdKind *)kind
{
    if (!_kind) {
        _kind = [[HALBirdKindLoader sharedLoader] birdKindFromBirdID:self.birdID];
    }
    return _kind;
}

- (void)setCurrentLocationAsync
{
    self.processingCount++;
    [self.locationManager getCurrentLocationWithCompletion:^(CLLocationCoordinate2D coordinate, CLPlacemark *placemark){
        _coordinate = coordinate;
        if (placemark && [self isPrefectureString:placemark.addressDictionary[@"State"]]) {
            _prefecture = placemark.addressDictionary[@"State"];
            if (placemark.addressDictionary[@"City"]) {
                _city = placemark.addressDictionary[@"City"];
            }
        }
        self.processingCount--;
    }];
}

- (BOOL)isProcessing
{
    return self.processingCount > 0;
}

- (BOOL)isPrefectureString:(NSString *)str
{
    return [str hasSuffix:@"都"] || [str hasSuffix:@"道"] || [str hasSuffix:@"府"] || [str hasSuffix:@"県"];
}

- (void)updateDB
{
    [self.db updateBirdRecord:self];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHALUpdateBirdRecordNotificationName object:nil]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALBirdRecord dbID:%d birdID:%d count:%d datetime:%@ coordinate:(%f,%f)[%@/%@] comment:%@", self.dbID, self.birdID, self.count, self.datetime, self.coordinate.latitude, self.coordinate.longitude, self.prefecture, self.city, self.comment];
}
@end
