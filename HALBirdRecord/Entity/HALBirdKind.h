//
//  HALBirdKind.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALBirdKind : NSObject
@property(nonatomic, readonly) int birdID;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSURL *url;
@property(nonatomic, readonly) NSString *comment;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, readonly) NSString *dataCopyRight;
@property(nonatomic, readonly) int groupID;
@property(nonatomic, readonly) NSString *groupName;

- (id)initWithBirdID:(int)birdID
                name:(NSString *)name
                 url:(NSURL *)url
             comment:(NSString *)comment
               image:(UIImage *)image
       dataCopyRight:(NSString *)dataCopyRight
             groupID:(int)groupID
           groupName:(NSString *)groupName;
+ (id)birdKindWithID:(int)birdID
                name:(NSString *)name
                 url:(NSURL *)url
             comment:(NSString *)comment
               image:(UIImage *)image
       dataCopyRight:(NSString *)dataCopyRight
             groupID:(int)groupID
           groupName:(NSString *)groupName;

@end
