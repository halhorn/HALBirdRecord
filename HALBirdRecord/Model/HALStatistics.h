//
//  HALStatistics.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/16.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALStatistics : NSObject

+ (instancetype)sharedModel;

- (NSArray *)totalBirdKind;
- (NSArray *)totalPrefectureAndCity;

@end
