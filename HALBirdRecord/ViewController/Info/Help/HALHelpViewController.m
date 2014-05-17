//
//  HALHelpViewController.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALHelpViewController.h"
#import "UIViewController+HALViewControllerFromNib.h"

@interface HALHelpViewController ()

@property(nonatomic) HALHelp *help;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

@end

@implementation HALHelpViewController

- (id)initWithHelp:(HALHelp *)help
{
    self = [super initWithNib];
    if (self) {
        self.help = help;
        self.title = help.question;
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
    self.questionLabel.text = self.help.question;
    self.questionView.backgroundColor = kHALHelpQuestionBackgroundColor;
    self.answerTextView.text = self.help.answer;
    self.answerTextView.font = [UIFont systemFontOfSize:17];
    self.answerView.backgroundColor = kHALHelpAnswerBackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HALGAManager sendView:@"HelpQA"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
