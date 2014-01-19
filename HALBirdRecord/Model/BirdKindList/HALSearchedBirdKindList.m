//
//  HALSearchedBirdKindList.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/30.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALSearchedBirdKindList.h"
#import "HALBirdKindListBase.h"

#define kHALGroupSuffix @"科"

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
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSString *kanaSearchWord = [self convertKana:searchWord];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name contains %@", kanaSearchWord];
    NSString *groupName = [NSString stringWithFormat:@"%@%@", kanaSearchWord, kHALGroupSuffix];
    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"groupName like %@", groupName];
    [list addObject:[self.sortedBirdKind filteredArrayUsingPredicate:namePredicate]];
    NSArray *groupSearchedList = [self.sortedBirdKind filteredArrayUsingPredicate:groupPredicate];
    if (groupSearchedList.count) {
        [list addObject:groupSearchedList];
    }
    
    self.searchedBirdKindList = [NSArray arrayWithArray:list];
}

- (NSString *)sectionNameAtIndex:(int)section
{
    if (section == 0) {
        return @"鳥名での検索";
    } else {
        NSString *kanaSearchWord = [self convertKana:self.searchWord];
        return [NSString stringWithFormat:@"%@%@の鳥", kanaSearchWord, kHALGroupSuffix];
    }
}

- (BOOL)isSearchWordSet
{
    return self.searchWord && ![self.searchWord isEqualToString:@""];
}

@end
