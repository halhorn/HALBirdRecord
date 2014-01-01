//
//  HALActivityListViewCell.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALActivity.h"

@interface HALActivityListViewCell : UITableViewCell

- (void)setupUIWithActivity:(HALActivity *)activity;
+ (NSString *)cellIdentifier;
+ (UINib *)nib;

@end
