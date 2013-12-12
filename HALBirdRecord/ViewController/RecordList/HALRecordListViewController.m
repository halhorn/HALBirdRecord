//
//  HALRecordListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALRecordListViewController.h"
#import "HALRecordListTableViewController.h"
#import "HALBirdKindListViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"

@interface HALRecordListViewController ()
@property (weak, nonatomic) IBOutlet UIView *activityRecordView;

@property(nonatomic) HALRecordListTableViewController *activityRecordTableViewController;
@end

@implementation HALRecordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activityRecordTableViewController = [HALRecordListTableViewController viewControllerFromNib];
    [self.activityRecordView addSubview:self.activityRecordTableViewController.view];
    [self setupNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar
{
    WeakSelf weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"＋" style:UIBarButtonItemStyleBordered handler:^(id sender){
        HALBirdKindListViewController *viewController = [HALBirdKindListViewController viewControllerFromNib];
        UINavigationController *navBarController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navBarController.navigationBar.translucent = NO;
        [weakSelf presentViewController:navBarController animated:YES completion:nil];
    }];
}

@end
