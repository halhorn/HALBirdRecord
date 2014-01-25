//
//  HALPurchaseProduct.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/22.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHALProductIDProAccount @"ProAccount"
#define kHALProductIDDonationMember @"DonationMember"
#define kHALProductIDExpand5Activity @"Expand5Activity"
#define kHALProductIDExpand20Activity @"Expand20Activity"
#define kHALProductIDExpand50Activity @"Expand50Activity"
#define kHALProductIDExpand100Activity @"Expand100Activity"

typedef NS_ENUM(NSUInteger, HALProductType) {
    HALProductTypeExpandActivity,
    HALProductTypePremiumAccount,
};
typedef NS_ENUM(NSUInteger, HALProductSource) {
    HALProductSourcePurchased,
    HALProductSourceOther,
};

@interface HALProduct : NSObject

@property(nonatomic, copy, readonly) NSString *productID;
@property(nonatomic, readonly) HALProductType productType;
@property(nonatomic, readonly) HALProductSource productSource;
@property(nonatomic, readonly) int value;

- (id)initWithProductID:(NSString *)productID;
+ (instancetype)productWithProductID:(NSString *)productID;
+ (NSArray *)productIDList;
@end
