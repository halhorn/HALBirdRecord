//
//  HALStatisticsViewCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStatisticsViewCell.h"

@implementation HALStatisticsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier
{
    return @"HALStatisticsViewCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALStatisticsViewCell" bundle:nil];
}

@end
