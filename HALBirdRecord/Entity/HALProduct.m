//
//  HALPurchaseProduct.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/22.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALProduct.h"

@implementation HALProduct
- (id)initWithProductKind:(HALProductKind)productKind;
{
    self = [super init];
    if (self) {
        switch (productKind) {
            case HALProductKindProAccount:
                _productID = @"ProAccount";
                _productKind = HALProductKindProAccount;
                _productType = HALProductTypePremiumAccount;
                _value = 0;
                break;
            case HALProductKindDonationMember:
                _productID = @"DonationMember";
                _productKind = HALProductKindDonationMember;
                _productType = HALProductTypePremiumAccount;
                _value = 0;
                break;
            case HALProductKindExpand5Activity:
                _productID = @"Expand5Activity";
                _productKind = HALProductKindExpand5Activity;
                _productType = HALProductTypeExpandActivity;
                _value = 5;
                break;
            case HALProductKindExpand20Activity:
                _productID = @"Expand20Activity";
                _productKind = HALProductKindExpand20Activity;
                _productType = HALProductTypeExpandActivity;
                _value = 20;
                break;
            case HALProductKindExpand50Activity:
                _productID = @"Expand50Activity";
                _productKind = HALProductKindExpand50Activity;
                _productType = HALProductTypeExpandActivity;
                _value = 50;
                break;
            case HALProductKindExpand100Activity:
                _productID = @"Expand100Activity";
                _productKind = HALProductKindExpand100Activity;
                _productType = HALProductTypeExpandActivity;
                _value = 100;
                break;
                
            default:
                NSAssert(0, @"Unknown Product");
                break;
        }
    }
    return self;
}

+ (instancetype)productWithProductKind:(HALProductKind)productKind;
{
    return [[self alloc] initWithProductKind:productKind];
}

+ (NSString *)productIDWithProductKind:(HALProductKind)productKind
{
    return [HALProduct productWithProductKind:productKind].productID;
}


@end
