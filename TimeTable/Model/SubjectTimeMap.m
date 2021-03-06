//
//  SubjectTimeMap.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "SubjectTimeMap.h"

@interface SubjectTimeMap()

@property (readwrite, nonatomic) NSUInteger subjectTimeMapId;
@property (readwrite, nonatomic) NSUInteger subjectId;
@property (readwrite, nonatomic) NSUInteger day;
@property (readwrite, nonatomic) NSUInteger startTime;
@property (readwrite, nonatomic) NSUInteger endTime;
@property (readwrite, nonatomic) BOOL practice;
@property (readwrite, nonatomic, retain) NSDate *updateDate;

@end

@implementation SubjectTimeMap

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _subjectTimeMapId = [data[SUBJECT_TIME_MAP_ID] intValue];
        _subjectId = [data[SUBJECT_ID] intValue];
        _day = [data[DAY] intValue];
        _startTime = [data[START_TIME] intValue];
        _endTime = [data[END_TIME] intValue];
        _practice = [data[PRACTICE] boolValue];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (SubjectTimeMap *)findById:(NSUInteger)subjectTimeMapId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:subjectTimeMapId], nil];
    return [TimeTableSqliteDB databaseQuery:(id<SqliteModel>)self
                                        sql:@"select * from subject_time_map where subject_time_map_id=?"
                                       args:args];
}

- (id)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{SUBJECT_TIME_MAP_ID:[rs stringForColumn:SUBJECT_TIME_MAP_ID],
                           SUBJECT_ID:[rs stringForColumn:SUBJECT_ID],
                           DAY:[rs stringForColumn:DAY],
                           START_TIME:[rs stringForColumn:START_TIME],
                           END_TIME:[rs stringForColumn:END_TIME],
                           PRACTICE:[NSNumber numberWithBool:[rs boolForColumn:PRACTICE]],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[SubjectTimeMap alloc] initWithData:data];
}

- (Subject *)getSubject {
    return [Subject findById:self.subjectId];
}

+ (NSMutableArray *)getSubjectTimeMapList:(NSUInteger)subjectId {
    NSArray *args = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:subjectId], nil];
    return [TimeTableSqliteDB databaseQueryList:(id<SqliteModel>)self
                                            sql:@"select * from subject_time_map where subject_id = ?"
                                           args:args];
}
@end
