//
//  Subject.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTableSqliteDB.h"

@class Course;
@class Professor;

@interface Subject : NSObject<SqliteModel>

#define SUBJECT_ID @"subject_id"
#define NAME @"name"
#define COURSE_ID @"course_id"
#define PROFESSOR_ID @"professor_id"
#define SEMESTER @"semester"
#define REGIST_NUM @"regist_num"
#define LOCATION @"location"
#define UPDATE_DATE @"update_date"

@property (readonly, nonatomic) NSUInteger subjectId;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic) NSUInteger courseId;
@property (readonly, nonatomic) NSUInteger professorId;
@property (readonly, nonatomic) NSUInteger semester;
@property (readonly, nonatomic) NSUInteger registNum;
@property (readonly, nonatomic, retain) NSString *location;
@property (readonly, nonatomic, retain) NSDate *updateDate;

+ (Subject *)findById:(NSUInteger)subjectId;
- (Course *)getCourse;
- (Professor *)getProfessor;
+ (NSMutableArray *)getSubjectListWithSemester:(NSUInteger)semester courseId:(NSUInteger)courseId;
+ (NSUInteger)getSubjectCountWithSemester:(NSUInteger)semester courseId:(NSUInteger)courseId;
- (NSString *)registerSubject;
- (NSString *)getTimeString;
- (BOOL)unregisterSubject;
@end
