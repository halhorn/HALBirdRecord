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
@property(nonatomic) NSMutableArray *completionArray;

@end

@implementation HALLocationManager

- (id)init
{
    self = [super init];
    if (self) {
        [self setupManager];
        self.completionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) getCurrentLocationWithCompletion:(void(^)(CLLocationCoordinate2D))completion
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location Service Disabled!");
        completion(CLLocationCoordinate2DMake(0, 0));
        return;
    }
    
    [self.completionArray addObject:completion];
    [self.manager startUpdatingLocation];
}

#pragma mark - private methods

- (void)setupManager
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)executeCompletionsWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    for (void(^getLocationCompletion)(CLLocationCoordinate2D) in self.completionArray) {
        getLocationCompletion(coordinate);
    }
    self.completionArray = [[NSMutableArray alloc] init];
}

#pragma mark - CLLocationManagerDelegate methdos

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.manager stopUpdatingLocation];
    [self executeCompletionsWithCoordinate:newLocation.coordinate];
}

@end
