//
//  HALHelpListLoader.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALHelpListLoader : NSObject

@property(nonatomic, readonly) NSArray *helpList;
+ (instancetype)sharedLoader;

@end
