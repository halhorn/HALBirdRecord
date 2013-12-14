//
//  HALActivityViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/13.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityViewController.h"
#import "HALActivityTableViewController.h"
#import "HALBirdPointAnnotation.h"
#import <MapKit/MapKit.h>

@interface HALActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeAndLocationLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *activityTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) HALActivity *activity;
@property(nonatomic) HALActivityTableViewController *activityTableViewController;

@end

@implementation HALActivityViewController

- (id)initWithActivity:(HALActivity *)activity
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.activity = activity;
        self.title = activity.title;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    self.activityTableViewController = [[HALActivityTableViewController alloc] initWithActivity:self.activity];
    [self.activityTableView addSubview:self.activityTableViewController.view];
    [self setupTimeAndLocationLabel];
    self.commentTextView.text = self.activity.comment;
    self.mapView.region = [self.activity getRegion];
    [self.mapView addAnnotations:[HALBirdPointAnnotation annotationListWithActivity:self.activity]];
}

- (void)setupTimeAndLocationLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd";
    NSString *timeAndLocation = [dateFormatter stringFromDate:self.activity.datetime];
    if (![self.activity.location isEqualToString:@""]) {
        timeAndLocation = [NSString stringWithFormat:@"%@ @ %@", timeAndLocation, self.activity.location];
    }
    self.timeAndLocationLabel.text = timeAndLocation;
}

@end
