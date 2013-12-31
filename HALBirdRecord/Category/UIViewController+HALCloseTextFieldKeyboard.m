//
//  UIViewController+HALCloseTextFieldKeyboard.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "UIViewController+HALCloseTextFieldKeyboard.h"

@implementation UIViewController (HALCloseTextFieldKeyboard)

- (void)setGestureForClosingKeyBoard
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(closeKeyBoard:)]];
}

- (void)closeKeyBoard:(id)sender
{
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
