//
//  HALBirdKind.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKind.h"

@implementation HALBirdKind
- (id)initWithBirdID:(int)birdID
                name:(NSString *)name
                 url:(NSURL *)url
             comment:(NSString *)comment
               image:(UIImage *)image
       dataCopyRight:(NSString *)dataCopyRight
             groupID:(int)groupID
           groupName:(NSString *)groupName
{
    self = [super init];
    if (self) {
        _birdID = birdID;
        _name = name;
        _url = url;
        _comment = comment;
        _image = image;
        _dataCopyRight = dataCopyRight;
        _groupID = groupID;
        _groupName = groupName;
    }
    return self;
}

+ (id)birdKindWithID:(int)birdID
                name:(NSString *)name
                 url:(NSURL *)url
             comment:(NSString *)comment
               image:(UIImage *)image
       dataCopyRight:(NSString *)dataCopyRight
             groupID:(int)groupID
           groupName:(NSString *)groupName
{
    return [[self alloc] initWithBirdID:birdID
                                   name:name
                                    url:url
                                comment:comment
                                  image:image
                          dataCopyRight:dataCopyRight
                                groupID:groupID
                              groupName:groupName];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"HALBirdKind: "
            "birdID:%d "
            "name:%@ "
            "url:%@ "
            "comment:%@ "
            "image:%@ "
            "dataCopyRight:%@ "
            "groupID:%d "
            "groupName:%@ "
            , self.birdID, self.name, self.url, self.comment, self.image, self.dataCopyRight, self.groupID, self.groupName];
}
@end
