//
//  HALActivityViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/13.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivityViewController.h"
#import "HALActivityTableViewController.h"

@interface HALActivityViewController ()

@property (weak, nonatomic) IBOutlet UIView *activityTableView;
@property(nonatomic) HALActivity *activity;
@property(nonatomic) HALActivityTableViewController *activityTableViewController;

@end

@implementation HALActivityViewController

- (id)initWithActivity:(HALActivity *)activity
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.activity = activity;
    }
    return self;
}

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
    self.activityTableViewController = [[HALActivityTableViewController alloc] initWithActivity:self.activity];
    [self.activityTableView addSubview:self.activityTableViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
