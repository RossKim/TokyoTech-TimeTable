//
//  ListViewModel.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/03.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "ListViewModel.h"

@implementation ListViewModel

//designated initializer
- (id)initWithMode:(id)model selectedCourseId:(NSUInteger)selectedCourseId {
    self = [super init];
    if(self) {
        if ([model isEqual:[Course class]]) {
            _sectionCount = 7;
            _model = model;
            _cellIdentifier = COURSE_CELL;
            _selectedCourseId = 0;
        } else if([model isEqual:[Subject class]]) {
            _sectionCount = 8;
            _model = model;
            _cellIdentifier = SUBJECT_CELL;
            _selectedCourseId = selectedCourseId;
        }
    }
    return self;
}

- (NSArray *)sectionIndexTitles {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([self.model isEqual:[Course class]]) {
        for(int i=1;i<=7;i++) {
            [array addObject:[NSString stringWithFormat:@"%d類",i]];
        }
    } else if([self.model isEqual:[Subject class]]) {
        for(int i=1;i<=8;i++) {
            [array addObject:[NSString stringWithFormat:@"%d学期",i]];
        }
    }
    return array;
}

- (NSString *)titleForHeaderInSection:(NSUInteger)section {
    if([self.model isEqual:[Course class]]) {
        return [NSString stringWithFormat:@"%d類",section+1];
    } else if([self.model isEqual:[Subject class]]) {
        return [NSString stringWithFormat:@"%d学期",section+1];
    }
    return nil;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    if([self.model isEqual:[Course class]]) {
        return [Course getCourseCountWithClassNum:section+1];
    } else if([self.model isEqual:[Subject class]]) {
        return [Subject getSubjectCountWithSemester:section+1
                                           courseId:self.selectedCourseId];
    }
    return 0;
}

- (id)cellContentsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.model isEqual:[Course class]]) {
        NSMutableArray *list = [Course getCourseListWithClassNum:indexPath.section+1];
        if(list) {
            Course *course = [list objectAtIndex:indexPath.row];
            return course;
        }
    } else if([self.model isEqual:[Subject class]]) {
        NSMutableArray *list = [Subject getSubjectListWithSemester:indexPath.section+1 courseId:self.selectedCourseId];
        if(list) {
            Subject *subject = [list objectAtIndex:indexPath.row];
            return subject;
        }
    }
    return nil;
}

- (void)setCourseMode {
    self.sectionCount = 7;
    self.model = [Course class];
    self.cellIdentifier = COURSE_CELL;
    self.selectedCourseId = 0;
}

- (void)setSubjectMode:(NSUInteger)courseId {
    self.sectionCount = 8;
    self.model = [Subject class];
    self.cellIdentifier = SUBJECT_CELL;
    self.selectedCourseId = courseId;
}

@end
