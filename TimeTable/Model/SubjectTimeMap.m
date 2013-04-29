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
@property (readwrite, nonatomic) NSUInteger time;
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
        _time = [data[TIME] intValue];
        _practice = [data[PRACTICE] boolValue];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (SubjectTimeMap *)findById:(NSUInteger)subjectTimeMapId {
    return [TimeTableSqliteDB databaseQuery:[self class]
                                        sql:@"select * from subject_time_map where subject_time_map_id=?"
                                firstObject:[NSNumber numberWithInt:subjectTimeMapId], nil];
}

+ (SubjectTimeMap *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{SUBJECT_TIME_MAP_ID:[rs stringForColumn:SUBJECT_TIME_MAP_ID],
                           SUBJECT_ID:[rs stringForColumn:SUBJECT_ID],
                           DAY:[rs stringForColumn:DAY],
                           TIME:[rs stringForColumn:TIME],
                           PRACTICE:[NSNumber numberWithBool:[rs boolForColumn:PRACTICE]],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[SubjectTimeMap alloc] initWithData:data];
}

- (Subject *)getSubject {
    return [Subject findById:self.subjectId];
}

+ (NSMutableArray *)getSubjectTimeMapList:(NSUInteger)subjectId {
    return [TimeTableSqliteDB databaseQueryList:[self class]
                                            sql:@"select * from subject_time_map where subject_id = ?"
                                    firstObject:[NSNumber numberWithInt:subjectId], nil];
}


@end
