//
//  HALDataExporter.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALDataExporter : NSObject

+ (void)exportAllDataToCSVWithCompletion:(void(^)(NSString *))completion;
+ (void)exportAllDataToParseWithCompletion:(void(^)(BOOL, NSString *))completion;
+ (void)importDataFromParseWithKey:(NSString *)objectId
                        completion:(void(^)(BOOL, NSString *))completion;

@end
