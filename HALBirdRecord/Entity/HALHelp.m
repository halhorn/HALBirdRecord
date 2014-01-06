//
//  HALHelp.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALHelp.h"

@implementation HALHelp

+ (instancetype)helpWithQuestion:(NSString *)question answer:(NSString *)answer
{
    return [[self alloc] initWithQuestion:question answer:answer];
}


- (id)initWithQuestion:(NSString *)question answer:(NSString *)answer
{
    self = [super init];
    if (self) {
        self.question = question;
        self.answer = answer;
    }
    return self;
}

@end
