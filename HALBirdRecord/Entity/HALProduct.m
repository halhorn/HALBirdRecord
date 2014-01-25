//
//  HALPurchaseProduct.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/22.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALProduct.h"

@implementation HALProduct
- (id)initWithProductID:(NSString *)productID
{
    self = [super init];
    if (self) {
        _productID = productID;
        if ([productID isEqualToString:kHALProductIDProAccount]) {
            _productType = HALProductTypePremiumAccount;
            _productSource = HALProductSourcePurchased;
            _value = 0;
        } else if ([productID isEqualToString:kHALProductIDDonationMember]) {
            _productType = HALProductTypePremiumAccount;
            _productSource = HALProductSourcePurchased;
            _value = 0;
        } else if ([productID isEqualToString:kHALProductIDExpand5Activity]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 5;
        } else if ([productID isEqualToString:kHALProductIDExpand20Activity]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 20;
        } else if ([productID isEqualToString:kHALProductIDExpand50Activity]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 50;
        } else if ([productID isEqualToString:kHALProductIDExpand100Activity]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 100;
        } else {
            NSAssert(0, @"Unknown Product");
        }
    }
    return self;
}

+ (NSArray *)productIDList
{
    return
    @[
      kHALProductIDProAccount,
      kHALProductIDDonationMember,
      kHALProductIDExpand5Activity,
      kHALProductIDExpand20Activity,
      kHALProductIDExpand50Activity,
      kHALProductIDExpand100Activity,
      ];
}

+ (instancetype)productWithProductID:(NSString *)productID
{
    return [[self alloc] initWithProductID:productID];
}

@end
