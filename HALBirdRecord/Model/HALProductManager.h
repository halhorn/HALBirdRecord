//
//  HALPurchaseManager.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/21.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALProduct.h"

@interface HALProductManager : NSObject

+ (instancetype)sharedManager;

- (void)purchaseProduct:(HALProductKind)product withCompletion:(void(^)(BOOL))completion;
- (BOOL)isProAccount;
- (BOOL)isDonationMember;
- (int)activityCapacity;

@end
