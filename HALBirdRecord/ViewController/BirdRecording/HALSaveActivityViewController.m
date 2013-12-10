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

@property(nonatomic) HALBirdRecord *birdRecord;
@property(nonatomic, copy) void (^completion)(HALActivityRecordEntity *);
@end

@implementation HALSaveActivityViewController

-(id) initWithBirdRecord:(HALBirdRecord *)birdRecord completion:(void(^)(HALActivityRecordEntity *))completion
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.birdRecord = birdRecord;
        self.completion = completion;
        self.title = @"アクティビティの保存";
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
    [self setBirdRecordText];
    [self setGestureForCloseSoftKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBirdRecordText
{
    NSString *text;
    for (HALBirdRecordEntity *birdRecordEntity in self.birdRecord.birdRecordList) {
        text = text ? [NSString stringWithFormat:@"%@ / %@", text, birdRecordEntity.kind.name] : birdRecordEntity.kind.name;
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

- (IBAction)onTapSaveButton:(id)sender {
    NSString *title = self.titleTextField.text;
    if ([title isEqualToString:@""]) {
        title = [[NSDate date] dateString];
    }
    HALActivityRecordEntity *entity = [[HALActivityRecordEntity alloc] init];
    entity.title = title;
    entity.location = self.locationTextField.text;
    entity.comment = self.commentTextView.text;
    entity.datetime = [NSDate date];
    
    WeakSelf weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.completion(entity);
    }];
}
@end
