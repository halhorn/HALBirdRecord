//
//  HALActivity.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALActivity.h"

@interface HALActivity()

@property(nonatomic) HALDB *db;

@end

@implementation HALActivity

- (id)init
{
    self = [super init];
    if (self) {
        self.dbID = 0;
        self.title = @"";
        self.comment = @"";
        _birdRecordList = [[NSMutableArray alloc] init];
        self.db = [HALDB sharedDB];
    }
    return self;
}

- (void)addBirdRecord:(HALBirdRecord *)birdRecord
{
    [self.birdRecordList addObject:birdRecord];
}

- (void)addBirdRecordList:(NSArray *)birdRecordList
{
    for (HALBirdRecord *record in birdRecordList) {
        [self addBirdRecord:record];
    }
}

- (void)loadBirdRecordListByOrder:(HALBirdRecordOrder)order
{
    _birdRecordList = [[NSMutableArray alloc] init];
    NSArray *birdRows = [self.db selectBirdRecordListWithActivityDBID:self.dbID order:order];
    for (NSDictionary *birdRow in birdRows) {
        [self.birdRecordList addObject:[HALBirdRecord birdRecordWithDBRow:birdRow]];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Activity: dbID:%d title:%@ comment:%@ birds:%@", self.dbID, self.title, self.comment, self.birdRecordList];
}

@end
