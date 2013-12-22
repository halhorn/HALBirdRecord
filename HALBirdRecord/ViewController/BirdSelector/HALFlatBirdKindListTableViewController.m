//
//  HALFlatBirdKindListTableViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALFlatBirdKindListTableViewController.h"
#import "HALFamilyBirdKindList.h"
#import "HALBirdKind.h"
#import "HALBirdRecord.h"
#import "HALActivity.h"

@interface HALFlatBirdKindListTableViewController ()

@property(nonatomic) HALBirdKindList *birdKindList;
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

- (void)setup
{
    self.birdKindList = [HALFamilyBirdKindList sharedBirdKindList];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.birdKindList numberOfGroups];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *birdGroup = self.birdKindList.birdKindList[section];
    return birdGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *birdGroup = self.birdKindList.birdKindList[indexPath.section];
    HALBirdKind *birdKind =birdGroup[indexPath.row];
    cell.textLabel.text = birdKind.name;
    cell.accessoryType = [self birdRecordWithBirdID:birdKind.birdID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.birdKindList groupNameForGroupIndex:section];
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
    HALBirdKind *birdKind = self.birdKindList.birdKindList[indexPath.section][indexPath.row];
    HALBirdRecord *record = [self birdRecordWithBirdID:birdKind.birdID];
    if (!record) {
        HALBirdRecord *record = [[HALBirdRecord alloc] initWithBirdID:birdKind.birdID];
        [self.birdRecordList addObject:record];
    } else {
        [self.birdRecordList removeObject:record];
    }
    [tableView reloadData];
}

#pragma mark - HALBirdRecordViewDelegate

- (NSArray *)sendBirdList
{
    return [NSArray arrayWithArray:self.birdRecordList];
}

@end
