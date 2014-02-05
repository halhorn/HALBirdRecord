//
//  HALActivityManager.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/12.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALActivity.h"

@interface HALActivityManager : NSObject

+ (instancetype)sharedManager;
- (int)activityCount;
- (int)activityCapacity;
- (int)totalBirdKindCount;
- (int)totalPrefectureCount;
- (int)totalCityCount;
- (HALActivity *)activityWithIndex:(int)index;
- (void)saveActivity:(HALActivity *)activity;
- (void)deleteActivity:(HALActivity *)activity;
- (void)notifyActivityUpdate;

@end
