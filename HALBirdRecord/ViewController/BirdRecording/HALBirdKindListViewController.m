//
//  HALBirdKindListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindListViewController.h"
#import "HALFlatBirdKindListTableViewController.h"
#import "HALSaveActivityViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALDB.h"

@interface HALBirdKindListViewController ()
@property (weak, nonatomic) IBOutlet UIView *BirdListView;

@property(nonatomic) UIViewController<HALBirdRecordViewDelegate> *birdListViewController;

@end

@implementation HALBirdKindListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"野鳥リスト";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.birdListViewController = [HALFlatBirdKindListTableViewController viewControllerFromNib];
    [self.BirdListView addSubview:self.birdListViewController.view];

    [self setCancelButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapSaveButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBirdRecord:(HALBirdRecord *)birdRecord
{
    HALSaveActivityViewController *viewController = [[HALSaveActivityViewController alloc] initWithBirdRecord:birdRecord completion:^(HALActivityRecordEntity *activityRecordEntity){
        birdRecord.activityRecord = activityRecordEntity;
        [birdRecord save];
        [[[HALDB alloc] init] showRecordInTable:@"ActivityRecord"];
        [[[HALDB alloc] init] showRecordInTable:@"BirdRecord"];
    }];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UIEventHandler

- (void)onTapSaveButton:(id)sender
{
    HALBirdRecord *record = [self.birdListViewController sendBirdRecord];
    if (record.birdRecordList.count) {
        [self saveBirdRecord:record];
    } else {
        WeakSelf weakSelf = self;
        [UIAlertView showAlertViewWithTitle:@"鳥さんはどこ？" message:@"鳥が一羽もいないアクティビティを保存しますか？" cancelButtonTitle:@"戻る" otherButtonTitles:@[@"保存"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            if (buttonIndex == alertView.cancelButtonIndex) {
                return;
            }
            [weakSelf saveBirdRecord:record];
        }];
    }
}

@end
