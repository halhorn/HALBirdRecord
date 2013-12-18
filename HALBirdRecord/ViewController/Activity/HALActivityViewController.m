//
//  HALActivityViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/13.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityViewController.h"
#import "HALActivityTableViewController.h"
#import "HALActivityManager.h"
#import "HALBirdMapViewController.h"
#import "HALBirdKindListViewController.h"
#import "HALBirdPointAnnotation.h"
#import <MapKit/MapKit.h>

@interface HALActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeAndLocationLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *activityTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) HALActivity *activity;
@property(nonatomic) HALActivityTableViewController *activityTableViewController;
@property(nonatomic, assign) BOOL shouldShowRegister;

@end

@implementation HALActivityViewController

- (id)initWithActivity:(HALActivity *)activity shouldShowRegister:(BOOL)shouldShowRegister
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.activity = activity;
        self.title = activity.title;
        self.shouldShowRegister = shouldShowRegister;
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
    
    // 新規アクティビティの場合
    if (self.shouldShowRegister) {
        [self showBirdSelectorView];
    }
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
    self.commentTextView.text = self.activity.comment;
    [self setupTimeAndLocationLabel];
    self.mapView.region = [self.activity getRegion];
    [self.mapView addAnnotations:[HALBirdPointAnnotation annotationListWithActivity:self.activity]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追加"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapAddButton:)];
}

- (void)setupTimeAndLocationLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd";
    NSString *timeAndLocation = [dateFormatter stringFromDate:self.activity.datetime];
    if (self.activity.location != nil && ![self.activity.location isEqualToString:@""]) {
        timeAndLocation = [NSString stringWithFormat:@"%@ @ %@", timeAndLocation, self.activity.location];
    }
    self.timeAndLocationLabel.text = timeAndLocation;
}

- (void)showBirdSelectorView
{
    WeakSelf weakSelf = self;
    HALBirdKindListViewController *viewController = [[HALBirdKindListViewController alloc] initWithCompletion:^(NSArray *birdRecordList){
        [weakSelf addAndSaveBirdRecordList:birdRecordList];
    }];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)addAndSaveBirdRecordList:(NSArray *)birdRecordList
{
    [self.activity addBirdRecordList:birdRecordList];
    [[HALActivityManager sharedManager] saveActivity:self.activity];
}

- (void)onTapAddButton:(id)sender
{
    [self showBirdSelectorView];
}

- (IBAction)onTapMap:(id)sender {
    HALBirdMapViewController *viewController = [[HALBirdMapViewController alloc] initWithActivity:self.activity];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
