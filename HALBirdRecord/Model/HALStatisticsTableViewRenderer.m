//
//  HALStatisticsTableViewRenderer.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStatisticsTableViewRenderer.h"
#import "HALStatistics.h"
#import "HALBirdKind.h"

@interface HALStatisticsTableViewRenderer()

@property (nonatomic) NSMutableArray *birdGroups;
@property (nonatomic) NSDictionary *birdKinds;
@property (nonatomic) NSMutableArray *prefectures;
@property (nonatomic) NSDictionary *cities;

@end

@implementation HALStatisticsTableViewRenderer

- (id)init
{
    self = [super init];
    if (self) {
        [self setupStatisticsData];
    }
    return self;
}

- (void)setupStatisticsData
{
    HALStatistics *statistics = [HALStatistics sharedModel];
    self.birdGroups = [[NSMutableArray alloc] init];
    NSMutableDictionary *kindDict = [[NSMutableDictionary alloc] init];
    for (HALBirdKind *kind in [statistics totalBirdKind]) {
        if (!kindDict[kind.groupName]) {
            kindDict[kind.groupName] = [[NSMutableArray alloc] init];
            [self.birdGroups addObject:kind.groupName];
        }
        [kindDict[kind.groupName] addObject:kind];
    }
    self.birdKinds = kindDict;

    self.prefectures = [[NSMutableArray alloc] init];
    NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *prefAndCity in [statistics totalPrefectureAndCity]) {
        if (!cityDict[prefAndCity[@"prefecture"]]) {
            cityDict[prefAndCity[@"prefecture"]] = [[NSMutableArray alloc] init];
            [self.prefectures addObject:prefAndCity[@"prefecture"]];
        }
        [cityDict[prefAndCity[@"prefecture"]] addObject:prefAndCity];
    }
    self.cities = cityDict;
}

- (NSUInteger)sectionCount
{
    switch (self.statisticsType) {
        case HALStatisticsTypeBirdKind:
            return [self.birdGroups count];
            
        case HALStatisticsTypeCity:
            return [self.prefectures count];
            
        default:
            NSAssert(NO, @"Invalid Statistics Type");
            break;
    }
}

- (NSUInteger)rowCountInSection:(NSInteger)section
{
    switch (self.statisticsType) {
        case HALStatisticsTypeBirdKind:
            return [self.birdKinds[self.birdGroups[section]] count];
            
        case HALStatisticsTypeCity:
            return [self.cities[self.prefectures[section]] count];
            
        default:
            NSAssert(NO, @"Invalid Statistics Type");
            break;
    }
}

- (NSString *)headerForSection:(NSInteger)section
{
    switch (self.statisticsType) {
        case HALStatisticsTypeBirdKind:
            return self.birdGroups[section];
            
        case HALStatisticsTypeCity:
            return self.prefectures[section];
            
        default:
            NSAssert(NO, @"Invalid Statistics Type");
            break;
    }
}

- (NSDictionary *)rowDataAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.statisticsType) {
        case HALStatisticsTypeBirdKind:{
            HALBirdKind *kind = self.birdKinds[self.birdGroups[indexPath.section]][indexPath.row];
            return @{
                     @"title" : kind.name,
                     @"image" : kind.image,
                     };
        }
        case HALStatisticsTypeCity:{
            NSDictionary *dict = self.cities[self.prefectures[indexPath.section]][indexPath.row];
            return @{
                     @"title" : dict[@"city"],
                     };
        }
            
        default:
            NSAssert(NO, @"Invalid Statistics Type");
            break;
    }
}

@end
