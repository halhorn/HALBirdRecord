//
//  HALPurchaseProduct.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/22.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHALMaxProductKind 6

typedef NS_ENUM(NSUInteger, HALProductKind) {
    HALProductKindProAccount = 1,
    HALProductKindDonationMember,
    HALProductKindExpand5Activity,
    HALProductKindExpand20Activity,
    HALProductKindExpand50Activity,
    HALProductKindExpand100Activity,
};

typedef NS_ENUM(NSUInteger, HALProductType) {
    HALProductTypeExpandActivity,
    HALProductTypePremiumAccount,
};

@interface HALProduct : NSObject

@property(nonatomic, copy, readonly) NSString *productID;
@property(nonatomic, readonly) HALProductKind productKind;
@property(nonatomic, readonly) HALProductType productType;
@property(nonatomic, readonly) int value;

- (id)initWithProductKind:(HALProductKind)productKind;
+ (instancetype)productWithProductKind:(HALProductKind)productKind;
+ (NSString *)productIDWithProductKind:(HALProductKind)productKind;
@end
