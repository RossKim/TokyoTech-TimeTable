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
@property (readwrite, nonatomic) NSUInteger time;
@property (readwrite, nonatomic, retain) NSDate *updateDate;

@end

@implementation TimeTableModel

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if(self) {
        _timeTableId = [data[TIMETABLE_ID] intValue];
        _subjectId = [data[SUBJECT_ID] intValue];
        _day = [data[DAY] intValue];
        _time = [data[TIME] intValue];
        _updateDate = data[UPDATE_DATE];
    }
    return self;
}

+ (TimeTableModel *)findById:(NSUInteger)timeTableId {
    return [TimeTableSqliteDB databaseQuery:[self class] sql:@"select * from timetable where timetable_id=?" firstObject:[NSNumber numberWithInt:timeTableId], nil];
}

- (Subject *)getSubject {
    return [Subject findById:self.subjectId];
}

+ (TimeTableModel *)createModel:(FMResultSet *)rs {
    NSDictionary *data = @{TIMETABLE_ID:[rs stringForColumn:TIMETABLE_ID],
                           SUBJECT_ID:[rs stringForColumn:SUBJECT_ID],
                           DAY:[rs stringForColumn:DAY],
                           TIME:[rs stringForColumn:TIME],
                           UPDATE_DATE:[rs dateForColumn:UPDATE_DATE]};
    return [[TimeTableModel alloc] initWithData:data];
}


@end
