//
//  HALWebViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/29.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALWebViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"

@interface HALWebViewController ()<UIWebViewDelegate>
@property (nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HALWebViewController

- (id)initWithURL:(NSURL *)url title:(NSString *)title
{
    self = [super initWithCoder:nil];
    if (self) {
        self.url = url;
        self.title = title;
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

    // Show webView
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.delegate = self;

    [SVProgressHUD showWithStatus:@"読み込み中"];
    
    WeakSelf weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"閉じる" style:UIBarButtonItemStyleBordered handler:^(id sender){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [HALGAManager sendAction:@"View Web"
                       label:[[self.url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       value:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"Web Browser"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (![title isEqualToString:@""]) {
        self.title = title;
    }
}

@end
