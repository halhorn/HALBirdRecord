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

@interface HALActivityViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *activityTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) HALActivity *activity;
@property(nonatomic) HALActivityTableViewController *activityTableViewController;
@property(nonatomic, assign) BOOL shouldShowRegister;

@end

@implementation HALActivityViewController

- (id)initWithActivity:(HALActivity *)activity shouldShowRegister:(BOOL)shouldShowRegister
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.activityManager = [HALActivityManager sharedManager];
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
        WeakSelf weakSelf = self;
        [self performBlock:^(id sender){
            [weakSelf showBirdSelectorView];
        } afterDelay:0.1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activityTableViewController.tableView reloadData];
    [self loadMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods

- (void)setupUI
{
    self.activityTableViewController = [[HALActivityTableViewController alloc] initWithActivity:self.activity];
    [self.activityTableView addSubview:self.activityTableViewController.view];
    self.titleTextField.text = self.activity.title;
    self.commentTextView.text = self.activity.comment;
    [self setGestureForClosingKeyBoard];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追加"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapAddButton:)];
}

- (void)loadMapView
{
    self.mapView.region = [self.activity getRegion];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[HALBirdPointAnnotation annotationListWithActivity:self.activity]];
}

- (void)setGestureForClosingKeyBoard {
    WeakSelf weakSelf = self;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
        [weakSelf.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark - other methods

- (void)showBirdSelectorView
{
    WeakSelf weakSelf = self;
    HALBirdKindListViewController *viewController = [[HALBirdKindListViewController alloc] initWithCompletion:^(NSArray *birdRecordList){
        [weakSelf addAndSaveBirdRecordList:birdRecordList];
    }];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)addAndSaveBirdRecordList:(NSArray *)birdRecordList
{
    [self.activity addBirdRecordList:birdRecordList];
    [self.activityManager saveActivity:self.activity];
}

#pragma mark - event handler

- (void)onTapAddButton:(id)sender
{
    [self showBirdSelectorView];
}

- (IBAction)onTitleEditDone:(id)sender {
    self.activity.title = self.titleTextField.text;
    self.title = self.activity.title;
    [self.activityManager saveActivity:self.activity];
}

- (IBAction)onTapMap:(id)sender {
    HALBirdMapViewController *viewController = [[HALBirdMapViewController alloc] initWithActivity:self.activity];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.activity.comment = self.commentTextView.text;
    [self.activityManager saveActivity:self.activity];
    return YES;
}
@end
