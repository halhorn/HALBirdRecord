//
//  HALActivity.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivity.h"
#define kHALMapRegionMinSpan 0.001
#define kHALMapRegionMarginScale 1.2

@implementation HALActivity

- (id)init
{
    self = [super init];
    if (self) {
        self.dbID = 0;
        self.datetime = [NSDate date];
        self.title = @"";
        self.location = @"";
        self.comment = @"";
        _birdRecordList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addBirdRecord:(HALBirdRecord *)birdRecord
{
    [self.birdRecordList addObject:birdRecord];
}

- (void)addBirdRecordList:(NSArray *)birdRecordList
{
    for (HALBirdRecord *record in birdRecordList) {
        [self addBirdRecord:record];
    }
}

- (MKCoordinateRegion)getRegion
{
    if (self.birdRecordList.count == 0) {
        // データが無かったらとりあえず京都でも表示しとけ
        return MKCoordinateRegionMake(CLLocationCoordinate2DMake(35.0042, 135.4601), MKCoordinateSpanMake(1, 1));
    }
    double minLatitude = 360;
    double minLongitude = 360;
    double maxLatitude = -360;
    double maxLongitude = -360;
    for (HALBirdRecord *birdRecord in self.birdRecordList) {
        CLLocationCoordinate2D coord = birdRecord.coordinate;
        if (coord.latitude > maxLatitude) { maxLatitude = coord.latitude; }
        if (coord.latitude < minLatitude) { minLatitude = coord.latitude; }
        if (coord.longitude > maxLongitude) { maxLongitude = coord.longitude; }
        if (coord.longitude < minLongitude) { minLongitude = coord.longitude; }
    }
    double centerLatitude = (minLatitude + maxLatitude) / 2;
    double centerLongitude = (minLongitude + maxLongitude) / 2;
    double spanLatitude = MAX((maxLatitude - minLatitude) * kHALMapRegionMarginScale, kHALMapRegionMinSpan);
    double spanLongitude = MAX((maxLongitude - minLongitude) * kHALMapRegionMarginScale, kHALMapRegionMinSpan);
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerLatitude, centerLongitude), MKCoordinateSpanMake(spanLatitude, spanLongitude));
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title:%@ datetime:%@ location:%@ comment:%@ birds:%@", self.title, self.datetime, self.location, self.comment, self.birdRecordList];
}

@end
