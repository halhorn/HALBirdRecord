//
//  HALBirdKindList.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdKind.h"
#import "HALBirdKindLoader.h"

@interface HALBirdKindListBase : NSObject

@property(nonatomic) NSArray *birdKindList;

+ (instancetype)sharedBirdKindList;

- (int)numberOfGroups;
- (NSString *)groupNameForGroupIndex:(int)index;

@end
