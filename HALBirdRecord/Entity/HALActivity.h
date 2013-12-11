//
//  HALActivityRecord.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALActivity : NSObject

@property(nonatomic) int dbID;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *location;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSDate *datetime;

@end
