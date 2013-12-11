//
//  UIViewController+HALAddCancelButton.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/11.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "UIViewController+HALSetCancelButton.h"

@implementation UIViewController (HALSetCancelButton)

- (void)setCancelButton
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered handler:^(id sender){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
