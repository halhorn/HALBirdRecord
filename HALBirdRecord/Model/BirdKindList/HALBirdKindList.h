//
//  HALBirdKindList.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdKind.h"

@interface HALBirdKindList : NSObject

@property(nonatomic, readonly) NSArray *birdKindList;

+ (instancetype)sharedBirdKindList;
- (HALBirdKind *)birdKindFromBirdID:(int)birdID;
- (NSArray *)birdKindListWithRawBirdList:(NSArray *)rawBirdKindList;
- (int)numberOfGroups;
- (NSString *)groupNameForGroupIndex:(int)index;

@end
