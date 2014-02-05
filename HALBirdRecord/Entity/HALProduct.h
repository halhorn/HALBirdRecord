//
//  HALPurchaseProduct.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/22.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

// PurchaseProduct
#define kHALProductIDProAccount @"ProAccount"
#define kHALProductIDDonationMember @"DonationMember"
#define kHALProductIDExpand5Activities @"Expand5Activities"
#define kHALProductIDExpand15Activities @"Expand15Activities"
#define kHALProductIDExpand50Activities @"Expand50Activities"
#define kHALProductIDExpand100Activities @"Expand100Activities"

// FreeProduct
#define kHALProductIDStudentAccount @"StudentAccount"

typedef NS_ENUM(NSUInteger, HALProductType) {
    HALProductTypeExpandActivity,
    HALProductTypePremiumAccount,
};
typedef NS_ENUM(NSUInteger, HALProductSource) {
    HALProductSourcePurchased,
    HALProductSourceStudentAuthentication,
    HALProductSourceConsumableFree,
};

@interface HALProduct : NSObject

@property(nonatomic, copy, readonly) NSString *productID;
@property(nonatomic, readonly) HALProductType productType;
@property(nonatomic, readonly) HALProductSource productSource;
@property(nonatomic, readonly) int value;

// 表示用
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *comment;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, readonly) int price;

- (id)initWithProductID:(NSString *)productID;
+ (instancetype)productWithProductID:(NSString *)productID;
+ (NSArray *)purchaseProductIDList;
+ (NSArray *)freeProductIDList;
@end
