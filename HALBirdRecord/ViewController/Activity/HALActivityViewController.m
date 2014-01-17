//
//  HALActivityViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/13.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityViewController.h"
#import "HALActivityManager.h"
#import "HALBirdRecordTableViewCell.h"
#import "HALBirdMapViewController.h"
#import "HALBirdKindListViewController.h"
#import "HALBirdPointAnnotation.h"
#import "HALMapManager.h"
#import "HALWebViewController.h"
#import "HALEditBirdRecordViewController.h"
#import "UIViewController+HALCloseTextFieldKeyboard.h"
#import <MapKit/MapKit.h>
#import <SZTextView/SZTextView.h>

@interface HALActivityViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet SZTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITableView *birdRecordTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) HALActivity *activity;
@property(nonatomic) NSDateFormatter *dateFormatter;
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
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
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
    
    [self.birdRecordTableView registerNib:[HALBirdRecordTableViewCell nib]
                   forCellReuseIdentifier:[HALBirdRecordTableViewCell cellIdentifier]];

    // 新規アクティビティの場合
    if (self.shouldShowRegister) {
        WeakSelf weakSelf = self;
        [self performBlock:^(id sender){
            [HALGAManager sendAction:@"Open Bird Selector" label:@"New Activity" value:0];
            [weakSelf showBirdSelectorView];
        } afterDelay:0.1];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.birdRecordTableView reloadData];
    [self loadMapView];
    [HALGAManager sendView:@"Activity"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods

- (void)setupUI
{
    self.titleTextField.text = self.activity.title;
    self.commentTextView.text = self.activity.comment;
    self.titleTextField.textColor = kHALTextColor;
    self.titleTextField.backgroundColor = kHALActivityTitleBackgroundColor;
    self.commentTextView.textColor = kHALSubTextColor;
    self.commentTextView.backgroundColor = kHALActivityCommentBackgroundColor;
    self.commentTextView.placeholder = @"コメントを入力";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追加"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapAddButton:)];
}

- (void)loadMapView
{
    HALMapManager *mapManager = [HALMapManager managerWithActivity:self.activity];
    self.mapView.region = [mapManager region];
    self.mapView.delegate = self;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[mapManager annotationList]];
}

#pragma mark - other methods

- (void)showBirdSelectorView
{
    WeakSelf weakSelf = self;
    HALBirdKindListViewController *viewController = [[HALBirdKindListViewController alloc] initWithCompletion:^(NSArray *birdRecordList){
        [HALGAManager sendAction:@"Add and Save Bird Record (count)"
                           label:[NSString stringWithFormat:@"%lu", (unsigned long)birdRecordList.count]
                           value:birdRecordList.count];
        [SVProgressHUD showSuccessWithStatus:@"追加しました"];
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

- (void)imageViewTouched:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.birdRecordTableView];
    NSIndexPath *indexPath = [self.birdRecordTableView indexPathForRowAtPoint:point];
    HALBirdKind *birdKind = ((HALBirdRecord *)self.activity.birdRecordList[indexPath.row]).kind;
    HALWebViewController *webViewCotroller = [[HALWebViewController alloc] initWithURL:birdKind.url title:birdKind.name];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewCotroller];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - event handler

- (void)onTapAddButton:(id)sender
{
    [HALGAManager sendAction:@"Open Bird Selector" label:@"Existing Activity" value:0];
    [self showBirdSelectorView];
}

- (IBAction)onTitleEditDone:(id)sender {
    [HALGAManager sendAction:@"Edit Activity Title" label:self.titleTextField.text value:0];
    self.activity.title = self.titleTextField.text;
    self.title = self.activity.title;
    [self.activityManager saveActivity:self.activity];
}

- (IBAction)onTapMap:(id)sender {
    [self.view endEditing:YES];
    HALBirdMapViewController *viewController = [[HALBirdMapViewController alloc] initWithActivity:self.activity];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [HALGAManager sendAction:@"Edit Activity Comment" label:self.commentTextView.text value:0];
    self.activity.comment = self.commentTextView.text;
    [self.activityManager saveActivity:self.activity];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activity.birdRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HALBirdRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HALBirdRecordTableViewCell cellIdentifier]];
    if (![cell.birdImageView.gestureRecognizers count]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(imageViewTouched:)];
        [cell.birdImageView addGestureRecognizer:tap];
    }
    
    HALBirdRecord *birdRecord = self.activity.birdRecordList[indexPath.row];
    [cell setupView:birdRecord];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HALBirdRecord *deletingRecord = self.activity.birdRecordList[indexPath.row];
        [HALGAManager sendAction:@"Delete Bird Record" label:deletingRecord.kind.name value:0];

        // Delete the row from the data source
        [self.activity.birdRecordList removeObjectAtIndex:indexPath.row];
        [[HALActivityManager sharedManager] saveActivity:self.activity];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self loadMapView];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - UITableViewDelegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    HALBirdRecord *birdRecord = self.activity.birdRecordList[indexPath.row];
    HALEditBirdRecordViewController *viewController = [[HALEditBirdRecordViewController alloc] initWithBirdRecord:birdRecord activity:self.activity];
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation{
    HALBirdPointAnnotation *birdPointAnnotation = annotation;
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    if(pinAnnotationView == nil){
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
    }
    pinAnnotationView.pinColor = birdPointAnnotation.birdRecord == self.selectedBirdRecord ? MKPinAnnotationColorGreen :MKPinAnnotationColorRed;
    return pinAnnotationView;
}
*/
@end
