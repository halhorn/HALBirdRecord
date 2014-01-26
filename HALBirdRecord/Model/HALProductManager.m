//
//  HALPurchaseManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/21.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALProductManager.h"
#import <Parse/Parse.h>

#define kHALDefaultActivityCapacity 20
#define kHALProductSettingKey @"HALPurchasedProductSetting"

@interface HALProductManager()

@property(nonatomic) NSMutableArray *rawProductList;

@end

@implementation HALProductManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static HALProductManager *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALProductManager alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
#ifdef DEBUG
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kHALProductSettingKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif
        [self loadProductList];
        [self addProductObservers];
    }
    return self;
}

#pragma mark - other public methods
- (NSArray *)productList
{
    return [NSArray arrayWithArray:self.rawProductList];
}

- (BOOL)isProAccount
{
    return [self containsProduct:kHALProductIDProAccount];
}

- (BOOL)isDonationMember
{
    return [self containsProduct:kHALProductIDDonationMember];
}

- (int)activityCapacity
{
    if ([self isProAccount] || [self isDonationMember]) {
        return 0;
    }
    
    int capacity = kHALDefaultActivityCapacity;
    for (HALProduct *product in self.rawProductList) {
        if (product.productType == HALProductTypeExpandActivity) {
            capacity += product.value;
        }
    }
    return capacity;
}

- (void)purchaseProduct:(NSString *)productID withCompletion:(void(^)(BOOL))completion;
{
    [PFPurchase buyProduct:productID block:^(NSError *error) {
        if (!error) {
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
            completion(YES);
            [HALGAManager sendAction:@"Success Purchase" label:productID value:0];
        } else {
            completion(NO);
            [HALGAManager sendAction:@"Fail Purchase"
                               label:[NSString stringWithFormat:@"ID:%@ error:%@", productID, error.userInfo]
                               value:0];
        }
    }];
}

#pragma mark - other private method

- (void)loadProductList
{
    self.rawProductList = [[NSMutableArray alloc] init];
    NSArray *purchasedList = [[NSUserDefaults standardUserDefaults] objectForKey:kHALProductSettingKey];
    if (!purchasedList) {
        purchasedList = @[];
    }
    for (NSString *productID in purchasedList) {
        HALProduct *product = [HALProduct productWithProductID:productID];
        [self.rawProductList addObject:product];
    }
}

- (void)saveProductList
{
    NSMutableArray *purchasedIDList = [[NSMutableArray alloc] init];
    for (HALProduct *product in self.rawProductList) {
        [purchasedIDList addObject:product.productID];
    }
    [[NSUserDefaults standardUserDefaults] setObject:purchasedIDList forKey:kHALProductSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)containsProduct:(NSString *)producID
{
    for (HALProduct *product in self.rawProductList) {
        if ([product.productID isEqualToString:producID]) {
            return YES;
        }
    }
    return NO;
}

- (void)addProductObservers
{
    for (NSString *productID in [HALProduct purchaseProductIDList]) {
        [PFPurchase addObserverForProduct:productID block:^(SKPaymentTransaction *transaction) {
            [self.rawProductList addObject:[HALProduct productWithProductID:productID]];
            [self saveProductList];
            NSLog(@"purchase %@", productID);
        }];
    }
}

@end
