//
//  HALSearchedBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/30.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALSearchedBirdKindList.h"
#import "HALBirdKindList.h"

@interface HALSearchedBirdKindList()

@property(nonatomic) HALBirdKindList *birdKindList;

@end

@implementation HALSearchedBirdKindList

- (id)init
{
    self = [super init];
    if (self) {
        self.birdKindList = [HALBirdKindList sharedBirdKindList];
    }
    return self;
}

- (void)setSearchWord:(NSString *)searchWord
{
    _searchWord = searchWord;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", searchWord];
    self.searchedBirdKindList = [self.birdKindList.rawBirdKindList filteredArrayUsingPredicate:predicate];
}

- (BOOL)isSearchWordSet
{
    return self.searchWord && ![self.searchWord isEqualToString:@""];
}

@end
