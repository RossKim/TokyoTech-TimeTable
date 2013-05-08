//
//  TimeTableSubjectDetailViewController.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/03.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableSubjectDetailViewController.h"
#import "Course.h"
#import "Professor.h"
#import "SubjectTimeMap.h"
#import "TimeTableNotificationUtil.h"
#import "TimeTableViewController.h"

@interface TimeTableSubjectDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *professorLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *registNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerSubjectButton;
@property (weak, nonatomic) IBOutlet UITextView *timeTextView;
#define REGISTER_TEXT @"登録"
#define UNREGISTER_TEXT @"登録解除"
@end

@implementation TimeTableSubjectDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    self.nameTextView.text = self.selectedSubject.name;
    self.courseLabel.text = [self.selectedSubject getCourse].name;
    self.professorLabel.text = [[self.selectedSubject getProfessor] getName];
    self.semesterLabel.text = [[NSNumber numberWithInt:self.selectedSubject.semester] stringValue];
    self.locationLabel.text = self.selectedSubject.location;
    self.registNumLabel.text = [[NSNumber numberWithInt:self.selectedSubject.registNum] stringValue];
    self.timeTextView.text = [self.selectedSubject getTimeString];
    if([TimeTableModel isSubjectRegistered:self.selectedSubject.subjectId]) {
        [self.registerSubjectButton setTitle:UNREGISTER_TEXT forState:UIControlStateNormal];
    } else {
        [self.registerSubjectButton setTitle:REGISTER_TEXT forState:UIControlStateNormal];
    }
}

- (IBAction)registerSubject:(UIButton *)sender {
    NSString *message;
    if([self.registerSubjectButton.titleLabel.text isEqualToString:REGISTER_TEXT]) {
        NSString *result = [self.selectedSubject registerSubject];
        if([result isEqualToString:@"Success"]) {
            message = @"登録完了";
        } else if([result isEqualToString:@"Error"]){
            message = @"登録失敗";
        } else if([result isEqualToString:@"Duplicate"]) {
            message = @"この時間帯には既に他の科目が登録されています。";
        }
        [TimeTableNotificationUtil alertWithMessage:@"登録" message:message];
    } else if([self.registerSubjectButton.titleLabel.text isEqualToString:UNREGISTER_TEXT]) {
        if([self.selectedSubject unregisterSubject]) {
            message = @"登録解除完了";
        } else {
            message = @"登録解除失敗";
        }
        [TimeTableNotificationUtil alertWithMessage:@"登録解除" message:message];
    }
    [self updateUI];
}

@end
