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
#define kHALBirdRecordTable @"BirdRecord"
#define kHALActivityRecordTable @"ActivityRecord"
#define kHALDBVersionKey @"DBVersion"
#define kHALDBVersion @1

@interface HALDB()

@property(nonatomic) FMDatabase *fmDB;

@end

@implementation HALDB

- (id)init {
    self = [super init];
    if (self) {
        NSString *dbPath = [[NSURL urlWithLocalFileName:kHALDBFile] path];
        self.fmDB = [FMDatabase databaseWithPath:dbPath];
        [self createTableIfExists];
    }
    
    return self;
}

- (void)createTableIfExists
{
    [self.fmDB open];
    [self.fmDB executeUpdate:[NSString stringWithFormat:@"create table if not exists %@("
                              "id integer primary key autoincrement,"
                              "birdID integer not null,"
                              "activityID integer,"
                              "count integer,"
                              "datetime integer,"
                              "latitude real,"
                              "longitude real,"
                              "prefecture text,"
                              "city text"
                              ");", kHALBirdRecordTable]];
    [self.fmDB executeUpdate:[NSString stringWithFormat:@"create table if not exists %@("
                              "id integer primary key autoincrement,"
                              "title text not null,"
                              "comment text"
                              ");", kHALActivityRecordTable]];
    
    [[NSUserDefaults standardUserDefaults] setObject:kHALDBVersion forKey:kHALDBVersionKey];
    [self.fmDB close];
}

- (void)showRecordInTable:(NSString *)tableName
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select * from %@", tableName];
    
    [self.fmDB open];
    FMResultSet *resultSet = [self.fmDB executeQuery:sqlFormat];
    
    while ([resultSet next]) {
        NSLog(@"------------------");
        NSDictionary *resultDict = [resultSet resultDictionary];
        for (NSString *key in [resultDict keyEnumerator]) {
            NSLog(@"%@:%@", key, resultDict[key]);
        }
    }
    
    [self.fmDB close];
}

- (NSArray *)selectActivityRows
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select * from %@ order by id desc", kHALActivityRecordTable];
    return [self selectWithSQL:sqlFormat args:nil];
}

- (NSArray *)selectBirdRecordListWithActivityDBID:(int)dbID
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select * from %@ where activityID = ? order by id", kHALBirdRecordTable];
    return [self selectWithSQL:sqlFormat args:@[@(dbID)]];
}

- (NSArray *)selectWithSQL:(NSString *)sql args:(NSArray *)args
{
    [self.fmDB open];
    FMResultSet *resultSet = args && args.count ?
    [self.fmDB executeQuery:sql withArgumentsInArray:args] :
    [self.fmDB executeQuery:sql];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        [ret addObject:[resultSet resultDictionary]];
    }
    return [NSArray arrayWithArray:ret];
}

- (int)selectLastIdOfActivityTable
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select max(id) as last_id from %@", kHALActivityRecordTable];
    [self.fmDB open];
    FMResultSet *resultSet = [self.fmDB executeQuery:sqlFormat];
    if ([resultSet next]) {
        NSNumber *last_id = [resultSet resultDictionary][@"last_id"];
        return [last_id intValue];
    }
    NSLog(@"NoData in table");
    return -1;
}

- (int)countTotalBirdKinds
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select count(distinct birdID) as count from %@", kHALBirdRecordTable];
    [self.fmDB open];
    FMResultSet *resultSet = [self.fmDB executeQuery:sqlFormat];
    if ([resultSet next]) {
        NSNumber *count = [resultSet resultDictionary][@"count"];
        return [count intValue];
    }
    NSLog(@"NoData in table");
    return -1;
}

- (int)countTotalPrefectures
{
    NSString *sqlFormat = [NSString stringWithFormat:@"select count(distinct prefecture) as count from %@", kHALBirdRecordTable];
    [self.fmDB open];
    FMResultSet *resultSet = [self.fmDB executeQuery:sqlFormat];
    if ([resultSet next]) {
        NSNumber *count = [resultSet resultDictionary][@"count"];
        return [count intValue];
    }
    NSLog(@"NoData in table");
    return -1;
}

