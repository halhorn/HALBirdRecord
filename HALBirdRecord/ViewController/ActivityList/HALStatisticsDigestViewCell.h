//
//  HALStatisticsViewCell.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALStatisticsDigestViewCell : UITableViewCell

+ (NSString *)cellIdentifier;
+ (UINib *)nib;

- (void)load;

@end
