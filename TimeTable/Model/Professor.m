//
//  Professor.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "Professor.h"

@interface Professor()

@property (readwrite, nonatomic) NSUInteger professorId;
@property (readwrite, nonatomic, retain) NSString *lastName;
@property (readwrite, nonatomic, retain) NSString *firstName;
@property (readwrite, nonatomic) NSUInteger courseId;
@property (readwrite, nonatomic, retain) NSDate *updateDate;

@end

@implementation Professor

#define PROFESSOR_ID @"professor_id"
#define LAST_NAME @"last_name"
#define FIRST_NAME @"first_name"
#define COURSE_ID @"course_id"
#define UPDATE_DATE @"update_date"

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _professorId = [data[PROFESSOR_ID] intValue];
        _lastName = data[LAST_NAME];
        _firstName = data[FIRST_NAME];
        _courseId = [data[COURSE_ID] intValue];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (Professor *)findById:(NSUInteger)professorId {
    return [TimeTableSqliteDB databaseQuery:[self class]
                                        sql:@"select * from professor where professor_id = ?"
                                firstObject:[NSNumber numberWithInt:professorId], nil];
}

+ (Professor *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{PROFESSOR_ID:[rs stringForColumn:PROFESSOR_ID],
                           LAST_NAME:[rs stringForColumn:LAST_NAME],
                           FIRST_NAME:[rs stringForColumn:FIRST_NAME],
                           COURSE_ID:[rs stringForColumn:COURSE_ID],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[Professor alloc] initWithData:data];
}

- (Course *)getCourse {
    return [Course findById:self.courseId];
}

- (NSString *)getName {
    return [NSString stringWithFormat:@"%@ %@", self.lastName, self.firstName];
}

@end
