//
//  HALAccount.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/27.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALAccount : NSObject

+ (instancetype)myAccount;

- (BOOL)isProAccount;
- (BOOL)isDonationMember;
- (BOOL)isUnlimitedAccount;
- (int)activityCapacity;

@end
