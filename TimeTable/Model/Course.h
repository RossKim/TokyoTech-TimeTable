//
//  CourseModel.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/29.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeTableSqliteDB.h"

@interface Course : NSObject

#define COURSE_ID @"course_id"
#define NAME @"name"
#define CLASS_NUM @"class"

@property (readonly, nonatomic) NSUInteger courseId;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic) NSUInteger classNum;

+ (Course *)findById:(NSUInteger)courseId;
+ (NSUInteger)getCourseCount;
+ (Course *)createModel:(FMResultSet *)rs;

@end
