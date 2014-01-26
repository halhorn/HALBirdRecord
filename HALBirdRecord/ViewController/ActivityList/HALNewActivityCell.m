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
@property (weak, nonatomic) IBOutlet UILabel *activityCountLabel;

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
    self.createActivityLabel.textColor = kHALTextColor;
    self.activityCountLabel.textColor = kHALSubTextColor;
    HALActivityManager *activityManager = [HALActivityManager sharedManager];
    int capacity = [activityManager activityCapacity];
    if (capacity == 0) {
        self.activityCountLabel.text = [NSString stringWithFormat:@"(%d/∞)", activityManager.activityCount];
    } else {
        self.activityCountLabel.text = [NSString stringWithFormat:@"(%d/%d)", activityManager.activityCount, activityManager.activityCapacity];
    }
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

- (IBAction)onTapPurchase:(id)sender {
    if (!self.tapPurchaseBlock) {
        return;
    }
    self.tapPurchaseBlock();
}

@end
