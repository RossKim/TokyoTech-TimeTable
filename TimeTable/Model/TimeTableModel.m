//
//  TimeTableModel.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableModel.h"

@interface TimeTableModel()

@property (readwrite, nonatomic) NSUInteger timeTableId;
@property (readwrite, nonatomic) NSUInteger subjectId;
@property (readwrite, nonatomic) NSUInteger day;
@property (readwrite, nonatomic) NSUInteger startTime;
@property (readwrite, nonatomic) NSUInteger endTime;
@property (readwrite, nonatomic, retain) NSDate *updateDate;

@end

@implementation TimeTableModel

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _timeTableId = [data[TIMETABLE_ID] intValue];
        _subjectId = [data[SUBJECT_ID] intValue];
        _day = [data[DAY] intValue];
        _startTime = [data[START_TIME] intValue];
        _endTime = [data[END_TIME] intValue];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (TimeTableModel *)findById:(NSUInteger)timeTableId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:timeTableId], nil];
    return [TimeTableSqliteDB databaseQuery:^id(FMResultSet *rs) {
        return [self createModel:rs];
    }
                                        sql:@"select * from timetable where timetable_id=?"
                                       args:args];
}

+ (TimeTableModel *)findBySubjectId:(NSUInteger)subjectId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:subjectId], nil];
    return [TimeTableSqliteDB databaseQuery:^id(FMResultSet *rs) {
        return [self createModel:rs];
    }
                                        sql:@"select * from timetable where subject_id=?"
                                       args:args];
}

+ (BOOL)isSubjectRegistered:(NSUInteger)subjectId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:subjectId], nil];
    return [TimeTableSqliteDB databaseQueryCount:@"select count(timetable_id) from timetable where subject_id = ?"
                                            args:args];
}

+ (NSUInteger)getRegisteredSubjectCountWithDay:(NSUInteger)day {
    return [TimeTableSqliteDB databaseQueryCount:@"select count(timetable_id) from timetable where day=?" args:@[[NSNumber numberWithInt:day]]];
}

+ (NSMutableArray *)getRegisteredSubjectArrayWithDay:(NSUInteger)day {
    return [TimeTableSqliteDB databaseQueryList:^id(FMResultSet *rs) {
        return [self createModel:rs];
    }
                                            sql:@"select * from timetable where day=? order by start_time asc"
                                           args:@[[NSNumber numberWithInt:day]]];
}

- (Subject *)getSubject {
    return [Subject findById:self.subjectId];
}

+ (TimeTableModel *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{TIMETABLE_ID:[rs stringForColumn:TIMETABLE_ID],
                           SUBJECT_ID:[rs stringForColumn:SUBJECT_ID],
                           DAY:[rs stringForColumn:DAY],
                           START_TIME:[rs stringForColumn:START_TIME],
                           END_TIME:[rs stringForColumn:END_TIME],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[TimeTableModel alloc] initWithData:data];
}

@end
