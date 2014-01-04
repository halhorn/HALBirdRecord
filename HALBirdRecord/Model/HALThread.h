//
//  HALThread.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/04.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALThread : NSObject

+ (void)waitUntil:(BOOL(^)())prediction do:(void(^)(BOOL))block maxWait:(double)maxWaitTime;

@end
