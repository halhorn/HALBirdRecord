//
//  HALStudentAuthenticator.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/30.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStudentAuthenticator.h"
#import <Parse/Parse.h>

#define kHALStudentAuthenticationRequestIDSettingKey @"StudentAuthenticationRequestID"
#define kHALStudentIDSettingKey @"StudentID"
#define kHALStudentRequestClassName @"StudentRequest"

#define kHALPropertyImage @"image"
#define kHALPropertyExpire @"expire"
#define kHALPropertyAuthenticated @"authenticated"

@implementation HALStudentAuthenticator

+ (instancetype)sharedAuthenticator
{
    static dispatch_once_t onceToken;
    static HALStudentAuthenticator *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALStudentAuthenticator alloc] init];
    });
    return sharedObject;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isStudentAuthenticationRequesting
{
    NSString *requestID = [[NSUserDefaults standardUserDefaults] objectForKey:kHALStudentAuthenticationRequestIDSettingKey];
    return requestID != nil && ![requestID isEqualToString:@""];
}

- (BOOL)isStudent
{
    NSString *studentID = [[NSUserDefaults standardUserDefaults] objectForKey:kHALStudentIDSettingKey];
    return studentID != nil && ![studentID isEqualToString:@""];
}

- (void)checkIsStudentWithCompletion:(void(^)(BOOL))completion
{
    
}

- (void)requestStudentAuthenticationWithImage:(UIImage *)image
                                       expire:(NSDate *)expire
                                   completion:(void(^)(BOOL))completion;
{
    PFObject *requestObject = [PFObject objectWithClassName:kHALStudentRequestClassName];
    PFFile *imageFile = [PFFile fileWithName:[[NSUUID UUID] UUIDString] data:UIImagePNGRepresentation(image)];
    requestObject[kHALPropertyImage] = imageFile;
    requestObject[kHALPropertyExpire] = expire;
    requestObject[kHALPropertyAuthenticated] = @(NO);
    [requestObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        completion(succeeded);
    }];
}


@end
