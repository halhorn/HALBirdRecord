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

@property(nonatomic, readonly) NSArray *activityList;

+ (instancetype)sharedManager;
- (void)loadActivityList;
- (void)saveActivity:(HALActivity *)activity;

@end
