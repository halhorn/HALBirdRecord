//
//  HALRecordListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityListViewController.h"
#import "HALActivityListTableViewController.h"
#import "HALBirdKindListViewController.h"
#import "HALActivityViewController.h"
#import "HALActivityManager.h"
#import "UIViewController+HALViewControllerFromNib.h"

@interface HALActivityListViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *activityRecordView;

@property(nonatomic) HALActivityManager *activityManager;
@property(nonatomic) HALActivityListTableViewController *activityRecordTableViewController;
@end

@implementation HALActivityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.activityManager = [HALActivityManager sharedManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activityRecordTableViewController = [HALActivityListTableViewController viewControllerFromNib];
    self.activityRecordTableViewController.tableView.delegate = self;
    [self.activityRecordView addSubview:self.activityRecordTableViewController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.activityManager loadActivityList];
    [self.activityRecordTableViewController.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNewActivity
{
    HALActivity *activity = [[HALActivity alloc] init];
    activity.title = @"新規アクティビティ";
    
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int dataOffset = self.activityRecordTableViewController.dataOffset;

    if (indexPath.row < dataOffset) {
        [self showNewActivity];
        return;
    }
    HALActivity *activity = self.activityManager.activityList[indexPath.row - dataOffset];
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
