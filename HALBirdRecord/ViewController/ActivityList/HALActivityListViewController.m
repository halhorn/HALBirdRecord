//
//  HALRecordListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityListViewController.h"
#import "HALActivityViewController.h"
#import "HALActivityManager.h"
#import "HALActivityListViewCell.h"
#import "UIViewController+HALViewControllerFromNib.h"

#define kHALDataOffset 1

@interface HALActivityListViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) HALActivityManager *activityManager;
@end

@implementation HALActivityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.activityManager = [HALActivityManager sharedManager];
        self.title = @"鳥ログ";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[HALActivityListViewCell nib]
         forCellReuseIdentifier:[HALActivityListViewCell cellIdentifier]];
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:[HALActivityManager updateActivityNotificationName]
                                               object:nil];
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
    if (indexPath.row < kHALDataOffset) {
        // トップ項目
        UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
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
        [self.activityManager deleteActivity:activity];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (indexPath.row < kHALDataOffset) {
        return 40;
    } else {
        return 68;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < kHALDataOffset) {
        [self showNewActivity];
        return;
    }
    HALActivity *activity = [self.activityManager activityWithIndex:indexPath.row - kHALDataOffset];
    HALActivityViewController *viewController = [[HALActivityViewController alloc] initWithActivity:activity shouldShowRegister:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
