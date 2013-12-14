//
//  HALBirdMapViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/14.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdMapViewController.h"
#import "HALBirdPointAnnotation.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import <MapKit/MapKit.h>

@interface HALBirdMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) HALActivity *activity;

@end

@implementation HALBirdMapViewController

- (id)initWithActivity:(HALActivity *)activity
{
    self = [super initWithNib];
    if (self) {
        self.activity = activity;
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
    self.mapView.region = [self.activity getRegion];
    [self.mapView addAnnotations:[HALBirdPointAnnotation annotationListWithActivity:self.activity]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
