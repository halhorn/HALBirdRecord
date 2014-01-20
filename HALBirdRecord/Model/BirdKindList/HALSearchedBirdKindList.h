//
//  HALSearchedBirdKindList.h
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/30.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HALSearchedBirdKindList : NSObject

@property(nonatomic) NSString *searchWord;
@property(nonatomic) NSArray *searchedBirdKindList;
@property(nonatomic, readonly) BOOL isSearchWordSet;

- (NSString *)sectionNameAtIndex:(int)section;

@end
