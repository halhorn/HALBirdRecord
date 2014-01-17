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

@interface HALEditBirdRecordViewController ()

@property(nonatomic) HALBirdRecord *birdRecord;
@property(nonatomic) HALActivity *activity;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *birdNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *birdImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ii";
    self.dateTimeLabel.text = [dateFormatter stringFromDate:self.birdRecord.datetime];
    self.commentTextField.text = self.birdRecord.comment;
    
    HALMapManager *mapManager = [HALMapManager managerWithActivity:self.activity];
    self.mapView.region = [mapManager region];
    [self.mapView addAnnotation:[[HALBirdPointAnnotation alloc] initWithBirdRecord:self.birdRecord]];
    [self setGestureForClosingKeyBoardToView:self.view];
    [self setKeyBoardNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTapSaveButton:(id)sender {
    self.birdRecord.comment = self.commentTextField.text;
    [self.birdRecord updateDB];
    [SVProgressHUD showSuccessWithStatus:@"保存しました"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTapDeleteButton:(id)sender {
    WeakSelf weakSelf = self;
    [UIAlertView showAlertViewWithTitle:@"削除" message:@"本当に削除してもよろしいですか" cancelButtonTitle:@"いいえ" otherButtonTitles:@[@"はい"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
        if (buttonIndex != alertView.cancelButtonIndex) {
            [weakSelf.activity.birdRecordList removeObject:weakSelf.birdRecord];
            HALActivityManager *activityManager = [HALActivityManager sharedManager];
            [activityManager saveActivity:weakSelf.activity];
            [SVProgressHUD showSuccessWithStatus:@"削除しました"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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

@end
