//
//  TimeTableSubjectListViewController.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/03.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableSubjectListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSUInteger selectedCourseId;

@end
