//
//  HALBirdKindEntity.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALBirdKindEntity : NSObject
@property(nonatomic, readonly) int birdID;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *comment;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, readonly) NSString *dataCopyRight;
@property(nonatomic, readonly) int groupID;
@property(nonatomic, readonly) NSString *groupName;

- (id)initWithBirdID:(int)birdID
                name:(NSString *)name
             comment:(NSString *)comment
               image:(UIImage *)image
       dataCopyRight:(NSString *)dataCopyRight
             groupID:(int)groupID
           groupName:(NSString *)groupName;
+ (id)entityWithID:(int)birdID
              name:(NSString *)name
           comment:(NSString *)comment
             image:(UIImage *)image
     dataCopyRight:(NSString *)dataCopyRight
           groupID:(int)groupID
         groupName:(NSString *)groupName;

@end
