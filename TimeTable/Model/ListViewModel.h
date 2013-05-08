//
//  ListViewModel.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/03.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Subject.h"

@interface ListViewModel : NSObject

@property (nonatomic) NSUInteger sectionCount;
@property (strong, nonatomic) id model;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (nonatomic) NSUInteger selectedCourseId;
#define COURSE_CELL @"CourseCell"
#define SUBJECT_CELL @"SubjectCell"

- (id)initWithMode:(id)model selectedCourseId:(NSUInteger)selectedCourseId;
- (NSArray *)sectionIndexTitles;
- (NSString *)titleForHeaderInSection:(NSUInteger)section;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (id)cellContentsForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
