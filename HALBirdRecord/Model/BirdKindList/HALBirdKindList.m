//
//  HALBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/08.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALBirdKindList.h"

@interface HALBirdKindList()

@property(nonatomic) NSArray *rawBirdKindList;

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
        _rawBirdKindList = [self loadRawBirdKindList];
        _birdKindList = [self birdKindListWithRawBirdList:self.rawBirdKindList];
    }
    return self;
}

- (int)numberOfGroups
{
    return self.birdKindList.count;
}

- (NSString *)groupNameForGroupIndex:(int)index
{
    return @"";
}

- (NSArray *)birdKindListWithRawBirdList:(NSArray *)rawBirdKindList
{
    return nil;
}

- (NSArray *)loadRawBirdKindList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BirdKind" ofType:@"plist"];
    NSArray *birdKindGroup = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *groupDict in birdKindGroup) {
        NSAssert([groupDict[@"GroupID"] isKindOfClass:[NSNumber class]], @"GroupIDはNumber");
        NSAssert([groupDict[@"GroupName"] isKindOfClass:[NSString class]], @"GroupNameはString");
        NSAssert([groupDict[@"BirdList"] isKindOfClass:[NSArray class]], @"BirdListはNSArray");
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
            [array addObject:kind];
        }
    }
    return [NSArray arrayWithArray:array];
}

- (HALBirdKind *)birdKindFromBirdID:(int)birdID
{
    for (HALBirdKind *kind in self.rawBirdKindList) {
        if (kind.birdID == birdID) {
            return kind;
        }
    }
    return nil;
}
@end
