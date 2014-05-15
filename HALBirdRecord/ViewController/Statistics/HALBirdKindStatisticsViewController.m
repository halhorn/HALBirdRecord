//
//  HALBirdKindStatisticsViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/14.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALBirdKindStatisticsViewController.h"
#import "HALStatistics.h"
#import "HALMapManager.h"
#import <MapKit/MapKit.h>

@interface HALBirdKindStatisticsViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) HALBirdKind *birdKind;
@property (nonatomic) NSArray *birdRecordList;

@end

@implementation HALBirdKindStatisticsViewController

- (HALBirdKindStatisticsViewController *)initWithBirdKind:(HALBirdKind *)birdKind
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.birdKind = birdKind;
        self.birdRecordList = [[HALStatistics sharedModel] birdRecordWithBirdID:birdKind.birdID];
        self.title = birdKind.name;
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
    
    [self loadMapView];
}

- (void)loadMapView
{
    HALMapManager *mapManager = [HALMapManager managerWithBirdRecordList:self.birdRecordList];
    self.mapView.region = [mapManager region];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[mapManager annotationList]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
