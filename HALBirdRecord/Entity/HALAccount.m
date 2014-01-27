//
//  HALAccount.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/27.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALAccount.h"
#import "HALProductManager.h"

@interface HALAccount()

@property HALProductManager *productManager;

@end

@implementation HALAccount

+ (instancetype)myAccount
{
    static dispatch_once_t onceToken;
    static HALAccount *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALAccount alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.productManager = [HALProductManager sharedManager];
    }
    return self;
}

- (BOOL)isProAccount
{
    return [self.productManager isProAccount];
}

- (BOOL)isDonationMember
{
    return [self.productManager isDonationMember];
}

- (BOOL)isUnlimitedAccount
{
    return [self.productManager isUnlimitedAccount];
}

- (int)activityCapacity
{
    return [self.productManager activityCapacity];
}

@end
