//
//  HALBirdKindListViewController.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALBirdRecord.h"

@protocol HALBirdRecordViewDelegate <NSObject>

- (HALBirdRecord *)sendBirdRecord;

@end

@interface HALBirdKindListViewController : UIViewController

@end
