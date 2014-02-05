//
//  NSNotificationCenter+HALDataUpdateNotification.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (HALDataUpdateNotification)

-(void) addDataUpdateObserver:(id)observer
                     selector:(SEL)selector;

-(void) postDataUpdateNotification;


@end
