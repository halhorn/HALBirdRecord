//
//  UIViewController+HALViewControllerFromNib.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "UIViewController+HALViewControllerFromNib.h"

@implementation UIViewController (HALViewControllerFromNib)

- (id)initWithNib {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (id)viewControllerFromNib {
    return [[self alloc] initWithNib];
}

@end
