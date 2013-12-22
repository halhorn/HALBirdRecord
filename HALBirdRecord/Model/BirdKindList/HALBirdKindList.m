//
//  HALBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindList.h"

@interface HALBirdKindList()

@end

@implementation HALBirdKindList

+ (instancetype)sharedBirdKindList
{
    static dispatch_once_t onceToken;
    static HALBirdKindList *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALBirdKindList alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *rawBirdKindList = [self loadRawBirdKindList];
        _birdKindList = [self birdKindListWithRawBirdList:rawBirdKindList];
    }
    return self;
}

- (NSArray *)birdKindListWithRawBirdList:(NSArray *)rawBirdKindList
{
    return rawBirdKindList;
}

- (NSArray *)loadRawBirdKindList
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
            HALBirdKind *kind = [HALBirdKind birdKindWithID:[(NSNumber *)kindDict[@"BirdID"] intValue]
                                                         name:kindDict[@"Name"]
                                                      comment:kindDict[@"Comment"]
                                                        image:image
                                                dataCopyRight:kindDict[@"DataCopyRight"]
                                                      groupID:[(NSNumber *)groupDict[@"GroupID"] intValue]
                                                    groupName:groupDict[@"GroupName"]];
            [birdArray addObject:kind];
        }
        [array addObject:[NSArray arrayWithArray:birdArray]];
        _numberOfGroups++;
    }
    return [NSArray arrayWithArray:array];
}

- (HALBirdKind *)birdKindFromBirdID:(int)birdID
{
    for (NSArray *group in self.birdKindList) {
        for (HALBirdKind *kind in group) {
            if (kind.birdID == birdID) {
                return kind;
            }
        }
    }
    return nil;
}
@end
