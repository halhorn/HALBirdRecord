//
//  HALFlatBirdKindListTableViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALFlatBirdKindListTableViewController.h"
#import "HALBirdKindListViewController.h"
#import "HALFamilyBirdKindList.h"
#import "HALBirdKind.h"
#import "HALSearchedBirdKindList.h"
#import "HALBirdRecord.h"
#import "HALActivity.h"
#import "HALWebViewController.h"

@interface HALFlatBirdKindListTableViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

@property(nonatomic) HALBirdKindListBase *birdKindList;
@property(nonatomic) HALSearchedBirdKindList *searchedBirdKindList;
@property(nonatomic) NSMutableArray *birdRecordList;

@end

@implementation HALFlatBirdKindListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)setSearchWord:(NSString *)searchWord
{
    [self.searchedBirdKindList setSearchWord:searchWord];
    [self.tableView reloadData];
}

- (void)setup
{
    self.birdKindList = [HALFamilyBirdKindList sharedBirdKindList];
    self.searchedBirdKindList = [[HALSearchedBirdKindList alloc] init];
    self.birdRecordList = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HALBirdRecord *)birdRecordWithBirdID:(int)birdID
{
    for (HALBirdRecord *record in self.birdRecordList) {
        if (record.birdID == birdID) {
            return record;
        }
    }
    return nil;
}

- (void)imageViewTouched:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    HALBirdKind *birdKind = [self birdKindFromIndexPath:indexPath];
    HALWebViewController *webViewCotroller = [[HALWebViewController alloc] initWithURL:birdKind.url title:birdKind.name];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewCotroller];
    [self.birdKindListViewController presentViewController:navController animated:YES completion:nil];
}

- (HALBirdKind *)birdKindFromIndexPath:(NSIndexPath *)indexPath
{
    NSArray *source;
    if ([self.searchedBirdKindList isSearchWordSet]) {
        source = [self.searchedBirdKindList searchedBirdKindList];
    } else {
        source = self.birdKindList.birdKindList;
    }
    return source[indexPath.section][indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.searchedBirdKindList isSearchWordSet] ?
    [self.searchedBirdKindList searchedBirdKindList].count:
    [self.birdKindList numberOfGroups];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *group;
    if ([self.searchedBirdKindList isSearchWordSet]) {
        group = self.searchedBirdKindList.searchedBirdKindList[section];
    } else {
        group = self.birdKindList.birdKindList[section];
    }
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = kHALTextColor;
        cell.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(imageViewTouched:)];
        [cell.imageView addGestureRecognizer:tap];
    }
    
    // Configure the cell...
    HALBirdKind *birdKind = [self birdKindFromIndexPath:indexPath];
    cell.textLabel.text = birdKind.name;
    cell.accessoryType = [self birdRecordWithBirdID:birdKind.birdID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.imageView.image = birdKind.image;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.searchedBirdKindList isSearchWordSet]) {
        return [self.searchedBirdKindList sectionNameAtIndex:(int)section];
    } else {
        return [self.birdKindList groupNameForGroupIndex:(int)section];
    }
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
    HALBirdKind *birdKind = [self birdKindFromIndexPath:indexPath];
    HALBirdRecord *record = [self birdRecordWithBirdID:birdKind.birdID];
    if (!record) {
        [HALGAManager sendAction:@"Select Bird (Select with Search)"
                           label:birdKind.name
                           value:[self.searchedBirdKindList isSearchWordSet] ? 1 : 0];
        HALBirdRecord *record = [[HALBirdRecord alloc] initWithBirdID:birdKind.birdID];
        [record setCurrentLocationAndPlacemarkAndUpdateDBAsync];
        [self.birdRecordList addObject:record];
        [self.birdKindListViewController onTapBirdRow];
        [tableView reloadData];
    } else {
        WeakSelf weakSelf = self;
        NSString *message = [NSString stringWithFormat:@"%@を追加リストから削除しますか？", birdKind.name];
        [UIAlertView bk_showAlertViewWithTitle:@"取り消し" message:message cancelButtonTitle:@"いいえ" otherButtonTitles:@[@"はい"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            if (buttonIndex != alertView.cancelButtonIndex) {
                [weakSelf.birdRecordList removeObject:record];
                [weakSelf.birdKindListViewController onTapBirdRow];
                [tableView reloadData];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.birdKindListViewController.view endEditing:YES];
}

#pragma mark - HALBirdRecordViewDelegate

- (NSArray *)sendBirdList
{
    return [NSArray arrayWithArray:self.birdRecordList];
}

@end
