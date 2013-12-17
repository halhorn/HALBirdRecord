//
//  HALBirdPointAnnotation.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/14.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HALBirdRecord.h"
#import "HALActivity.h"

@interface HALBirdPointAnnotation : NSObject<MKAnnotation>

+ (NSArray *)annotationListWithActivity:(HALActivity *)activity;
- (id)initWithBirdRecord:(HALBirdRecord *)birdRecord;

@end
