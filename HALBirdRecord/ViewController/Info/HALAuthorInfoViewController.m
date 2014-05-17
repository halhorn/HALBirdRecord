//
//  HALAuthorInfoViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/13.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALAuthorInfoViewController.h"

@interface HALAuthorInfoViewController ()

@end

@implementation HALAuthorInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"作者・協力者";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"AuthorInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
