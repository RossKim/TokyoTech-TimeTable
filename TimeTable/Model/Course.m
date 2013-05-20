//
//  CourseModel.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/29.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "Course.h"

@interface Course()
@property (readwrite, nonatomic) NSUInteger courseId;
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic) NSUInteger classNum;
@end

@implementation Course

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _courseId = [data[COURSE_ID] intValue];
        _name = data[NAME];
        _classNum = [data[CLASS_NUM] intValue];
    }
    return self;
}

- (id)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{COURSE_ID:[rs stringForColumn:COURSE_ID],
                           NAME:[rs stringForColumn:NAME],
                           CLASS_NUM:[rs stringForColumn:CLASS_NUM]};
    return [[Course alloc] initWithData:data];
}

+ (Course *)findById:(NSUInteger)courseId {

    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:courseId], nil];
    return [TimeTableSqliteDB databaseQuery:(id<SqliteModel>)self
                                        sql:@"select * from course where course_id = ?"
                                       args:args];
}

+ (NSUInteger)getCourseCount {
    return [TimeTableSqliteDB databaseQueryCount:@"select count(course_id) from course" args:nil];
}

+ (NSMutableArray *)getCourseListWithClassNum:(NSUInteger)classNum {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:classNum], nil];
    return [TimeTableSqliteDB databaseQueryList:(id<SqliteModel>)self
                                        sql:@"select * from course where class=?"
                                       args:args];
}

+ (NSUInteger)getCourseCountWithClassNum:(NSUInteger)classNum {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:classNum], nil];
    return [TimeTableSqliteDB databaseQueryCount:@"select count(*) from course where class=?"
                                            args:args];
}

@end