- (int)insertActivityRecord:(HALActivity *)activity
{
    if (!activity) {return -1;}
    NSString *sqlFormat = [NSString stringWithFormat:@"insert into %@("
                           "title,"
                           "comment"
                           ") "
                           "values(?,?);", kHALActivityRecordTable];
    [self.fmDB open];
    [self.fmDB executeUpdate:sqlFormat, activity.title, activity.comment];
    int changes = [self.fmDB changes];
    [self.fmDB close];
    return changes;
}

- (int)insertBirdRecordList:(NSArray *)birdRecordList activityID:(int)activityID
{
    if (!birdRecordList || !birdRecordList.count) {return -1;}
    NSString *questions = @"(?,?,?,?,?,?,?,?)";
    for (int i = 1; i < birdRecordList.count; i++) {
        questions = [NSString stringWithFormat:@"%@,(?,?,?,?,?,?,?,?)", questions];
    }
    NSString *sqlFormat = [NSString stringWithFormat:@"insert into %@("
                           "birdID,"
                           "activityID,"
                           "count,"
                           "datetime,"
                           "latitude,"
                           "longitude,"
                           "prefecture,"
                           "city"
                           ") "
                           "values%@;", kHALBirdRecordTable, questions];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    for (HALBirdRecord *birdRecord in birdRecordList) {
        [args addObject:@(birdRecord.birdID)];
        [args addObject:@(activityID)];
        [args addObject:@(birdRecord.count)];
        [args addObject:birdRecord.datetime];
        [args addObject:@(birdRecord.coordinate.latitude)];
        [args addObject:@(birdRecord.coordinate.longitude)];
        [args addObject:birdRecord.prefecture];
        [args addObject:birdRecord.city];
    }

    [self.fmDB open];
    [self.fmDB executeUpdate:sqlFormat withArgumentsInArray:args];
    int changes = [self.fmDB changes];
    [self.fmDB close];
    return changes;
}

- (int)updateActivity:(HALActivity *)activity
{
    if (!activity || !activity.dbID) {return -1;}
    NSString *sqlFormat = [NSString stringWithFormat:@"update %@ set title = ?, comment = ? where id = ?", kHALActivityRecordTable];
    
    [self.fmDB open];
    [self.fmDB executeUpdate:sqlFormat, activity.title, activity.comment, @(activity.dbID)];
    int changes = [self.fmDB changes];
    [self.fmDB close];
    return changes;
}

- (int)deleteBirdRecordsInActivity:(HALActivity *)activity
{
    if (!activity) {return -1;}
    NSString *sqlFormat = [NSString stringWithFormat:@"delete from %@ where activityID = ?", kHALBirdRecordTable];

    [self.fmDB open];
    [self.fmDB executeUpdate:sqlFormat, @(activity.dbID)];
    int changes = [self.fmDB changes];
    [self.fmDB close];
    return changes;
}

- (int)deleteActivity:(HALActivity *)activity
{
    if (!activity) {return -1;}
    NSString *sqlFormat = [NSString stringWithFormat:@"delete from %@ where id = ?", kHALActivityRecordTable];
    
    [self.fmDB open];
    [self.fmDB executeUpdate:sqlFormat, @(activity.dbID)];
    int changes = [self.fmDB changes];
    [self.fmDB close];
    return changes;
}

- (void)dropTables
{
    [self.fmDB open];
    [self.fmDB executeUpdate:[NSString stringWithFormat:@"drop table %@;", kHALActivityRecordTable]];
    [self.fmDB executeUpdate:[NSString stringWithFormat:@"drop table %@;", kHALBirdRecordTable]];
    [self.fmDB close];
}

@end
