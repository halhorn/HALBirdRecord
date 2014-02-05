//
//  HALPurchaseViewCell.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/26.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALPurchaseViewCell : UITableViewCell

- (void)loadWithProductID:(NSString *)productID;
+ (NSString *)cellIdentifier;
+ (UINib *)nib;

@end
