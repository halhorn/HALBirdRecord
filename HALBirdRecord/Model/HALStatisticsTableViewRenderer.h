//
//  HALStatisticsTableViewRenderer.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HALStatisticsType) {
    HALStatisticsTypeBirdKind,
    HALStatisticsTypeCity,
};

@interface HALStatisticsTableViewRenderer : NSObject

@property (nonatomic) HALStatisticsType statisticsType;

- (NSUInteger)sectionCount;
- (NSUInteger)rowCountInSection:(NSInteger)section;
- (NSString *)headerForSection:(NSInteger)section;
- (NSDictionary *)rowDataAtIndexPath:(NSIndexPath *)indexPath;

@end
