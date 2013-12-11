//
//  HALSaveActivityViewController.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/10.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALBirdRecordList.h"
#import "HALActivity.h"

@interface HALSaveActivityViewController : UIViewController

-(id) initWithBirdRecord:(HALBirdRecordList *)birdRecord completion:(void(^)(HALActivity *))completion;

@end
