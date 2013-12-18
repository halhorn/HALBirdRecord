//
//  HALSaveActivityViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/10.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALSaveActivityViewController.h"
#import "NSDate+HALDateString.h"

@interface HALSaveActivityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextView *BirdRecordTextView;

@property(nonatomic) HALActivity *activity;
@property(nonatomic, copy) void (^completion)(HALActivity *);
@end

@implementation HALSaveActivityViewController

-(id) initWithActivity:(HALActivity *)activity completion:(void(^)(HALActivity *))completion
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.activity = activity;
        self.completion = completion;
        self.title = @"アクティビティ";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(NO, @"initWithNibNameよんじゃだめ！");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCancelButton];
    [self setBirdRecordText];
    [self setGestureForCloseSoftKeyboard];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onTapSaveButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBirdRecordText
{
    NSString *text;
    for (HALBirdRecord *birdRecord in self.activity.birdRecordList) {
        text = text ? [NSString stringWithFormat:@"%@ / %@", text, birdRecord.kind.name] : birdRecord.kind.name;
    }
    self.BirdRecordTextView.text = text;
}

- (void)setGestureForCloseSoftKeyboard {
    // 背景タップでキーボードを閉じる
    WeakSelf weakSelf = self;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
        [weakSelf.titleTextField resignFirstResponder];
        [weakSelf.locationTextField resignFirstResponder];
        [weakSelf.commentTextView resignFirstResponder];
    }];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)onTapSaveButton:(id)sender {
    NSString *title = self.titleTextField.text;
    if ([title isEqualToString:@""]) {
        title = [[NSDate date] dateString];
    }
    self.activity.title = title;
    self.activity.location = self.locationTextField.text;
    self.activity.comment = self.commentTextView.text;
    self.activity.datetime = [NSDate date];
    
    WeakSelf weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.completion(weakSelf.activity);
    }];
}
@end
