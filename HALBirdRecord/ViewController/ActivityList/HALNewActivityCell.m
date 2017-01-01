//
//  HALNewActivityCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/25.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALNewActivityCell.h"
#import "HALActivityManager.h"

@interface HALNewActivityCell()
@property (weak, nonatomic) IBOutlet UILabel *createActivityLabel;

@end

@implementation HALNewActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.createActivityLabel.textColor = kHALTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellIdentifier
{
    return @"HALNewActivityCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALNewActivityCell" bundle:nil];
}

@end
