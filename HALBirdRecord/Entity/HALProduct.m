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
            _title = @"Pro";
            _comment = @"保存できるアクティビティの数が無制限になります。";
            _image = nil;
            _price = 800;
        } else if ([productID isEqualToString:kHALProductIDDonationMember]) {
            _productType = HALProductTypePremiumAccount;
            _productSource = HALProductSourcePurchased;
            _value = 0;
            _title = @"Pro* (開発賛助)";
            _comment = @"開発賛助をしてくださる方はご購入お願いします。機能はProと同等です。";
            _image = nil;
            _price = 2000;
        } else if ([productID isEqualToString:kHALProductIDExpand5Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 5;
            _title = [NSString stringWithFormat:@"Activity+%d", _value];
            _comment = [NSString stringWithFormat:@"保存できるアクティビティの数を%d個増やすことができます。", _value];
            _image = nil;
            _price = 100;
        } else if ([productID isEqualToString:kHALProductIDExpand15Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 15;
            _title = [NSString stringWithFormat:@"Activity+%d", _value];
            _comment = [NSString stringWithFormat:@"保存できるアクティビティの数を%d個増やすことができます。", _value];
            _image = nil;
            _price = 200;
        } else if ([productID isEqualToString:kHALProductIDExpand50Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 50;
            _title = [NSString stringWithFormat:@"Activity+%d", _value];
            _comment = [NSString stringWithFormat:@"保存できるアクティビティの数を%d個増やすことができます。", _value];
            _image = nil;
            _price = 400;
        } else if ([productID isEqualToString:kHALProductIDExpand100Activities]) {
            _productType = HALProductTypeExpandActivity;
            _productSource = HALProductSourcePurchased;
            _value = 100;
            _title = [NSString stringWithFormat:@"Activity+%d", _value];
            _comment = [NSString stringWithFormat:@"保存できるアクティビティの数を%d個増やすことができます。", _value];
            _image = nil;
            _price = 600;
        } else {
            NSAssert(0, @"Unknown Product");
        }
    }
    return self;
}

+ (NSArray *)purchaseProductIDList
{
    return
    @[
      kHALProductIDExpand5Activities,
      kHALProductIDExpand15Activities,
      kHALProductIDExpand50Activities,
      kHALProductIDExpand100Activities,
      kHALProductIDProAccount,
      kHALProductIDDonationMember,
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
