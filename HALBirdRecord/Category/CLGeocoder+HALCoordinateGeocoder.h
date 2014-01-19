//
//  CLGeocoder+HALCoordinateGeocoder.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/19.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (HALCoordinateGeocoder)

-(void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void(^)(CLPlacemark *))completion;

@end
