//
//  HALStatisticsViewCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/02.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStatisticsViewCell.h"
#import "HALActivityManager.h"
#import "HALBirdKindLoader.h"
#import <MSSimpleGauge/MSSimpleGauge.h>

@interface HALStatisticsViewCell()

@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) MSSimpleGauge *birdKindCountGauge;
@property (weak, nonatomic) IBOutlet UIView *birdCountGageContainer;
@property (weak, nonatomic) IBOutlet UILabel *birdKindCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *birdKindCountTitleLabel;

@end

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

- (void)awakeFromNib
{
    self.activityManager = [HALActivityManager sharedManager];

    self.contentView.backgroundColor = kHALActivityListStatisticsBackgroundColor;

    [self setupBirdKindCount];
}

- (void)setupBirdKindCount
{
    HALBirdKindLoader *birdKindLoader = [HALBirdKindLoader sharedLoader];
    int allBirdKindCount = birdKindLoader.birdKindList.count;
    
    MSSimpleGauge *gauge = [[MSSimpleGauge alloc] initWithFrame:CGRectMake(0, 0, 100, 75)];
    gauge.backgroundColor = kHALActivityListStatisticsBackgroundColor;
    gauge.maxValue = allBirdKindCount;
    gauge.fillArcFillColor = kHALGaugeArcFillColor;
    gauge.backgroundArcFillColor = kHALGaugeBackgroundColor;
    gauge.backgroundArcStrokeColor = kHALGaugeBackgroundColor;
    gauge.startAngle = 20;
    gauge.endAngle = 160;
    [self.birdCountGageContainer addSubview:gauge];
    self.birdKindCountGauge = gauge;
    
    self.birdKindCountLabel.textColor = kHALTextColor;
    self.birdKindCountTitleLabel.textColor = kHALSubTextColor;
    
}

- (void)load
{
    int birdKindCount = [self.activityManager totalBirdKindCount];
    [self.birdKindCountGauge setValue:birdKindCount animated:YES];
    self.birdKindCountLabel.text = [NSString stringWithFormat:@"%d", birdKindCount];
}

@end
