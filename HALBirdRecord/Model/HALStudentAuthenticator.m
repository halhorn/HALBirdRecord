//
//  HALStudentAuthenticator.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/30.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStudentAuthenticator.h"
#import "NSString+HALIsNullOrEmpty.h"
#import <Parse/Parse.h>

#define kHALStudentAuthenticationRequestIDSettingKey @"StudentAuthenticationRequestID"
#define kHALStudentIDSettingKey @"StudentID"
#define kHALStudentExpireSettingKey @"StudentExpire"
#define kHALStudentRequestClassName @"StudentRequest"
#define kHALStudentAuthenticatedNotificationName @"StudentAuthenticatedNotification"

#define kHALPropertyImage @"image"
#define kHALPropertyExpire @"expire"
#define kHALPropertyRequestState @"requestState"

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

+ (NSString *)studentAuthenticatedNotificationName
{
    return kHALStudentAuthenticatedNotificationName;
}

- (BOOL)isStudentAuthenticationRequesting
{
    NSString *requestID = [[NSUserDefaults standardUserDefaults] objectForKey:kHALStudentAuthenticationRequestIDSettingKey];
    return ![NSString isNullOrEmpty:requestID];
}

- (BOOL)isStudent
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *studentID = [setting objectForKey:kHALStudentIDSettingKey];
    return ![NSString isNullOrEmpty:studentID] && ![self isExpired];
}

- (BOOL)isExpired
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSDate *expireDate = [setting objectForKey:kHALStudentExpireSettingKey];
    BOOL expired = [expireDate compare:[NSDate date]] == NSOrderedAscending;
    return expired;
}

- (void)checkIsStudentWithCompletion:(void(^)(HALStudentAuthenticationRequestState))completion;
{
    NSString *requestID = [[NSUserDefaults standardUserDefaults] objectForKey:kHALStudentAuthenticationRequestIDSettingKey];
    if ([NSString isNullOrEmpty:requestID]) {
        completion(HALStudentAuthenticationRequestStateError);
        return;
    } else if ([self isStudent]) {
        completion(HALStudentAuthenticationRequestStateAccepted);
        return;
    }
    PFQuery *query = [PFQuery queryWithClassName:kHALStudentRequestClassName];
    [query getObjectInBackgroundWithId:requestID block:^(PFObject *object, NSError *error){
        HALStudentAuthenticationRequestState state = [object[kHALPropertyRequestState] intValue];
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        if (state == HALStudentAuthenticationRequestStateAccepted) {
            [setting setObject:requestID forKey:kHALStudentIDSettingKey];
            [setting setObject:object[kHALPropertyExpire] forKey:kHALStudentExpireSettingKey];
            [setting removeObjectForKey:kHALStudentAuthenticationRequestIDSettingKey];
            [setting synchronize];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHALStudentAuthenticatedNotificationName object:nil]];
        } else if (state == HALStudentAuthenticationRequestStateDenied) {
            [setting removeObjectForKey:kHALStudentAuthenticationRequestIDSettingKey];
            [setting synchronize];
        }
        completion(state);
    }];
}

- (void)requestStudentAuthenticationWithImage:(UIImage *)image
                                       expire:(NSDate *)expire
                                   completion:(void(^)(BOOL))completion;
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    if ([self isStudentAuthenticationRequesting]) {
        [self cancelStudentAuthenticationRequest];
        [setting removeObjectForKey:kHALStudentAuthenticationRequestIDSettingKey];
    }
    PFObject *requestObject = [PFObject objectWithClassName:kHALStudentRequestClassName];
    PFFile *imageFile = [PFFile fileWithName:[[NSUUID UUID] UUIDString] data:UIImagePNGRepresentation(image)];
    requestObject[kHALPropertyImage] = imageFile;
    requestObject[kHALPropertyExpire] = expire;
    requestObject[kHALPropertyRequestState] = @(HALStudentAuthenticationRequestStateRequesting);
    [requestObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [setting setObject:requestObject.objectId
                        forKey:kHALStudentAuthenticationRequestIDSettingKey];
            [setting synchronize];
        }
        completion(succeeded);
    }];
}

- (void)cancelStudentAuthenticationRequest
{
    if ([self isStudent]) {
        return;
    } if (![self isStudentAuthenticationRequesting]) {
        return;
    }
    NSString *requestID = [[NSUserDefaults standardUserDefaults] objectForKey:kHALStudentAuthenticationRequestIDSettingKey];
    PFQuery *query = [PFQuery queryWithClassName:kHALStudentRequestClassName];
    [query getObjectInBackgroundWithId:requestID block:^(PFObject *object, NSError *error){
        [object deleteInBackground];
    }];
}

@end
