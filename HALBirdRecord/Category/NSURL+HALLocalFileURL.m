//
//  NSURL+HALDataURL.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "NSURL+HALLocalFileURL.h"

@implementation NSURL (HALLocalFileURL)

+ (instancetype)urlWithLocalFileName:(NSString *)fileName
{
    NSParameterAssert(fileName);
    
    NSArray *documentDirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirPath = documentDirPaths[0];
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:fileName];
    
    return [[self alloc] initFileURLWithPath:filePath];
}

@end
