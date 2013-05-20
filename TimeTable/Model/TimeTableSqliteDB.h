//
//  TimeTableSqliteDB.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/28.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "Course.h"
#import "Professor.h"
#import "Subject.h"
#import "SubjectTimeMap.h"
#import "TimeTableModel.h"

@protocol SqliteModel

@required
- (id)createModel:(FMResultSet *)rs;

@end

@interface TimeTableSqliteDB : NSObject

#define BASEDB @"timetable.db3"
#define DBPATH @"database.sqlite"
#define DBFLAG @"dbflag"

- (id) initDatabase;
+ (NSString *) getDatabaseFilePath;
+ (NSString *) applicationDocumentsDirectory;
+ (NSDate *)getDateFromString:(NSString *)dateString;
+ (id)databaseQuery:(id<SqliteModel>)model sql:(NSString *)sql args:(NSArray *)args;
+ (NSMutableArray *)databaseQueryList:(id<SqliteModel>)model sql:(NSString *)sql args:(NSArray *)args;
+ (NSUInteger)databaseQueryCount:(NSString *)sql args:(NSArray *)args;
+ (BOOL)databaseUpdate:(NSString *)sql args:(NSArray *)args;
+ (NSArray *)getDay;

@end
