//
//  TimeTableListViewController.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/29.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableListViewController.h"
#import "Course.h"
#import "Subject.h"

@interface TimeTableListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSUInteger sectionCount;
@property (strong, nonatomic) id model;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (nonatomic) NSUInteger selectedCourseId;
#define COURSE_CELL @"CourseCell"
#define SUBJECT_CELL @"SubjectCell"
@end

@implementation TimeTableListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self setCourseMode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods
- (NSUInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([self.model isEqual:[Course class]]) {
        return [NSString stringWithFormat:@"%d類",section+1];
    } else if([self.model isEqual:[Subject class]]) {
        return [NSString stringWithFormat:@"%d学期",section+1];
    }
    return nil;
}

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.model isEqual:[Course class]]) {
        return [Course getCourseCountWithClassNum:section+1];
    } else if([self.model isEqual:[Subject class]]) {
        return [Subject getSubjectCountWithSemester:section+1 courseId:self.selectedCourseId];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.cellIdentifier];
    }
    
    if([self.model isEqual:[Course class]]) {
        NSMutableArray *list = [Course getCourseListWithClassNum:indexPath.section+1];
        if(list) {
            Course *course = [list objectAtIndex:indexPath.row];
            cell.textLabel.text = course.name;
        }
    } else if([self.model isEqual:[Subject class]]) {
        NSMutableArray *list = [Subject getSubjectListWithSemester:indexPath.section+1 courseId:self.selectedCourseId];
        if(list) {
            Subject *subject = [list objectAtIndex:indexPath.row];
            cell.textLabel.text = subject.name;
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.model isEqual:[Course class]]) {
        NSMutableArray *array = [Course getCourseListWithClassNum:indexPath.section+1];
        if(array) {
            Course *selectedCourse = [array objectAtIndex:indexPath.row];
            [self setSubjectMode:selectedCourse.courseId];
            [UIView transitionWithView:self.tableView duration:1.00f options:UIViewAnimationOptionTransitionFlipFromRight   animations:^{
                [self.tableView setContentOffset:CGPointZero animated:NO];
                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickBackButton)];
                self.navigationItem.leftBarButtonItem = backButton;
                [self.tableView reloadData];
            } completion:^(BOOL finished) {
            }];
        }
    } else if([self.model isEqual:[Subject class]]) {
        
    }
}

- (IBAction)onClickBackButton {
    if([self.model isEqual:[Subject class]]) {
        [self setCourseMode];
        [UIView transitionWithView:self.tableView duration:1.00f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [self.tableView setContentOffset:CGPointZero animated:NO];
            self.navigationItem.leftBarButtonItem = nil;
            [self.tableView reloadData];
        } completion:^(BOOL finished) {
        }];
    }
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
