//
//  HALNewActivityCell.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/25.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALNewActivityCell : UITableViewCell

@property(nonatomic, copy) void(^tapPurchaseBlock)(void);

+ (NSString *)cellIdentifier;
+ (UINib *)nib;

@end
