//
//  HALStatistics.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/16.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStatistics.h"
#import "HALActivity.h"
#import "HALBirdRecord.h"
#import "HALBirdKindLoader.h"

@interface HALStatistics()

@property(nonatomic) HALDB *db;

@end

@implementation HALStatistics

+ (instancetype)sharedModel
{
    static dispatch_once_t onceToken;
    static HALStatistics *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALStatistics alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.db = [HALDB sharedDB];
    }
    return self;
}

- (NSArray *)totalBirdKind
{
    NSArray *dictArray = [self.db selectTotalBirdKind];
    HALBirdKindLoader *loader = [HALBirdKindLoader sharedLoader];
    return [self mapWithDictArray:dictArray key:@"birdID" block:^id(id obj){
        NSNumber *birdIDNum = obj;
        return [loader birdKindFromBirdID:[birdIDNum intValue]];
    }];
}

- (NSArray *)totalPrefectureAndCity
{
    return [self.db selectTotalPrefectureAndCity];
}

- (NSArray *)mapWithDictArray:(NSArray *)array key:(NSString *)key block:(id(^)(id))block
{
    NSMutableArray *arr = [NSMutableArray array];
    for(id obj in array) {
        id elm = obj[key];
        if ([elm isEqual:[NSNull null]]) {
            continue;
        }
        id ret  = block(elm);
        if(ret) {
            [arr addObject:ret];
        }
    }
    return arr;
}

@end
