//
//  HALRecordEntity.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HALBirdRecordEntity : NSObject

@property(nonatomic) int dbID;
@property(nonatomic, readonly) int birdID;
@property(nonatomic) int count;
@property(nonatomic) NSDate *datetime;
@property(nonatomic) CLLocationCoordinate2D coordinate;

+ (id)birdRecordWithBirdID:(int)birdID;
- (id)initWithBirdID:(int)birdID;

@end
