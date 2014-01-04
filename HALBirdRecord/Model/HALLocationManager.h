//
//  HALLocationManager.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/14.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HALLocationManager : NSObject

-(void) getCurrentLocationWithCompletion:(void(^)(CLLocationCoordinate2D, CLPlacemark *))completion;

@end
