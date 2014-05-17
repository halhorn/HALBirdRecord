//
//  HALStatisticsViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/15.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStatisticsViewController.h"
#import "HALStatisticsTableViewRenderer.h"
#import "HALBirdKind.h"
#import "HALBirdKindStatisticsViewController.h"

@interface HALStatisticsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) HALStatisticsTableViewRenderer *renderer;
@end

@implementation HALStatisticsViewController

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

    self.renderer = [[HALStatisticsTableViewRenderer alloc] init];
    self.title = @"これまでの記録";
    [self setupTableViewHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"Statistics"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupTableViewHeader
{
    NSArray *types = @[@"発見した鳥種", @"発見場所"];
    UISegmentedControl *segments = [[UISegmentedControl alloc] initWithItems:types];
    segments.segmentedControlStyle = UISegmentedControlStyleBar;
    segments.selectedSegmentIndex = 0;
    [segments addTarget:self action:@selector(onStatisticsTypeChanged:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableHeaderView = segments;
}

- (void)onStatisticsTypeChanged:(UISegmentedControl *)segmentControl
{
    int index = segmentControl.selectedSegmentIndex;
    HALStatisticsType type;
    switch (index) {
        case 0:
            type = HALStatisticsTypeBirdKind;
            [HALGAManager sendAction:@"Switch Statistics" label:@"BirdKind" value:0];
            break;
        case 1:
            type = HALStatisticsTypeCity;
            [HALGAManager sendAction:@"Switch Statistics" label:@"City" value:0];
            break;
            
        default:
            NSAssert(NO, @"Invalid Statistics Type");
            return;
    }
    self.renderer.statisticsType = type;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.renderer sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.renderer rowCountInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *data = [self.renderer rowDataAtIndexPath:indexPath];
    cell.textLabel.text = data[@"title"];
    cell.imageView.image = data[@"image"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.renderer headerForSection:section];
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
    
    if (self.renderer.statisticsType == HALStatisticsTypeBirdKind) {
        HALBirdKind *kind = [self.renderer rowDataAtIndexPath:indexPath][@"data"];
        HALBirdKindStatisticsViewController *viewController = [[HALBirdKindStatisticsViewController alloc] initWithBirdKind:kind];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
