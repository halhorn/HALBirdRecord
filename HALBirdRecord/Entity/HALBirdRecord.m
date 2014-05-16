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
#import "CLGeocoder+HALCoordinateGeocoder.h"
#import "NSNotificationCenter+HALDataUpdateNotification.h"

@interface HALBirdRecord()

@property(nonatomic) HALDB *db;
@property(nonatomic) HALLocationManager *locationManager;
@property(nonatomic) int processingCount;
@property(nonatomic) id strongSelf;

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

+ (id)birdRecordWithDBRow:(NSDictionary *)row
{
    return [[self alloc] initWithDBRow:row];
}

- (id)initWithDBRow:(NSDictionary *)birdRow
{
    self = [super init];
    if (self) {
        NSNumber *birdID = [self removeNSNull:birdRow[@"birdID"]];
        NSNumber *count = [self removeNSNull:birdRow[@"count"]];
        NSNumber *latitude = [self removeNSNull:birdRow[@"latitude"]];
        NSNumber *longitude = [self removeNSNull:birdRow[@"longitude"]];
        NSString *prefecture = [self removeNSNull:birdRow[@"prefecture"]];
        NSString *city = [self removeNSNull:birdRow[@"city"]];
        NSString *comment = [self removeNSNull:birdRow[@"comment"]];
        NSNumber *birdUnixtime = [self removeNSNull:birdRow[@"datetime"]];
        NSNumber *birdDBID = birdRow[@"id"];
        
        self.db = [HALDB sharedDB];
        self.locationManager = [[HALLocationManager alloc] init];
        _birdID = [birdID intValue];
        _dbID = [birdDBID intValue];
        _count = [count intValue];
        _coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        _datetime = [NSDate dateWithTimeIntervalSince1970:[birdUnixtime doubleValue]];
        _prefecture = prefecture;
        _city = city;
        _comment = comment;
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

- (void)setCurrentLocationAndPlacemarkAndUpdateDBAsync
{
    self.processingCount++;
    self.strongSelf = self;
    WeakSelf weakSelf = self;
    [self.locationManager getCurrentLocationWithCompletion:^(CLLocationCoordinate2D coordinate){
        _coordinate = coordinate;
        [weakSelf updateDB];
        [weakSelf updatePlacemarkAndDBAsync];
    }];
}

- (void)updatePlacemarkAndDBAsync
{
    WeakSelf weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeCoordinate:self.coordinate completionHandler:^(CLPlacemark *placemark){
        if (placemark && [weakSelf isPrefectureString:placemark.addressDictionary[@"State"]]) {
            _prefecture = placemark.addressDictionary[@"State"];
            if (placemark.addressDictionary[@"City"]) {
                _city = placemark.addressDictionary[@"City"];
            }
        }
        [weakSelf updateDB];
        weakSelf.processingCount--;
        weakSelf.strongSelf = nil;
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
    [[NSNotificationCenter defaultCenter] postDataUpdateNotification];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALBirdRecord dbID:%d birdID:%d count:%d datetime:%@ coordinate:(%f,%f)[%@/%@] comment:%@", self.dbID, self.birdID, self.count, self.datetime, self.coordinate.latitude, self.coordinate.longitude, self.prefecture, self.city, self.comment];
}

- (id)removeNSNull:(id)var
{
    return [var isEqual:[NSNull null]] ? nil : var;
}

@end
