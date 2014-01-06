//
//  HALHelp.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALHelp : NSObject

@property(nonatomic) NSString *question;
@property(nonatomic) NSString *answer;

+ (instancetype)helpWithQuestion:(NSString *)question answer:(NSString *)answer;
- (id)initWithQuestion:(NSString *)question answer:(NSString *)answer;

@end
