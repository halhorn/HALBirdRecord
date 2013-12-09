//
//  HALDB.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2013/12/09.
//  Copyright (c) 2013年 halhorn. All rights reserved.
//

#import "HALDB.h"
#import "FMDataBase.h"
#import "NSURL+HALLocalFileURL.h"

#define kHALDBFile @"HALBirdRecord.db"

@interface HALDB()

@property(nonatomic) FMDatabase *fmDB;

@end

@implementation HALDB

- (id)init {
    self = [super init];
    if (self) {
        NSString *dbPath = [[NSURL urlWithLocalFileName:kHALDBFile] path];
        self.fmDB = [FMDatabase databaseWithPath:dbPath];
    }
    
    return self;
}


@end
