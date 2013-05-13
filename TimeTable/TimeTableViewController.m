//
//  TimeTableViewController.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/04.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableSqliteDB.h"
#import "TimeTableSubjectDetailViewController.h"
#import "TimeTableNotificationUtil.h"
#import "TimeTableModelView.h"

@interface TimeTableViewController ()
#define TIMETABLE_CELL @"TimeTableCell"
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TimeTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"解除" style:UIBarButtonItemStylePlain target:self action:@selector(enableEditMode)] animated:YES];
}

- (void)enableEditMode {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing) {
        [self.navigationItem.leftBarButtonItem setTitle:@"終了"];
    } else {
        [self.navigationItem.leftBarButtonItem setTitle:@"解除"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods
- (NSUInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for(int i=1;i<=7;i++) {
        [titles addObject:[NSString stringWithFormat:@"%@曜日",[TimeTableSqliteDB getDay][i]]];
    }
    return titles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@曜日",[TimeTableSqliteDB getDay][section+1]];
}

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TimeTableModel getRegisteredSubjectCountWithDay:section+1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TIMETABLE_CELL];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:TIMETABLE_CELL];
    }
    
    NSMutableArray *list = [TimeTableModel getRegisteredSubjectArrayWithDay:indexPath.section+1];
    if(list) {
        TimeTableModel *model = [list objectAtIndex:indexPath.row];
        cell.textLabel.text = [model getSubject].name;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowSubjectDetail"]) {
        TimeTableSubjectDetailViewController *subjectDetailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *list = [TimeTableModel getRegisteredSubjectArrayWithDay:myIndexPath.section+1];
        TimeTableModel *model = nil;
        if(list) {
            model = [list objectAtIndex:myIndexPath.row];
            subjectDetailViewController.selectedSubject = [model getSubject];
        }
        [self.tableView deselectRowAtIndexPath:myIndexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *list = [TimeTableModel getRegisteredSubjectArrayWithDay:indexPath.section+1];
        if(list) {
            TimeTableModel *model = [list objectAtIndex:indexPath.row];
            Subject *subject = [model getSubject];
            if(subject) {
                NSString *message = @"";
                if([subject unregisterSubject]) {
                    message = @"登録解除完了";
                } else {
                    message = @"登録解除失敗";
                }
                [TimeTableNotificationUtil alertWithMessage:@"登録解除" message:message];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"解除";
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        TimeTableModelView *view = [[TimeTableModelView alloc] init];
        for(int i=1;i<=100;i++) {
            TimeTableModel *model = [TimeTableModel findById:i];
            if(model) {
                view.model = model;
                break;
            }
        }
        self.view = view;
    } else {
        self.view = self.tableView;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight || fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [self.tableView setNeedsDisplay];
    } else {
    }
}

@end
