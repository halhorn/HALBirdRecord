//
//  HALBirdKindListViewController.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALActivity.h"

@protocol HALBirdRecordViewDelegate <NSObject>

- (NSArray *)sendBirdList;

@end

@interface HALBirdKindListViewController : UIViewController

-(id) initWithCompletion:(void(^)(NSArray *))completion;

@end
