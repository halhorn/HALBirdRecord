//
//  HALLocationManager.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/14.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALLocationManager.h"

@interface HALLocationManager()<CLLocationManagerDelegate>

@property(nonatomic) CLLocationManager *manager;
@property(nonatomic, copy) void(^getLocationCompletion)(CLLocationCoordinate2D);

@end

@implementation HALLocationManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static HALLocationManager *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALLocationManager alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"Location Service Disabled!");
            return nil;
        }
        [self setupManager];
    }
    return self;
}

-(void) getCurrentLocationWithCompletion:(void(^)(CLLocationCoordinate2D))completion;
{
    self.getLocationCompletion = completion;
    [self.manager startUpdatingLocation];
}

#pragma mark - private methods

- (void)setupManager
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - CLLocationManagerDelegate methdos

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.manager stopUpdatingLocation];
    self.getLocationCompletion(newLocation.coordinate);
}

@end
