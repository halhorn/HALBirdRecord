//
//  HALStudentAuthenticator.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/30.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALStudentAuthenticator : NSObject

+ (instancetype)sharedAuthenticator;

- (BOOL)isStudentAuthenticationRequesting;
- (BOOL)isStudent;
- (void)checkIsStudentWithCompletion:(void(^)(BOOL))completion;
- (void)requestStudentAuthenticationWithImage:(UIImage *)image
                                       expire:(NSDate *)expire
                                   completion:(void(^)(BOOL))completion;

@end
