//
//  HALPurchaseManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/21.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALProductManager.h"
#import <Parse/Parse.h>

#define kHALProActivityCapacity 100000
#define kHALDefaultActivityCapacity 20

@interface HALProductManager()

@property(nonatomic) NSArray *productList;

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
        [self addProductObservers];
    }
    return self;
}

#pragma mark - other public methods
- (BOOL)isProAccount
{
    return [self containsProduct:HALProductKindProAccount];
}

- (BOOL)isDonationMember
{
    return [self containsProduct:HALProductKindDonationMember];
}

- (int)activityCapacity
{
    if ([self isProAccount] || [self isDonationMember]) {
        return kHALProActivityCapacity;
    }
    
    int capacity = kHALDefaultActivityCapacity;
    for (HALProduct *product in self.productList) {
        if (product.productType == HALProductTypeExpandActivity) {
            capacity += product.value;
        }
    }
    return capacity;
}

- (void)purchaseProduct:(HALProductKind)productKind withCompletion:(void(^)(BOOL))completion;
{
    NSString *productID = [HALProduct productIDWithProductKind:productKind];
    [PFPurchase buyProduct:productID block:^(NSError *error) {
        if (!error) {
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
            completion(YES);
            [HALGAManager sendAction:@"Success Purchase" label:productID value:0];
        } else {
            completion(NO);
            [HALGAManager sendAction:@"Fail Purchase" label:productID value:0];
        }
    }];
}

#pragma mark - other private method

- (BOOL)containsProduct:(HALProductKind)productKind
{
    for (HALProduct *product in self.productList) {
        if (product.productKind == productKind) {
            return YES;
        }
    }
    return NO;
}

- (void)addProductObservers
{
    for (HALProductKind kind = 1; kind <= kHALMaxProductKind; kind++) {
        NSString *productID = [HALProduct productIDWithProductKind:kind];
        
        [PFPurchase addObserverForProduct:productID block:^(SKPaymentTransaction *transaction) {
            NSLog(@"%@ was bought", productID);
        }];
    }
}

@end
