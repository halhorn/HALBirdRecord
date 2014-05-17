//
//  HALBirdKindListViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindListViewController.h"
#import "HALFlatBirdKindListTableViewController.h"
#import "HALDB.h"
#import "HALActivityManager.h"
#import "HALThread.h"
#import "UIViewController+HALCloseTextFieldKeyboard.h"
#import "UIViewController+HALViewControllerFromNib.h"
#import "UIViewController+HALSetCancelButton.h"

#define kHALMaxWaitTime 10

@interface HALBirdKindListViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *birdListView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

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

-(void) onTapBirdRow
{
    /*
    // 複数追加の場合
    int count = [self.birdListViewController sendBirdList].count;
    self.navigationItem.rightBarButtonItem.title = count ? [NSString stringWithFormat:@"追加（%d）", count] : @"追加";
     */
    [self saveAndDismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.birdListViewController = [HALFlatBirdKindListTableViewController viewControllerFromNib];
    self.birdListViewController.birdKindListViewController = self;
    CGSize size = self.birdListView.frame.size;
    self.birdListViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
    [self.birdListView addSubview:self.birdListViewController.view];
    self.searchTextField.delegate = self;
    [self.searchTextField becomeFirstResponder];

    WeakSelf weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered handler:^(id sender){
        if (![weakSelf.birdListViewController sendBirdList].count) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [UIAlertView bk_showAlertViewWithTitle:nil message:@"追加中のデータは破棄されます。よろしいですか？" cancelButtonTitle:@"いいえ" otherButtonTitles:@[@"はい"] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            if (buttonIndex == alertView.cancelButtonIndex) {
                return;
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    /*
    // 複数追加の場合
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"追加"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapAddButton:)];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"Bird Selector"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 指定時間ごとにテキストの変更が無いかをチェックし、変更があればテキストの候補を表示する。
- (void)startTextFieldWatcherBlock:(void(^)(NSString *))block
{
    UITextField *targetTextField = self.searchTextField;
    
    __block NSString *text = targetTextField.text;
    WeakSelf weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 100ms毎にテキスト入力欄に変更が無いかをチェック
        while (weakSelf.searchTextField.isEditing) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![targetTextField.text isEqualToString:text]){
                    // 変更があった場合。
                    text = targetTextField.text;
                    block(text);
                }
            });
            [NSThread sleepForTimeInterval:0.1];
        }
    });
}

- (BOOL)isAllBirdRecordRedy
{
    for (HALBirdRecord *record in [self.birdListViewController sendBirdList]) {
        if (record.isProcessing) {
            return NO;
        }
    }
    return YES;
}

- (void)saveAndDismiss
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 全ての BirdList が保存可能になるのを待ってからcompletionを実行
    WeakSelf weakSelf = self;
    NSDate *startTime = [NSDate date];
    [HALThread waitUntil:^BOOL(){
        return [weakSelf isAllBirdRecordRedy];
        
    } do:^(BOOL success){
        NSTimeInterval timeDelay = [[NSDate date] timeIntervalSinceDate:startTime];
        [HALGAManager sendAction:@"Delay Adding Bird List (delay)"
                           label:[NSString stringWithFormat:@"%d", (int)timeDelay]
                           value:timeDelay];
        if (!success) {
            [HALGAManager sendAction:@"Fail to get Location" label:@"" value:0];
        }
        weakSelf.completion([weakSelf.birdListViewController sendBirdList]);
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } maxWait:kHALMaxWaitTime];
}

#pragma mark - UIEventHandler

- (void)onTapAddButton:(id)sender
{
    [self saveAndDismiss];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    WeakSelf weakSelf = self;
    [self startTextFieldWatcherBlock:^(NSString *newText){
        [weakSelf.birdListViewController setSearchWord:newText];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.birdListViewController setSearchWord:self.searchTextField.text];
}
@end
