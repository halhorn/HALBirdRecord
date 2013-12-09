//
//  NSURL+HALDataURL.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (HALLocalFileURL)

+ (instancetype)urlWithLocalFileName:(NSString *)fileName;

@end
