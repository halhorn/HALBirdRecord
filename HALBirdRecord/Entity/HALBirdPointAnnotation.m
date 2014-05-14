//
//  HALBirdPointAnnotation.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/14.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdPointAnnotation.h"

@interface HALBirdPointAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation HALBirdPointAnnotation

- (id)initWithBirdRecord:(HALBirdRecord *)birdRecord
{
    self = [super init];
    if (self) {
        _birdRecord = birdRecord;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
        self.coordinate = birdRecord.coordinate;
        self.title = birdRecord.kind.name;
        self.subtitle = [dateFormatter stringFromDate:birdRecord.datetime];
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

@end
