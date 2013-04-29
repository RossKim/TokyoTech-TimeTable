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

+ (id)databaseQuery:(id)model sql:(NSString *)sql firstObject:(id)firstObject, ... {
    va_list args;
    va_start(args, firstObject);
    __block NSArray *argsArray = [self getArrayByVaList:firstObject args:args];
    va_end(args);
    __block id modelClass = model;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block id map = nil;
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:argsArray];
            if([rs next]) {
                if([modelClass isEqual:[Course class]]) {
                    map = [Course createModel:rs];
                } else if([modelClass isEqual:[Subject class]]) {
                    map = [Subject createModel:rs];
                } else if([modelClass isEqual:[Professor class]]) {
                    map = [Professor createModel:rs];
                } else if([modelClass isEqual:[SubjectTimeMap class]]) {
                    map = [SubjectTimeMap createModel:rs];
                } else if([modelClass isEqual:[TimeTableModel class]]) {
                    map = [TimeTableModel createModel:rs];
                }
            }
            [rs close];
        }];
        [queue close];
    }
    return map;
}

+ (NSMutableArray *)databaseQueryList:(id)model sql:(NSString *)sql firstObject:(id)firstObject, ... {
    va_list args;
    va_start(args, firstObject);
    __block NSArray *argsArray = [self getArrayByVaList:firstObject args:args];
    va_end(args);
    __block id modelClass = model;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:argsArray];
            while([rs next]) {
                if([modelClass isEqual:[Course class]]) {
                    [list addObject:[Course createModel:rs]];
                } else if([modelClass isEqual:[Subject class]]) {
                    [list addObject:[Subject createModel:rs]];
                } else if([modelClass isEqual:[Professor class]]) {
                    [list addObject:[Professor createModel:rs]];
                } else if([modelClass isEqual:[SubjectTimeMap class]]) {
                    [list addObject:[SubjectTimeMap createModel:rs]];
                } else if([modelClass isEqual:[TimeTableModel class]]) {
                    [list addObject:[TimeTableModel createModel:rs]];
                }
            }
            [rs close];
        }];
        [queue close];
    }
    return list;
}

+ (NSUInteger)databaseQueryCount:(NSString *)sql firstObject:(id)firstObject, ... {
    va_list args;
    va_start(args, firstObject);
    __block NSArray *argsArray = [self getArrayByVaList:firstObject args:args];
    va_end(args);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[TimeTableSqliteDB getDatabaseFilePath]];
    __block NSUInteger count = 0;
    if(queue) {
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:argsArray];
            if([rs next]) {
                count = [rs intForColumnIndex:0];
            }
            [rs close];
        }];
        [queue close];
    }
    return count;
}

+ (NSArray *)getArrayByVaList:(id)firstObject args:(va_list)args {
    __block NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    if(firstObject) {
        [argsArray addObject:firstObject];
        id eachObject;
        while((eachObject = va_arg(args, id))) {
            [argsArray addObject:eachObject];
        }
    }
    return argsArray;
}
@end
