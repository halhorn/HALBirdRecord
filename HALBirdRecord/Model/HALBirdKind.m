//
//  HALBirdKind.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKind.h"
#import "HALBirdKindEntity.h"

@interface HALBirdKind()

@end

@implementation HALBirdKind

+ (instancetype)sharedBirdKind
{
    static dispatch_once_t onceToken;
    static HALBirdKind *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALBirdKind alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadBirdKind];
    }
    return self;
}

- (void)loadBirdKind
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BirdKind" ofType:@"plist"];
    NSArray *birdKindGroup = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    _numberOfGroups = 0;
    for (NSDictionary *groupDict in birdKindGroup) {
        NSAssert([groupDict[@"GroupID"] isKindOfClass:[NSNumber class]], @"GroupIDはNumber");
        NSAssert([groupDict[@"GroupName"] isKindOfClass:[NSString class]], @"GroupNameはString");
        NSAssert([groupDict[@"BirdList"] isKindOfClass:[NSArray class]], @"BirdListはNSArray");
        NSMutableArray *birdArray = [[NSMutableArray alloc] init];
        for (NSDictionary *kindDict in groupDict[@"BirdList"]) {
            NSAssert([kindDict[@"BirdID"] isKindOfClass:[NSNumber class]], @"BirdIDはNumber");
            NSAssert([kindDict[@"Name"] isKindOfClass:[NSString class]], @"NameはString");
            NSAssert([kindDict[@"Comment"] isKindOfClass:[NSString class]], @"CommentはString");
            NSAssert([kindDict[@"DataCopyRight"] isKindOfClass:[NSString class]], @"DataCopyRightはString");
            NSAssert([kindDict[@"Image"] isKindOfClass:[NSString class]], @"ImageはString");
            
            UIImage *image = [kindDict[@"Image"] isEqualToString:@""] ? nil : [UIImage imageNamed:kindDict[@"Image"]];
            HALBirdKindEntity *entity = [HALBirdKindEntity entityWithID:[(NSNumber *)kindDict[@"BirdID"] intValue]
                                                                   name:kindDict[@"Name"]
                                                                comment:kindDict[@"Comment"]
                                                                  image:image
                                                          dataCopyRight:kindDict[@"DataCopyRight"]
                                                                groupID:[(NSNumber *)groupDict[@"GroupID"] intValue]
                                                              groupName:groupDict[@"GroupName"]];
            [birdArray addObject:entity];
        }
        [array addObject:[NSArray arrayWithArray:birdArray]];
        _numberOfGroups++;
    }
    _birdKindList = [NSArray arrayWithArray:array];
}
@end
