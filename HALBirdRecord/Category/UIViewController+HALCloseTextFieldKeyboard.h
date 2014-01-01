//
//  UIViewController+HALCloseTextFieldKeyboard.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/31.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HALCloseTextFieldKeyboard)<UITextFieldDelegate>

- (void)setGestureForClosingKeyBoardToView:(UIView *)view;

@end
