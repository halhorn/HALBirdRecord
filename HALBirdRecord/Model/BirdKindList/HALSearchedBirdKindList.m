//
//  HALSearchedBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/30.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALSearchedBirdKindList.h"
#import "HALBirdKindListBase.h"

@interface HALSearchedBirdKindList()

@property(nonatomic) NSArray *sortedBirdKind;

@end

@implementation HALSearchedBirdKindList

- (id)init
{
    self = [super init];
    if (self) {
        NSSortDescriptor *nameSortDescripter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *rawBirdKindList = [HALBirdKindLoader sharedLoader].birdKindList;
        self.sortedBirdKind = [rawBirdKindList sortedArrayUsingDescriptors:@[nameSortDescripter]];
    }
    return self;
}

- (NSString *)convertKana:(NSString *)string
{
    NSMutableString *convertedString = [string mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformHiraganaKatakana, false);
    return [NSString stringWithString:convertedString];
}

- (void)setSearchWord:(NSString *)searchWord
{
    _searchWord = searchWord;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", [self convertKana:searchWord]];
    self.searchedBirdKindList = [self.sortedBirdKind filteredArrayUsingPredicate:predicate];
}

- (BOOL)isSearchWordSet
{
    return self.searchWord && ![self.searchWord isEqualToString:@""];
}

@end
