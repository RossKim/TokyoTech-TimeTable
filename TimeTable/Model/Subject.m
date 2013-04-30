//
//  Subject.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "Subject.h"

@interface Subject()

@property (readwrite, nonatomic) NSUInteger subjectId;
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic) NSUInteger courseId;
@property (readwrite, nonatomic) NSUInteger professorId;
@property (readwrite, nonatomic) NSUInteger semester;
@property (readwrite, nonatomic) NSUInteger registNum;
@property (readwrite, nonatomic, retain) NSString *location;
@property (readwrite, nonatomic, retain) NSDate *updateDate;

@end

@implementation Subject

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _subjectId = [data[SUBJECT_ID] intValue];
        _name = data[NAME];
        _courseId = [data[COURSE_ID] intValue];
        _professorId = [data[PROFESSOR_ID] intValue];
        _semester = [data[SEMESTER] intValue];
        _registNum = [data[REGIST_NUM] intValue];
        _location = data[LOCATION];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (Subject *)findById:(NSUInteger)subjectId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:subjectId], nil];
    return [TimeTableSqliteDB databaseQuery:^id(FMResultSet *rs) {
        return [self createModel:rs];
    }
                                        sql:@"select * from subject where subject_id= ?"
                                       args:args];
}

+ (Subject *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{SUBJECT_ID:[rs stringForColumn:SUBJECT_ID],
                           NAME:[rs stringForColumn:NAME],
                           COURSE_ID:[rs stringForColumn:COURSE_ID],
                           PROFESSOR_ID:[rs stringForColumn:PROFESSOR_ID],
                           SEMESTER:[rs stringForColumn:SEMESTER],
                           REGIST_NUM:[rs stringForColumn:REGIST_NUM],
                           LOCATION:[rs stringForColumn:LOCATION],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[Subject alloc] initWithData:data];
}

- (Course *)getCourse {
    return [Course findById:self.courseId];
}

- (Professor *)getProfessor {
    return [Professor findById:self.professorId];
}

+ (NSMutableArray *)getSubjectListWithSemester:(NSUInteger)semester
                                      courseId:(NSUInteger)courseId  {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:semester], [NSNumber numberWithInt:courseId], nil];
    return [TimeTableSqliteDB databaseQueryList:^id(FMResultSet *rs) {
        return [self createModel:rs];
    }
                                            sql:@"select * from subject where semester = ? and course_id = ?"
                                           args:args];
}

+ (NSUInteger)getSubjectCountWithSemester:(NSUInteger)semester
                                 courseId:(NSUInteger)courseId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:semester], [NSNumber numberWithInt:courseId], nil];
    return [TimeTableSqliteDB databaseQueryCount:@"select count(subject_id) from subject where semester = ? and course_id = ?"
                                            args:args];
}

@end
