//
//  HALStudentAuthenticationViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/02/01.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALStudentAuthenticationViewController.h"
#import "HALStudentAuthenticator.h"
#import "NSDate+HALDateComponents.h"

#define kHALPickerHeight 200
#define kHALPickerAnmationDuration 0.2
#define kHALPhotoLongSideLength 640

@interface HALStudentAuthenticationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *descriptionBackgroudView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *graduationDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *graduationDateButton;
@property (weak, nonatomic) IBOutlet UILabel *takePhotoLabel;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *photoCautionLabel;
@property (weak, nonatomic) IBOutlet UIView *okView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *datePickerHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *datePickerCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *datePickerOKButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDate *expireDate;
@property (nonatomic) UIImage *photo;

@end

@implementation HALStudentAuthenticationViewController

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
    self.title = @"学割アカウント";
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    NSDateComponents *dateComponents = [NSDate dateComponentsForCurrentDate];
    NSDate *date = [NSDate dateWithYear:dateComponents.year + 1 month:3 day:31 hour:23 minute:59 second:59];
    self.datePicker.date = date;
    self.expireDate = date;
    [self.graduationDateButton setTitle:[self.dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    
    [self setupColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupColor
{
    self.descriptionBackgroudView.backgroundColor = kHALStudentAuthenticationBackgroundColor;
    self.descriptionLabel.textColor = kHALTextColor;
    self.inputInfoLabel.textColor = kHALSubTextColor;
    self.graduationDateLabel.textColor = kHALTextColor;
    self.takePhotoLabel.textColor = kHALTextColor;
    self.photoCautionLabel.textColor = kHALSubTextColor;
    self.okView.backgroundColor = kHALStudentAuthenticationBackgroundColor;
    self.datePickerHeaderView.backgroundColor = kHALStudentAuthenticationBackgroundColor;
}

- (void)showDatePicker
{
    CGSize screenSize = self.view.frame.size;
    self.datePickerView.frame = CGRectMake(0, kHALPickerHeight, screenSize.width, screenSize.height);
    [self.view addSubview:self.datePickerView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kHALPickerAnmationDuration];
    self.datePickerView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [UIView commitAnimations];
}

- (void)dismissDatePicker
{
    CGSize screenSize = self.view.frame.size;
    WeakSelf weakSelf = self;
    [UIView animateWithDuration:kHALPickerAnmationDuration animations:^{
        weakSelf.datePickerView.frame = CGRectMake(0, kHALPickerHeight, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        [weakSelf.datePickerView removeFromSuperview];
    }];
}

- (void)validateAndSwitchOKButton
{
    [self.okButton setEnabled:[self.expireDate compare:[NSDate date]] == NSOrderedDescending && self.photo != nil];
}

// 長辺の長さを指定してリサイズ
- (UIImage *)resizeImage:(UIImage *)image longSideLength:(int)longSideLength
{
    CGSize originalSize = image.size;
    CGSize size;
    if (originalSize.width > originalSize.height) {
        size = CGSizeMake(longSideLength, originalSize.height * longSideLength / originalSize.width);
    } else {
        size = CGSizeMake(originalSize.width * longSideLength / originalSize.height, longSideLength);
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - event handler

- (IBAction)onTapGraduationDate:(id)sender {
    [self showDatePicker];
}

- (IBAction)onTapTakePhoto:(id)sender {
	// カメラが利用できるか確認
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		[imagePickerController setAllowsEditing:NO];
		[imagePickerController setDelegate:self];
        [self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		[UIAlertView showAlertViewWithTitle:nil message:@"カメラが起動できませんでした" cancelButtonTitle:@"OK" otherButtonTitles:@[] handler:nil];
	}
}

- (IBAction)onTapOK:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    HALStudentAuthenticator *authenticator = [HALStudentAuthenticator sharedAuthenticator];
    WeakSelf weakSelf = self;
    [authenticator requestStudentAuthenticationWithImage:self.photo expire:self.expireDate completion:^(BOOL succeeded){
        if (!succeeded) {
            [SVProgressHUD showErrorWithStatus:@"失敗しました"];
            [UIAlertView showAlertViewWithTitle:@"認証に失敗しました" message:@"ネットワーク環境の良い場所でもう一度OKボタンを押して下さい。" cancelButtonTitle:@"OK" otherButtonTitles:@[] handler:nil];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"OK"];
        [UIAlertView showAlertViewWithTitle:@"学生認証を申請しました" message:@"学生の認証には一週間程度かかります。しばらくお待ち下さい。" cancelButtonTitle:@"OK" otherButtonTitles:@[] handler:^(UIAlertView *alertView, NSInteger buttonIndex){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (IBAction)onTapCancelPicker:(id)sender {
    [self dismissDatePicker];
}

- (IBAction)onTapOKPicker:(id)sender {
    self.expireDate = self.datePicker.date;
    [self.graduationDateButton setTitle:[self.dateFormatter stringFromDate:self.expireDate] forState:UIControlStateNormal];
    [self dismissDatePicker];
    [self validateAndSwitchOKButton];
}

#pragma mark - UIImagePickerControllerDelegate

// 写真撮影後、もしくはフォトライブラリでサムネイル選択後に呼ばれるDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self resizeImage:originalImage longSideLength:kHALPhotoLongSideLength];
    self.photo = resizedImage;
    self.photoView.image = resizedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self validateAndSwitchOKButton];
}

@end
