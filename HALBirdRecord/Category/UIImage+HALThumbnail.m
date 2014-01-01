//
//  UIImage+HALThumbnail.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/29.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "UIImage+HALThumbnail.h"

@implementation UIImage (HALThumbnail)

- (UIImage *) thumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

@end
