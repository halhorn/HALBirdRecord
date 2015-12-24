//
//  HALDataExporter.m
//  HALBirdRecord
//
//  Created by 信田 春満 on 2014/05/06.
//  Copyright (c) 2014年 halhorn. All rights reserved.
//

#import "HALDataExporter.h"
#import "HALActivityManager.h"
#import "HALBirdKindLoader.h"
#import <Parse/Parse.h>

#define kHALDataExportClassName @"DataExport"
#define kHALParseDataExportVersion @"1.1"

@implementation HALDataExporter

+ (void)exportAllDataToCSVWithCompletion:(void(^)(NSString *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *csv = [HALDataExporter exportAllDataToCSVSync];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(csv);
        });
    });
}

+ (NSString *)exportAllDataToCSVSync
{
    HALActivityManager *activityManager = [HALActivityManager sharedManager];
    HALBirdKindLoader *birdKindLoader = [HALBirdKindLoader sharedLoader];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"アクティビティ名,アクティビティコメント,鳥グループ,鳥名,日時,県,町,緯度,軽度,コメント\n"];
    for (int activityNo = 0; activityNo < [activityManager activityCount]; activityNo++) {
        HALActivity *activity = [activityManager activityWithIndex:activityNo];
        [activity loadBirdRecordListByOrder:HALBirdrecordOrderBirdID];
        for (HALBirdRecord *record in [activity birdRecordList]) {
            HALBirdKind *kind = [birdKindLoader birdKindFromBirdID:record.birdID];
            NSString *tmp = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%f,%f,%@\n",
                             activity.title,
                             activity.comment,
                             kind.groupName,
                             kind.name,
                             [dateFormatter stringFromDate:record.datetime],
                             record.prefecture,
                             record.city,
                             record.coordinate.latitude,
                             record.coordinate.longitude,
                             record.comment
                             ];
            [str appendString:tmp];
        }
    }
    return str;
}

+ (void)exportAllDataToParseWithCompletion:(void(^)(BOOL, NSString *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFFile *jsonFile = [PFFile fileWithName:@"activities.json" data:[HALDataExporter exportAllDataToJSONSync]];
        PFObject *pfObject = [PFObject objectWithClassName:kHALDataExportClassName];
        pfObject[@"file"] = jsonFile;
        pfObject[@"version"] = kHALParseDataExportVersion;
        [pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(succeeded, pfObject.objectId);
            });
        }];
    });
}

+ (void)importDataFromParseWithKey:(NSString *)objectId
                        completion:(void(^)(BOOL, NSString *))completion
{
    PFQuery *query = [PFQuery queryWithClassName:kHALDataExportClassName];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == 101) {
                    completion(false, @"指定されたIDのデータが見つかりませんでした。");
                } else {
                    completion(false, error.localizedDescription);
                }
            });
            return;
        }
        if (![object[@"version"] isEqualToString:kHALParseDataExportVersion]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(false, @"データの送信元と送信先両方に最新版のアプリをインストールしてください");
            });
            return;
        }
        PFFile *jsonFile = object[@"file"];
        NSData *jsonData = [jsonFile getData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [HALDataExporter importDataFromJSONSync:jsonData];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(true, nil);
            });
        });
    }];
    
}

+ (NSData *)exportAllDataToJSONSync
{
    HALActivityManager *activityManager = [HALActivityManager sharedManager];

    NSMutableArray *activityArray = [NSMutableArray array];
    for (int activityNo = 0; activityNo < [activityManager activityCount]; activityNo++) {
        HALActivity *activity = [activityManager activityWithIndex:activityNo];
        
        [activity loadBirdRecordListByOrder:HALBirdRecordOrderDateTime];
        NSMutableArray *recordArray = [NSMutableArray array];
        for (HALBirdRecord *record in [activity birdRecordList]) {
            [recordArray addObject:@{
                                     @"birdID"     : @(record.birdID),
                                     @"count"      : @(record.count),
                                     @"latitude"   : @(record.coordinate.latitude),
                                     @"longitude"  : @(record.coordinate.longitude),
                                     @"prefecture" : record.prefecture,
                                     @"city"       : record.city,
                                     @"comment"    : record.comment,
                                     @"datetime"   : @([record.datetime timeIntervalSince1970]),
                                     }];
        }
        [activityArray addObject:@{
                                   @"title"          : activity.title,
                                   @"comment"        : activity.comment,
                                   @"birdRecordList" : recordArray,
                                   }];
    }
    return [NSJSONSerialization dataWithJSONObject:activityArray options:NSJSONWritingPrettyPrinted error:nil];
}

+ (void)importDataFromJSONSync:(NSData *)jsonData
{
    HALActivityManager *activityManager = [HALActivityManager sharedManager];

    NSArray *activityArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    for (NSDictionary *activityDict in activityArray) {
        HALActivity *activity = [HALActivity activityWithDictionary:activityDict];
        [activityManager saveActivity:activity];
    }
}

@end
