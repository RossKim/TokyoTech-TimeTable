//
//  TimeTableModel.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTableSqliteDB.h"

@class Subject;

@interface TimeTableModel : NSObject <SqliteModel>

#define TIMETABLE_ID @"timetable_id"
#define SUBJECT_ID @"subject_id"
#define START_TIME @"start_time"
#define END_TIME @"end_time"
#define UPDATE_DATE @"update_date"

@property (readonly, nonatomic) NSUInteger timeTableId;
@property (readonly, nonatomic) NSUInteger subjectId;
@property (readonly, nonatomic) NSUInteger day;
@property (readonly, nonatomic) NSUInteger startTime;
@property (readonly, nonatomic) NSUInteger endTime;
@property (readonly, nonatomic, retain) NSDate *updateDate;

+ (TimeTableModel *)findById:(NSUInteger)timeTableId;
- (Subject *)getSubject;
+ (TimeTableModel *)findBySubjectId:(NSUInteger)subjectId;
+ (BOOL)isSubjectRegistered:(NSUInteger)subjectId;
+ (NSUInteger)getRegisteredSubjectCountWithDay:(NSUInteger)day;
+ (NSMutableArray *)getRegisteredSubjectArrayWithDay:(NSUInteger)day;

@end
