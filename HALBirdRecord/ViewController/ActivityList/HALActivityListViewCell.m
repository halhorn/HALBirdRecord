//
//  HALActivityListViewCell.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityListViewCell.h"
#import "HALBirdPointAnnotation.h"
#import "HALMapManager.h"
#import <MapKit/MapKit.h>

@interface HALActivityListViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *birdCountContainerView;
@property (weak, nonatomic) IBOutlet UILabel *birdCountLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) HALActivity *activity;

@end

@implementation HALActivityListViewCell

static NSDateFormatter *dateFormatter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (NSString *)cellIdentifier
{
    return @"HALActivityListViewCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"HALActivityListViewCell" bundle:nil];
}

- (void)setupUIWithActivity:(HALActivity *)activity
{
    self.activity = activity;
    self.titleLabel.text = activity.title;
    self.commentLabel.text = activity.comment;
    self.birdCountContainerView.layer.cornerRadius = 10;
    self.birdCountContainerView.clipsToBounds = YES;
    self.birdCountLabel.text = [NSString stringWithFormat:@"%d", activity.birdRecordList.count];
    self.dateLabel.text = [self dateLabelText];

    HALMapManager *mapManager = [HALMapManager managerWithActivity:activity];
    self.mapView.region = [mapManager vastRegion];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[mapManager averagePointAnnotation]];
}

- (NSString *)dateLabelText
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/MM/dd";
    }
    int birdCount = self.activity.birdRecordList.count;
    if (!birdCount) {
        return @"";
    }
    NSString *firstDateString = [dateFormatter stringFromDate:((HALBirdRecord *)self.activity.birdRecordList[0]).datetime];
    NSString *lastDateString = [dateFormatter stringFromDate:((HALBirdRecord *)self.activity.birdRecordList[birdCount - 1]).datetime];
    return ([firstDateString isEqualToString:lastDateString]) ? firstDateString : [NSString stringWithFormat:@"%@ - %@", firstDateString, lastDateString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
