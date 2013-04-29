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

+ (Course *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{COURSE_ID:[rs stringForColumn:COURSE_ID],
                           NAME:[rs stringForColumn:NAME],
                           CLASS_NUM:[rs stringForColumn:CLASS_NUM]};
    return [[Course alloc] initWithData:data];
}

+ (Course *)findById:(NSUInteger)courseId {
    return [TimeTableSqliteDB databaseQuery:[self class]
                                        sql:@"select * from course where course_id = ?"
                                firstObject:[NSNumber numberWithInt:courseId], nil];
}

+ (NSUInteger)getCourseCount {
    return [TimeTableSqliteDB databaseQueryCount:@"select count(course_id) from course" firstObject:nil, nil];
}

@end
