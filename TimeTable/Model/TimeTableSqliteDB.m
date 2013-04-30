//
//  TimeTableSqliteDB.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/28.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableSqliteDB.h"


@implementation TimeTableSqliteDB

//designed initializer
- (id) initDatabase {
    self = [super init];
    if(self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *documentDir = [TimeTableSqliteDB applicationDocumentsDirectory];
        NSString *flagPath = [documentDir stringByAppendingPathComponent:DBFLAG];
        
        //dbflag file check
        if(![fileManager fileExistsAtPath:flagPath]) {
            NSString *dbpath = [documentDir stringByAppendingPathComponent:DBPATH];
            NSString *templateDBPath = [[[NSBundle mainBundle] resourcePath]
                                        stringByAppendingPathComponent:BASEDB];
            //remove database file
            if([fileManager fileExistsAtPath:dbpath]) {
                [fileManager removeItemAtPath:dbpath error:NULL];
                NSLog(@"%@ deleted",dbpath);
            }
            
            //copy database file
            if([fileManager fileExistsAtPath:templateDBPath]) {
                if(![fileManager copyItemAtPath:templateDBPath toPath:dbpath error:&error]) {
                    NSLog(@"%@",[error localizedDescription]);
                    return nil;
                } else {
                    NSLog(@"Create database file(%@) from (%@)",dbpath, templateDBPath);
                }
            } else {
                NSLog(@"%@ : db not exist",templateDBPath);
                return nil;
            }
            
            //dbflag file create
            [fileManager createFileAtPath:flagPath contents:nil attributes:nil];
            NSLog(@"dbflag file create : %@",flagPath);
        } else {
            NSLog(@"db exists");
        }
    }
    return self;
}

+ (NSString *)getDatabaseFilePath {
    NSString *directory = [TimeTableSqliteDB applicationDocumentsDirectory];
    if(directory) {
        return [directory stringByAppendingPathComponent:DBPATH];
    }
    return nil;
}

+ (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}

+ (NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM d HH:mm:ss zzz yyyy"];
    return [dateFormat dateFromString:dateString];
}

+ (id)databaseQuery:(id (^)(FMResultSet *rs))block sql:(NSString *)sql args:(NSArray *)args{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block id map = nil;
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
            if([rs next]) {
                map = block(rs);
            }
            [rs close];
        }];
        [queue close];
    }
    return map;
}

+ (NSMutableArray *)databaseQueryList:(id (^)(FMResultSet *rs))block sql:(NSString *)sql args:(NSArray *)args{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
            while([rs next]) {
                [list addObject:block(rs)];
            }
            [rs close];
        }];
        [queue close];
    }
    return list;
}

+ (NSUInteger)databaseQueryCount:(NSString *)sql args:(NSArray *)args{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block NSUInteger count = 0;
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
            if([rs next]) {
                count = [rs intForColumnIndex:0];
            }
            [rs close];
        }];
        [queue close];
    }
    return count;
}

@end
