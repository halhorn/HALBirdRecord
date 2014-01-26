//
//  HALPurchaseViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/26.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALPurchaseViewController.h"
#import "HALActivityManager.h"
#import "HALProductManager.h"
#import "HALPurchaseViewCell.h"

@interface HALPurchaseViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *activityCountLabel;

@end

@implementation HALPurchaseViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"機能拡張";
    self.headerView.backgroundColor = kHALPurchaseHeaderBackgroundColor;
    HALActivityManager *activityManager = [HALActivityManager sharedManager];
    int capacity = [activityManager activityCapacity];
    if (capacity == 0) {
        self.activityCountLabel.text = [NSString stringWithFormat:@"(%d/∞)", activityManager.activityCount];
    } else {
        self.activityCountLabel.text = [NSString stringWithFormat:@"(%d/%d)", activityManager.activityCount, activityManager.activityCapacity];
    }
    self.tableView.tableHeaderView = self.headerView;

    [self.tableView registerNib:[HALPurchaseViewCell nib]
         forCellReuseIdentifier:[HALPurchaseViewCell cellIdentifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 0;
    } else {
        return [HALProduct purchaseProductIDList].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HALPurchaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HALPurchaseViewCell cellIdentifier]];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        // フリー
    } else {
        // 課金
         [cell loadWithProductID:[HALProduct purchaseProductIDList][indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SVProgressHUD show];
    if (indexPath.section == 1) {
        NSString *productID = [HALProduct purchaseProductIDList][indexPath.row];
        [[HALProductManager sharedManager] purchaseProduct:productID withCompletion:^(BOOL success){
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"購入しました。"];
                [[HALActivityManager sharedManager] notifyActivityUpdate];
            } else {
                [SVProgressHUD showErrorWithStatus:@"購入できませんでした。"];
            }
        }];
    }
}

@end
