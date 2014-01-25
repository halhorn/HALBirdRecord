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
        } else if ([productID isEqualToString:kHALProductIDExpand5Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 5;
        } else if ([productID isEqualToString:kHALProductIDExpand15Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 15;
        } else if ([productID isEqualToString:kHALProductIDExpand50Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 50;
        } else if ([productID isEqualToString:kHALProductIDExpand100Activities]) {
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
      kHALProductIDExpand5Activities,
      kHALProductIDExpand15Activities,
      kHALProductIDExpand50Activities,
      kHALProductIDExpand100Activities,
      ];
}

+ (instancetype)productWithProductID:(NSString *)productID
{
    return [[self alloc] initWithProductID:productID];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALPurchase - %@", self.productID];
}

@end
