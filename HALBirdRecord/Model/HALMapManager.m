//
//  HALMapManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALMapManager.h"
#import "HALBirdPointAnnotation.h"

#define kHALMapRegionNormalMinSpan 0.001
#define kHALMapRegionVastMinSpan 3
#define kHALMapRegionMarginScale 1.5
#define kHALMapRegionUpperMargin 0.4

@interface HALMapManager()

@property(nonatomic) HALActivity *activity;

@end

@implementation HALMapManager

+ (instancetype)managerWithActivity:(HALActivity *)activity
{
    return [[self alloc] initWithActivity:activity];
}

- (id)initWithActivity:(HALActivity *)activity
{
    self = [super init];
    if (self) {
        self.activity = activity;
    }
    return self;
}

- (NSArray *)annotationList
{
    NSMutableArray *annotationList = [[NSMutableArray alloc] init];
    for (HALBirdRecord *birdRecord in self.activity.birdRecordList) {
        if (birdRecord.coordinate.latitude == 0 && birdRecord.coordinate.longitude == 0) {
            continue;
        }
        [annotationList addObject:[[HALBirdPointAnnotation alloc] initWithBirdRecord:birdRecord]];
    }
    return [NSArray arrayWithArray:annotationList];
}

- (NSArray *)averagePointAnnotation
{
    if (!self.activity.birdRecordList.count) {
        return @[];
    }
    CGFloat latitude = 0;
    CGFloat longitude = 0;
    int count = 0;
    for (HALBirdRecord *birdRecord in self.activity.birdRecordList) {
        if (birdRecord.coordinate.latitude == 0 && birdRecord.coordinate.longitude == 0) {
            continue;
        }
        latitude += birdRecord.coordinate.latitude;
        longitude += birdRecord.coordinate.longitude;
        count++;
    }
    HALBirdPointAnnotation *annotation = [[HALBirdPointAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude / count, longitude / count) title:@"所在地" subtitle:@""];
    return @[annotation];
}

- (MKCoordinateRegion)region
{
    return [self regionWithMinSpan:kHALMapRegionNormalMinSpan];
}

- (MKCoordinateRegion)vastRegion
{
    return [self regionWithMinSpan:kHALMapRegionVastMinSpan];
}

- (MKCoordinateRegion)regionWithMinSpan:(double)minSpan
{
    double minLatitude = 360;
    double minLongitude = 360;
    double maxLatitude = -360;
    double maxLongitude = -360;
    int count = 0;
    for (HALBirdRecord *birdRecord in self.activity.birdRecordList) {
        CLLocationCoordinate2D coord = birdRecord.coordinate;
        if (coord.latitude == 0 && coord.longitude == 0) {
            continue;
        }
        if (coord.latitude > maxLatitude) { maxLatitude = coord.latitude; }
        if (coord.latitude < minLatitude) { minLatitude = coord.latitude; }
        if (coord.longitude > maxLongitude) { maxLongitude = coord.longitude; }
        if (coord.longitude < minLongitude) { minLongitude = coord.longitude; }
        count++;
    }
    
    if (count == 0) {
        // データが無かったらとりあえず京都でも表示しとけ
        return MKCoordinateRegionMake(CLLocationCoordinate2DMake(35.0042, 135.4601), MKCoordinateSpanMake(1, 1));
    }
    
    double centerLatitude = (minLatitude + maxLatitude) / 2;
    double centerLongitude = (minLongitude + maxLongitude) / 2;
    double spanLatitude = MAX((maxLatitude - minLatitude) * kHALMapRegionMarginScale, minSpan);
    double spanLongitude = MAX((maxLongitude - minLongitude) * kHALMapRegionMarginScale, minSpan);
    
    // ピンの分だけmapを上に伸ばす
    centerLatitude += spanLatitude * kHALMapRegionUpperMargin / 2;
    spanLatitude *= 1 + kHALMapRegionUpperMargin;
    
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerLatitude, centerLongitude), MKCoordinateSpanMake(spanLatitude, spanLongitude));
}

@end
