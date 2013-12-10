//
//  HALBirdKind.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALBirdKindEntity.h"

@interface HALBirdKind : NSObject

+ (instancetype)sharedBirdKind;

@property(nonatomic, readonly) NSArray *birdKindList;
@property(nonatomic, readonly) int numberOfGroups;

- (HALBirdKindEntity *)birdKindEntityFromBirdID:(int)birdID;

@end
