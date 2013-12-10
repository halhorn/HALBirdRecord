//
//  HALSaveActivityViewController.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/10.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALBirdRecord.h"
#import "HALActivityRecordEntity.h"

@interface HALSaveActivityViewController : UIViewController

-(id) initWithBirdRecord:(HALBirdRecord *)birdRecord completion:(void(^)(HALActivityRecordEntity *))completion;

@end
