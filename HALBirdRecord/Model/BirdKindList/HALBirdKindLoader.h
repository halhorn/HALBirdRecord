//
//  HALBirdKindLoader.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/01.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdKind.h"

@interface HALBirdKindLoader : NSObject

@property(nonatomic, readonly) NSArray *birdKindList;
+ (instancetype)sharedLoader;

- (HALBirdKind *)birdKindFromBirdID:(int)birdID;

@end
