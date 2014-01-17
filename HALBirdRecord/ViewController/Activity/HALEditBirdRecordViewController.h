//
//  HALEditBirdRecordViewController.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/16.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALBirdRecord.h"
#import "HALActivity.h"

@interface HALEditBirdRecordViewController : UIViewController

- (id)initWithBirdRecord:(HALBirdRecord *)birdRecord activity:(HALActivity *)activity;

@end
