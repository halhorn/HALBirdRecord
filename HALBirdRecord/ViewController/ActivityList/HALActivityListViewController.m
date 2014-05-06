//
//  HALRecordListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityListViewController.h"
#import "HALActivityViewController.h"
#import "HALStatisticsViewController.h"
#import "HALApplicationInfoViewController.h"
#import "HALPurchaseViewController.h"
#import "HALActivityManager.h"
#import "HALActivityListViewCell.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALStatisticsDigestViewCell.h"
#import "HALNewActivityCell.h"
#import "HALAccount.h"
#import "NSNotificationCenter+HALDataUpdateNotification.h"

#define kHALDataOffset 2
#define kHALChannelSurveyKey @"HALChannelSurveyKey"

@interface HALActivityListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *explainView;

@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) BOOL reloadViewFlag;
@property(nonatomic) HALStatisticsDigestViewCell *statisticsViewCell;
@property(nonatomic) HALNewActivityCell *createActivityViewCell;
@end

@implementation HALActivityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.activityManager = [HALActivityManager sharedManager];
        self.title = @"鳥ログ";
        self.reloadViewFlag = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[HALActivityListViewCell nib]
         forCellReuseIdentifier:[HALActivityListViewCell cellIdentifier]];
    [self.tableView registerNib:[HALStatisticsDigestViewCell nib]
         forCellReuseIdentifier:[HALStatisticsDigestViewCell cellIdentifier]];
    [self.tableView registerNib:[HALNewActivityCell nib]
         forCellReuseIdentifier:[HALNewActivityCell cellIdentifier]];
    
    [self setupExplainView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(onTapInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

    [[NSNotificationCenter defaultCenter] addDataUpdateObserver:self selector:@selector(reloadViews)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HALGAManager sendView:@"Activity List"];
    [self showChannelSurvey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNewActivity
{
    // アクティビティ数チェック
    if (![[HALAccount myAccount] isUnlimitedAccount] && self.activityManager.activityCount >= [self.activityManager activityCapacity]) {
        WeakSelf weakSelf = self;
        [UIAlertView bk_showAlertViewWithTitle:@"アクティビティが満杯です" message:@"ショップで保存できるアクティビティの数を増やして下さい。" cancelButtonTitle:@"キャンセル" otherButtonTitles:@[@"ショップ"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            if (buttonIndex != alertView.cancelButtonIndex) {
                [weakSelf goToShop];
            }
        }];
        return;
    }
    
    HALActivity *activity = [[HALActivity alloc] init];
    activity.title = @"新規アクティビティ";
    
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showChannelSurvey
{
    NSNumber *hasShownSurvey = [[NSUserDefaults standardUserDefaults] objectForKey:kHALChannelSurveyKey];

    if (hasShownSurvey) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:kHALChannelSurveyKey];
    NSArray *questions = @[
                           @"探鳥会等で",
                           @"知人から",
                           @"AppStoreで検索",
                           @"WEBで検索",
                           @"SNSで",
                           @"その他",
                           ];
    [UIAlertView bk_showAlertViewWithTitle:@"アンケート"
                                   message:@"鳥ログをご利用頂きありがとうございます。よろしければ鳥ログを知ったきっかけを教えて下さい。"
                         cancelButtonTitle:@"答えない"
                         otherButtonTitles:questions
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex){
                                       if (buttonIndex != alertView.cancelButtonIndex) {
                                           [HALGAManager sendAction:@"Channel Survey" label:questions[buttonIndex-1] value:0];
                                       } else {
                                           [HALGAManager sendAction:@"Channel Survey" label:@"No Answer" value:0];
                                       }
                                   }];
}

- (void)goToShop
{
    [self.navigationController pushViewController:[HALPurchaseViewController viewControllerFromNib]
                                         animated:YES];
}

- (void)setupExplainView
{
    if (!self.activityManager.activityCount) {
        self.explainView.layer.cornerRadius = 10;
        self.explainView.layer.masksToBounds = YES;
        self.explainView.backgroundColor = kHALActivityListStatisticsBackgroundColor;
        self.explainView.hidden = NO;
    } else {
        self.explainView.hidden = YES;
    }
}

- (void)reloadViews
{
    if (self.reloadViewFlag) {
        [self.tableView reloadData];
        [self setupExplainView];
    }
}

- (void)onTapInfoButton:(id)sender
{
    HALApplicationInfoViewController *viewController = [[HALApplicationInfoViewController alloc] initWithNib];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.activityManager activityCount] + kHALDataOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (indexPath.row == 0) {
        // 統計
        self.statisticsViewCell = [tableView dequeueReusableCellWithIdentifier:[HALStatisticsDigestViewCell cellIdentifier]];
        [self.statisticsViewCell load];
        return self.statisticsViewCell;
    }
    if (indexPath.row == 1) {
        // 新規アクティビティ
        self.createActivityViewCell = [tableView dequeueReusableCellWithIdentifier:[HALNewActivityCell cellIdentifier]];
        WeakSelf weakSelf = self;
        [self.createActivityViewCell loadWithTapPurchaseBlock:^{
            [weakSelf goToShop];
        }];
        return self.createActivityViewCell;
    } else {
        HALActivityListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HALActivityListViewCell cellIdentifier]];
        
        HALActivity *activity = [self.activityManager activityWithIndex:indexPath.row - kHALDataOffset];
        [cell setupUIWithActivity:activity];
        return cell;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return indexPath.row >= kHALDataOffset;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        HALActivity *activity = [self.activityManager activityWithIndex:indexPath.row - kHALDataOffset];
        [HALGAManager sendAction:@"Delete Activity" label:activity.title value:activity.birdRecordList.count];
        self.reloadViewFlag = NO;
        [self.activityManager deleteActivity:activity];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.reloadViewFlag = YES;
        
        [self setupExplainView];
        [self.statisticsViewCell load];
        [self.createActivityViewCell load];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    } else if (indexPath.row == 1) {
        return 40;
    } else {
        return 68;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 統計
        HALStatisticsViewController *viewController = [HALStatisticsViewController viewControllerFromNib];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    } else if (indexPath.row == 1) {
        [self showNewActivity];
        return;
    }
    HALActivity *activity = [self.activityManager activityWithIndex:indexPath.row - kHALDataOffset];
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
