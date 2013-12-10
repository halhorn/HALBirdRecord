//
//  HALBirdKindListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindListViewController.h"
#import "HALFlatBirdKindListTableViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALDB.h"

@interface HALBirdKindListViewController ()
@property (weak, nonatomic) IBOutlet UIView *BirdListView;

@property(nonatomic) UIViewController<HALBirdRecordViewDelegate> *birdListViewController;

@end

@implementation HALBirdKindListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"野鳥リスト";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.birdListViewController = [HALFlatBirdKindListTableViewController viewControllerFromNib];
    [self.BirdListView addSubview:self.birdListViewController.view];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapSaveButton:)];
    
    HALActivityRecordEntity *activity = [[HALActivityRecordEntity alloc] init];
    activity.title = @"title";
    activity.location = @"location";
    activity.comment = @"comment";
    HALBirdRecordEntity *bird = [HALBirdRecordEntity birdRecordWithBirdID:1];
    [bird seeBird];
    HALBirdRecordEntity *bird2 = [HALBirdRecordEntity birdRecordWithBirdID:1];
    NSArray *birds = @[bird, bird2];
    
    HALDB *db = [[HALDB alloc] init];
    [db insertActivityRecord:activity];
    [db insertBirdRecordList:birds activityID:1];
    [db showRecordInTable:@"BirdRecord"];
    [db showRecordInTable:@"ActivityRecord"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTapSaveButton:(id)sender
{
    HALBirdRecord *record = [self.birdListViewController sendBirdRecord];
    NSLog(@"%@", record.birdRecordList);
}

@end
