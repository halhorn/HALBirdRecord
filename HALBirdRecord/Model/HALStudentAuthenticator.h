//
//  HALStudentAuthenticator.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/30.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HALStudentAuthenticationRequestState) {
    HALStudentAuthenticationRequestStateError = -2,
    HALStudentAuthenticationRequestStateDenied = -1,
    HALStudentAuthenticationRequestStateRequesting = 0,
    HALStudentAuthenticationRequestStateAccepted = 1,
};

@interface HALStudentAuthenticator : NSObject

+ (instancetype)sharedAuthenticator;
+ (NSString *)studentAuthenticatedNotificationName;

- (BOOL)isStudentAuthenticationRequesting;
- (BOOL)isExpired;
- (void)checkIsStudentWithCompletion:(void(^)(HALStudentAuthenticationRequestState))completion;
- (void)requestStudentAuthenticationWithImage:(UIImage *)image
                                       expire:(NSDate *)expire
                                   completion:(void(^)(BOOL, NSError *))completion;
- (void)cancelStudentAuthenticationRequest;
@end
