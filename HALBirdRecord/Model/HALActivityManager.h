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

+ (NSString *)updateActivityNotificationName;
+ (instancetype)sharedManager;
- (int)activityCount;
- (int)totalBirdKindCount;
- (int)totalPrefectureCount;
- (HALActivity *)activityWithIndex:(int)index;
- (void)saveActivity:(HALActivity *)activity;
- (void)deleteActivity:(HALActivity *)activity;

@end
