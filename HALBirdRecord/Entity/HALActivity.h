//
//  HALActivity.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HALBirdRecord.h"

@interface HALActivity : NSObject

@property(nonatomic) int dbID;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSMutableArray *birdRecordList;

- (void)addBirdRecord:(HALBirdRecord *)birdRecord;
- (void)addBirdRecordList:(NSArray *)birdRecordList;
- (MKCoordinateRegion)getRegion;

@end
