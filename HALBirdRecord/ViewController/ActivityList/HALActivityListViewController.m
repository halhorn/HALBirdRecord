//
//  HALRecordListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityListViewController.h"
#import "HALActivityViewController.h"
#import "HALApplicationInfoViewController.h"
#import "HALActivityManager.h"
#import "HALActivityListViewCell.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALStatisticsViewCell.h"

#define kHALDataOffset 2
#define kHALMaxActivityNum 20

@interface HALActivityListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *explainView;

@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) BOOL reloadViewFlag;
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
    [self.tableView registerNib:[HALStatisticsViewCell nib]
         forCellReuseIdentifier:[HALStatisticsViewCell cellIdentifier]];
    
    [self setupExplainView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(onTapInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadViews)
                                                 name:[HALActivityManager updateActivityNotificationName]
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HALGAManager sendView:@"Activity List"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNewActivity
{
    if (self.activityManager.activityCount >= kHALMaxActivityNum) {
        [UIAlertView showAlertViewWithTitle:nil message:@"アクティビティ数が上限に達しました。新しいアクティビティを追加するには、古いアクティビティを削除してください。（アクティビティを右から左にスワイプすると削除できます。）" cancelButtonTitle:@"OK" otherButtonTitles:@[] handler:nil];
        return;
    }
    
    HALActivity *activity = [[HALActivity alloc] init];
    activity.title = @"新規アクティビティ";
    
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:YES];
    [self.navigationController pushViewController:viewController animated:YES];
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
        HALStatisticsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HALStatisticsViewCell cellIdentifier]];
        [cell load];
        return cell;
    }
    if (indexPath.row == 1) {
        // 新規アクティビティ
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
        cell.textLabel.textColor = kHALTextColor;
        cell.textLabel.text = @"＋新しいアクティビティ";
        return cell;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // row:0 統計情報ページを作るまでは選択不可に
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
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
