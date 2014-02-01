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
    return [self hasProduct:kHALProductIDProAccount];
}

- (BOOL)isDonationMember
{
    return [self hasProduct:kHALProductIDDonationMember];
}

- (BOOL)isStudentAccount
{
    return [self hasProduct:kHALProductIDStudentAccount];
}

- (BOOL)isUnlimitedAccount
{
    return [self isDonationMember] || [self isProAccount] || [self isStudentAccount];
}

- (BOOL)hasProduct:(NSString *)producID
{
    for (HALProduct *product in self.productManager.productList) {
        if ([product.productID isEqualToString:producID]) {
            return YES;
        }
    }
    return NO;
}


@end
