//
//  HALApplicationInfoViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/05.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALApplicationInfoViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "UIViewController+HALSetCancelButton.h"
#import "NSString+HALURLEncode.h"
#import "MessageUI/MessageUI.h"
#import "MessageUI/MFMailComposeViewController.h"
#import <BlocksKit+MessageUI.h>
#import "HALDataExporter.h"
#import "HALActivityManager.h"
#import "HALProductManager.h"

// views
#import "HALLicenseViewController.h"
#import "HALHelpListViewController.h"
#import "HALPurchaseViewController.h"
#import "HALAuthorInfoViewController.h"

#define kHALContactUsMail @"halhorn@halmidi.com"
#define kHALInfoSectionNo 0

@interface HALApplicationInfoViewController ()

@property(nonatomic) NSArray *sectionNames;
@property(nonatomic) NSArray *views;

@end

@implementation HALApplicationInfoViewController

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

    self.title = @"Info";
    
    self.sectionNames = @[@"アプリについて", @"ショップ", @"その他"];
    self.views =
    @[
      @[
          @{@"title": @"ヘルプ／使い方", @"view": [HALHelpListViewController viewControllerFromNib]},
          @{@"title": @"お問い合わせ", @"selector": @"openContactUsMail"},
        ],
      @[
          @{@"title": @"ショップ", @"view": [HALPurchaseViewController viewControllerFromNib]},
          @{@"title": @"購入情報のリストア", @"selector": @"restoreProducts"},
          ],
      @[
          @{@"title": @"CSVデータをメールでエクスポート", @"selector": @"openExportDataMail"},
          @{@"title": @"ライセンス", @"view": [HALLicenseViewController viewControllerFromNib]},
          @{@"title": @"作者・協力者", @"view": [HALAuthorInfoViewController viewControllerFromNib]}
          ],
      ];

    [self setCancelButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"ApplicationInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openContactUsMail
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UIDevice *device = [UIDevice currentDevice];
    NSString *appInfo = [NSString stringWithFormat:@"AppVer:%@ / %@@%@%@",
                         appVersion,
                         device.model,
                         device.systemName,
                         device.systemVersion];
    NSString *urlString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@%@",
                           kHALContactUsMail,
                           [@"鳥ログ：問い合わせ " urlEncodedString],
                           [appInfo urlEncodedString]];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)restoreProducts
{
    [UIAlertView bk_showAlertViewWithTitle:@"リストア" message:@"購入情報をリストアしますか？" cancelButtonTitle:@"キャンセル" otherButtonTitles:@[@"OK"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
        if (buttonIndex != alertView.cancelButtonIndex) {
            HALProductManager *productManager = [HALProductManager sharedManager];
            [productManager restoreProductList];
            [[HALActivityManager sharedManager] notifyActivityUpdate];
            [SVProgressHUD showSuccessWithStatus:@"リストアしました"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)openExportDataMail
{
    // メールを利用できるかチェック
    if (![MFMailComposeViewController canSendMail]) {
        [UIAlertView bk_showAlertViewWithTitle:nil message:@"メールを起動できませんでした。" cancelButtonTitle:@"OK" otherButtonTitles:@[] handler:nil];
        return;
    }
    [SVProgressHUD show];
    WeakSelf weakSelf = self;
    [HALDataExporter exportAllDataToCSVWithCompletion:^(NSString *csv){
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject:@"鳥ログデータエクスポート"];
        NSData *data = [csv dataUsingEncoding:NSShiftJISStringEncoding];
        [controller addAttachmentData:data mimeType:@"text/csv" fileName:@"export.csv"];
        [controller bk_setCompletionBlock:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error){
            if (result == MFMailComposeResultSent) {
                [SVProgressHUD showSuccessWithStatus:@"送信しました"];
                int activityCount = [[HALActivityManager sharedManager] activityCount];
                [HALGAManager sendAction:@"Send Data CSV (Activity Count)" label:[NSString stringWithFormat:@"%d", activityCount] value:activityCount];
            }
        }];
        [weakSelf.navigationController presentViewController:controller animated:YES completion:^{
            [SVProgressHUD dismiss];
        }];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.views.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sectionViews = self.views[section];
    return sectionViews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.views[indexPath.section][indexPath.row][@"title"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionNames[section];
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
    NSDictionary *dict = self.views[indexPath.section][indexPath.row];
    if (dict[@"view"]) {
        [self.navigationController pushViewController:dict[@"view"] animated:YES];
    } else if(dict[@"selector"]) {
        SEL selector = NSSelectorFromString(dict[@"selector"]);
        [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
    }
}

@end
