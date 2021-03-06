//
//  HALGAManager.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/04.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GAI.h>

@interface HALGAManager : NSObject

+ (void)setup;
+ (void)sendState;
+ (void)sendView:(NSString *)page;
+ (void)sendAction:(NSString *)action label:(NSString *)label value:(double)value;

@end
