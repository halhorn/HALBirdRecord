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

+ (NSString *)exportAllDataToJSONSync
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
    NSData *data = [NSJSONSerialization dataWithJSONObject:activityArray options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
