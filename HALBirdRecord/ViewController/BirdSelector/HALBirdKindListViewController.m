//
//  HALBirdKindListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindListViewController.h"
#import "HALFlatBirdKindListTableViewController.h"
#import "HALSaveActivityViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "HALDB.h"
#import "HALActivityManager.h"

@interface HALBirdKindListViewController ()
@property (weak, nonatomic) IBOutlet UIView *BirdListView;

@property(nonatomic, copy) void(^completion)(NSArray *birdRecordList);
@property(nonatomic) UIViewController<HALBirdRecordViewDelegate> *birdListViewController;

@end

@implementation HALBirdKindListViewController

-(id) initWithCompletion:(void(^)(NSArray *))completion;
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.completion = completion;
        self.title = @"野鳥リスト";
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
    self.birdListViewController = [HALFlatBirdKindListTableViewController viewControllerFromNib];
    [self.BirdListView addSubview:self.birdListViewController.view];

    [self setCancelButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追加"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapAddButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIEventHandler

- (void)onTapAddButton:(id)sender
{
    NSArray *birdList = [self.birdListViewController sendBirdList];
    
    if (birdList.count) {
        self.completion(birdList);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        WeakSelf weakSelf = self;
        [UIAlertView showAlertViewWithTitle:@"鳥さんはどこ？" message:@"鳥が一羽もいないアクティビティを保存しますか？" cancelButtonTitle:@"戻る" otherButtonTitles:@[@"保存"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            if (buttonIndex == alertView.cancelButtonIndex) {
                return;
            }
            weakSelf.completion(birdList);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end
