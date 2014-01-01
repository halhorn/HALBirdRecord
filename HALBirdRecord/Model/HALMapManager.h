//
//  HALMapManager.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALActivity.h"

@interface HALMapManager : NSObject

+ (instancetype)managerWithActivity:(HALActivity *)activity;
- (id)initWithActivity:(HALActivity *)activity;
- (NSArray *)annotationList;
- (NSArray *)averagePointAnnotation;
- (MKCoordinateRegion)region;
- (MKCoordinateRegion)vastRegion;

@end
