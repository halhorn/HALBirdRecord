//
//  HALHelpListLoader.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/01/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALHelpListLoader.h"
#import "HALHelp.h"

@implementation HALHelpListLoader

+ (instancetype)sharedLoader
{
    static dispatch_once_t onceToken;
    static HALHelpListLoader *sharedObject;
    dispatch_once(&onceToken, ^{
        sharedObject = [[HALHelpListLoader alloc] init];
    });
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        _helpList = [self loadHelpList];
    }
    return self;
}

- (NSArray *)loadHelpList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HelpList" ofType:@"plist"];
    NSArray *dictList = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictList) {
        HALHelp *help = [HALHelp helpWithQuestion:dict[@"Question"] answer:dict[@"Answer"]];
        [ret addObject:help];
    }
    return [NSArray arrayWithArray:ret];
}

@end
