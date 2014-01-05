//
//  HALLicenseViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/05.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALLicenseViewController.h"
#import "HALBirdKindLoader.h"

#define kHALTitleFontSize 24
#define kHALDescriptionSize 10

@interface HALLicenseViewController ()

@property (weak, nonatomic) IBOutlet UITextView *licenseTextView;

@end

@implementation HALLicenseViewController

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
    self.title = @"Acknowledgements / Licenses";
    
    NSMutableAttributedString *licenseString = [[NSMutableAttributedString alloc] init];
    [licenseString appendAttributedString:[self licenseStringWithTitle:@"使用ライブラリ" description:@""]];
    [licenseString appendAttributedString:[self libraryLicense]];
    [licenseString appendAttributedString:[self licenseStringWithTitle:@"\n\n鳥種画像ライセンス" description:@"WikiPedia:日本の野鳥一覧より\nhttp://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC%E3%81%AE%E9%87%8E%E9%B3%A5%E4%B8%80%E8%A6%A7"]];
    [licenseString appendAttributedString:[self birdLicense]];
    
    self.licenseTextView.attributedText = licenseString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)libraryLicense
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-acknowledgements" ofType:@"plist"];
    NSDictionary *acknowledgementsDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *acknowledgements = acknowledgementsDict[@"PreferenceSpecifiers"];
    
    NSMutableAttributedString *acknowledgementsString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *acknowledgement in acknowledgements) {
        NSAttributedString *str = [self licenseStringWithTitle:acknowledgement[@"Title"]
                                                   description:acknowledgement[@"FooterText"]];
        [acknowledgementsString appendAttributedString:str];
    }
    return acknowledgementsString;
}

- (NSAttributedString *)birdLicense
{
    NSArray *birdKindList = [HALBirdKindLoader sharedLoader].birdKindList;
    NSMutableAttributedString *acknowledgementsString = [[NSMutableAttributedString alloc] init];
    for (HALBirdKind *kind in birdKindList) {
        NSAttributedString *str = [self licenseStringWithTitle:kind.name
                                                   description:kind.dataCopyRight];
        [acknowledgementsString appendAttributedString:str];
    }
    return acknowledgementsString;
}

- (NSAttributedString *)licenseStringWithTitle:(NSString *)title description:(NSString *)description
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[[NSAttributedString alloc]
                                    initWithString:[NSString stringWithFormat:@"%@\n", title]
                                    attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kHALTitleFontSize]}]];
    [string appendAttributedString:[[NSAttributedString alloc]
                                    initWithString:[NSString stringWithFormat:@"%@\n\n", description]
                                    attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kHALDescriptionSize]}]];
    return string;
}

@end
