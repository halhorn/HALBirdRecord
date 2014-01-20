//
//  CLGeocoder+HALCoordinateGeocoder.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/19.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "CLGeocoder+HALCoordinateGeocoder.h"

@implementation CLGeocoder (HALCoordinateGeocoder)

-(void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(CLPlacemark *))completion
{
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                         altitude:0
                                               horizontalAccuracy:0
                                                 verticalAccuracy:0
                                                        timestamp:[NSDate date]];
    [self reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark;
        if (placemarks.count) {
            placemark = placemarks[0];
        }
        completion(placemark);
    }];
}

@end
