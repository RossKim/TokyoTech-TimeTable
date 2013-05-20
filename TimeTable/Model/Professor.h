//
//  Professor.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/30.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTableSqliteDB.h"

@class Course;

@interface Professor : NSObject<SqliteModel>

@property (readonly, nonatomic) NSUInteger professorId;
@property (readonly, nonatomic, retain) NSString *lastName;
@property (readonly, nonatomic, retain) NSString *firstName;
@property (readonly, nonatomic) NSUInteger courseId;
@property (readonly, nonatomic, retain) NSDate *updateDate;

+ (Professor *)findById:(NSUInteger)professorId;
- (Course *)getCourse;
- (NSString *)getName;

@end
