//
//  HALLicenseViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/05.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALLicenseViewController.h"

#define kHALTitleFontSize 20
#define kHALDescriptionSize 12

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-acknowledgements" ofType:@"plist"];
    NSDictionary *acknowledgementsDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *acknowledgements = acknowledgementsDict[@"PreferenceSpecifiers"];
    
    NSMutableAttributedString *acknowledgementsString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *acknowledgement in acknowledgements) {
        NSAttributedString *title = [[NSAttributedString alloc]
                                     initWithString:[NSString stringWithFormat:@"%@¥n", acknowledgement[@"Title"]]
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kHALTitleFontSize]}];
        NSAttributedString *description = [[NSAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"%@¥n¥n", acknowledgement[@"FooterText"]]
                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kHALDescriptionSize]}];
        [acknowledgementsString appendAttributedString:title];
        [acknowledgementsString appendAttributedString:description];
    }
    self.licenseTextView.attributedText = acknowledgementsString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
