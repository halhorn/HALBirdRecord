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

@property(nonatomic, readonly) NSArray *productList;

+ (instancetype)sharedManager;

- (void)purchaseProduct:(NSString *)productID withCompletion:(void(^)(BOOL))completion;
- (void)restoreProductList;

@end
