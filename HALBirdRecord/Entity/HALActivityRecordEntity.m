//
//  HALActivityRecordEntity.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityRecordEntity.h"

@implementation HALActivityRecordEntity

- (id)init
{
    self = [super init];
    if (self) {
        self.dbID = -1;
        self.datetime = [NSDate date];
        self.title = @"";
        self.location = @"";
        self.comment = @"";
    }
    return self;
}

@end
