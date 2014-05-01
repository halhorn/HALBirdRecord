//
//  HALEditBirdRecordViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/16.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALEditBirdRecordViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALMapManager.h"
#import "HALBirdPointAnnotation.h"
#import "HALActivityManager.h"
#import "UIViewController+HALCloseTextFieldKeyboard.h"

#define kHALTextFieldKeybordMargin 28

@interface HALEditBirdRecordViewController ()<MKMapViewDelegate>

@property(nonatomic) HALBirdRecord *birdRecord;
@property(nonatomic) HALActivity *activity;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *birdNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *birdImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datetimePicker;
@end

@implementation HALEditBirdRecordViewController

- (id)initWithBirdRecord:(HALBirdRecord *)birdRecord activity:(HALActivity *)activity
{
    self = [super initWithNib];
    if (self) {
        self.birdRecord = birdRecord;
        self.activity = activity;
        self.title = @"編集";
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
    self.birdNameLabel.text = self.birdRecord.kind.name;
    self.birdImageView.image = self.birdRecord.kind.image;
    self.datetimePicker.date = self.birdRecord.datetime;
    self.commentTextField.text = self.birdRecord.comment;
    self.titleBackgroundView.backgroundColor = kHALEditBirdRecordTitleBackgroundColor;
    self.datetimePicker.backgroundColor = kHALEditBirdRecordDatetimeBackgroundColor;
    
    HALMapManager *mapManager = [HALMapManager managerWithActivity:self.activity];
    self.mapView.region = [mapManager region];
    [self.mapView addAnnotation:[[HALBirdPointAnnotation alloc] initWithBirdRecord:self.birdRecord]];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(onLongPressMap:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    [self setGestureForClosingKeyBoardToView:self.view];
    [self setKeyBoardNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HALGAManager sendView:@"EditBirdRecord"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCommentEditEnd:(id)sender {
    self.birdRecord.comment = self.commentTextField.text;
    [self.birdRecord updateDB];
    [HALGAManager sendAction:@"Update BirdRecord Comment" label:self.birdRecord.comment value:0];
}

- (IBAction)onDatetimeChanged:(id)sender {
    self.birdRecord.datetime = self.datetimePicker.date;
    [self.birdRecord updateDB];
    [HALGAManager sendAction:@"Update BirdRecord Datetime" label:@"" value:0];
}

- (void)onLongPressMap:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {  // 長押し検出開始時のみ動作
        CGPoint touchedPoint = [gesture locationInView:self.mapView];
        self.birdRecord.coordinate = [self.mapView convertPoint:touchedPoint toCoordinateFromView:self.mapView];
        [self.birdRecord updateDB];
        [self.birdRecord updatePlacemarkAndDBAsync];
        [HALGAManager sendAction:@"Update BirdRecord Location" label:@"LongPress" value:0];

        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:[[HALBirdPointAnnotation alloc] initWithBirdRecord:self.birdRecord]];
    }
}

- (void)setKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark KeyBoardNotificationHandler

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect textFrame = self.commentTextField.frame;
    CGRect navFrame = self.navigationController.navigationBar.frame;
    
    double scrollY =  CGRectGetMaxY(navFrame) + CGRectGetMaxY(textFrame) - CGRectGetMinY(keyboardFrame) + kHALTextFieldKeybordMargin;
    if (scrollY > 0) {
        [self.scrollView setContentOffset:CGPointMake(0.0, scrollY) animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation{
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    if(pinAnnotationView == nil){
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
    }
    pinAnnotationView.draggable = YES;
    pinAnnotationView.animatesDrop = YES;
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {
        HALBirdPointAnnotation *annotation = view.annotation;
        self.birdRecord.coordinate = annotation.coordinate;
        [self.birdRecord updateDB];
        [self.birdRecord updatePlacemarkAndDBAsync];
        [HALGAManager sendAction:@"Update BirdRecord Location" label:@"Drag" value:0];
    }
}



@end
