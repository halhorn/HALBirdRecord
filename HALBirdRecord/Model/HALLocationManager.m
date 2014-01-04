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
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"Location Service Disabled!");
            return nil;
        }
        [self setupManager];
        self.completionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) getCurrentLocationWithCompletion:(void(^)(CLLocationCoordinate2D, CLPlacemark *))completion;
{
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

#pragma mark - CLLocationManagerDelegate methdos

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark;
        if (placemarks.count) {
            placemark = placemarks[0];
        }
        for (void(^getLocationCompletion)(CLLocationCoordinate2D, CLPlacemark *) in self.completionArray) {
            getLocationCompletion(newLocation.coordinate, placemark);
        }
        self.completionArray = [[NSMutableArray alloc] init];
    }];
}

@end
