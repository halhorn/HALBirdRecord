//
//  HALRecord.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HALBirdKind.h"

@interface HALBirdRecord : NSObject

@property(nonatomic) int dbID;
@property(nonatomic, readonly) int birdID;
@property(nonatomic) int count;
@property(nonatomic) NSDate *datetime;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic) NSString *prefecture;
@property(nonatomic) NSString *city;
@property(nonatomic, readonly) HALBirdKind *kind;

+ (id)birdRecordWithBirdID:(int)birdID;
- (id)initWithBirdID:(int)birdID;
- (void)setCurrentLocationAsync;
- (BOOL)isProcessing;

@end
