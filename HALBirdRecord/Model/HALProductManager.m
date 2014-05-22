//
//  HALPurchaseManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/21.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALProductManager.h"
#import "HALStudentAuthenticator.h"
#import "NSNotificationCenter+HALDataUpdateNotification.h"
#import "LUKeychainAccess.h"
#import <Parse/Parse.h>

#define kHALProductSettingKey @"HALPurchasedProductSetting"

@interface HALProductManager()

@property(nonatomic) NSMutableArray *rawProductList;
@property(nonatomic) HALStudentAuthenticator *studentAuthenticator;

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
        [self checkStudentExpire];
    }
    return self;
}

#pragma mark - other public methods
- (NSArray *)productList
{
    return [NSArray arrayWithArray:self.rawProductList];
}

- (void)purchaseProduct:(NSString *)productID withCompletion:(void(^)(BOOL))completion
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

- (void)restoreProductList
{
    self.rawProductList = [[NSMutableArray alloc] init];
    NSArray *purchasedList = [[LUKeychainAccess standardKeychainAccess] objectForKey:kHALProductSettingKey];
    if (!purchasedList) {
        purchasedList = @[];
    }
    for (NSString *productID in purchasedList) {
        HALProduct *product = [HALProduct productWithProductID:productID];
        [self.rawProductList addObject:product];
    }
    [self saveProductList];
}

- (void)saveProductList
{
    NSMutableArray *purchasedIDList = [[NSMutableArray alloc] init];
    for (HALProduct *product in self.rawProductList) {
        [purchasedIDList addObject:product.productID];
    }
    [[NSUserDefaults standardUserDefaults] setObject:purchasedIDList forKey:kHALProductSettingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[LUKeychainAccess standardKeychainAccess] setObject:purchasedIDList forKey:kHALProductSettingKey];
}

- (void)addProductObservers
{
    WeakSelf weakSelf = self;
    
    // 課金
    for (NSString *productID in [HALProduct purchaseProductIDList]) {
        [PFPurchase addObserverForProduct:productID block:^(SKPaymentTransaction *transaction) {
            [weakSelf.rawProductList addObject:[HALProduct productWithProductID:productID]];
            [weakSelf saveProductList];
            [[NSNotificationCenter defaultCenter] postDataUpdateNotification];
            NSLog(@"purchase %@", productID);
        }];
    }
    
    // 学生
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerAsStudent)
                                                 name:[HALStudentAuthenticator studentAuthenticatedNotificationName]
                                               object:nil];
}

- (void)registerAsStudent
{
    [self.rawProductList addObject:[HALProduct productWithProductID:kHALProductIDStudentAccount]];
    [self saveProductList];
    [[NSNotificationCenter defaultCenter] postDataUpdateNotification];
}

- (void)checkStudentExpire
{
    HALProduct *studentAccountProduct = nil;
    for (HALProduct *product in self.rawProductList) {
        if ([product.productID isEqualToString:kHALProductIDStudentAccount]) {
            studentAccountProduct = product;
        }
    }
    if (studentAccountProduct && [self.studentAuthenticator isExpired]) {
        [self.rawProductList removeObject:studentAccountProduct];
        [self saveProductList];
    }
}

@end
