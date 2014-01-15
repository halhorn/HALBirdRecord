//
//  HALBirdRecordTableViewCell.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/15.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HALBirdRecord.h"

@interface HALBirdRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *birdImageView;
@property (weak, nonatomic) IBOutlet UILabel *birdKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

- (void)setupView:(HALBirdRecord *)birdRecord;
+ (NSString *)cellIdentifier;
+ (UINib *)nib;

@end
