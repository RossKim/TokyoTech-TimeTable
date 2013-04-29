//
//  SubjectTimeMap.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTableSqliteDB.h"

@class Subject;

@interface SubjectTimeMap : NSObject

#define SUBJECT_TIME_MAP_ID @"subject_time_map_id"
#define SUBJECT_ID @"subject_id"
#define DAY @"day"
#define TIME @"time"
#define PRACTICE @"practice"
#define UPDATE_DATE @"update_date"

@property (readonly, nonatomic) NSUInteger subjectTimeMapId;
@property (readonly, nonatomic) NSUInteger subjectId;
@property (readonly, nonatomic) NSUInteger day;
@property (readonly, nonatomic) NSUInteger time;
@property (readonly, nonatomic) BOOL practice;
@property (readonly, nonatomic, retain) NSDate *updateDate;

+ (SubjectTimeMap *)findById:(NSUInteger)subjectTimeMapId;
- (Subject *)getSubject;
+ (NSMutableArray *)getSubjectTimeMapList:(NSUInteger)subjectId;
+ (SubjectTimeMap *)createModel:(FMResultSet *)rs;

@end
