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

+ (NSArray *)annotationListWithActivity:(HALActivity *)activity
{
    NSMutableArray *annotationList = [[NSMutableArray alloc] init];
    for (HALBirdRecord *birdRecord in activity.birdRecordList) {
        [annotationList addObject:[[HALBirdPointAnnotation alloc] initWithBirdRecord:birdRecord]];
    }
    return [NSArray arrayWithArray:annotationList];
}

- (id)initWithBirdRecord:(HALBirdRecord *)birdRecord
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
        self.coordinate = birdRecord.coordinate;
        self.title = birdRecord.kind.name;
        self.subtitle = [dateFormatter stringFromDate:birdRecord.datetime];
    }
    return self;
}
@end
