//
//  TimeTableSubjectListViewController.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/03.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableSubjectListViewController.h"
#import "TimeTableSubjectDetailViewController.h"
#import "ListViewModel.h"

@interface TimeTableSubjectListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ListViewModel *viewModel;
@end

@implementation TimeTableSubjectListViewController

- (ListViewModel *)viewModel{
    if(!_viewModel) {
        _viewModel = [[ListViewModel alloc] initWithMode:[Subject class]
                                        selectedCourseId:self.selectedCourseId];
    }
    return _viewModel;
}

#pragma mark - TableView Delegate Methods
- (NSUInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sectionCount;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.viewModel sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForHeaderInSection:section];
}

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.viewModel.cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.viewModel.cellIdentifier];
    }
    
    id contents = [self.viewModel cellContentsForRowAtIndexPath:indexPath];
    if([contents isKindOfClass:[Subject class]]) {
        Subject *subject = (Subject *)contents;
        cell.textLabel.text = subject.name;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowSubjectDetail"]) {
        TimeTableSubjectDetailViewController *subjectDetailViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        id contents = [self.viewModel cellContentsForRowAtIndexPath:myIndexPath];
        if([contents isKindOfClass:[Subject class]]) {
            Subject *subject = (Subject *)contents;
            subjectDetailViewController.selectedSubject = subject;
        }
        [self.tableView deselectRowAtIndexPath:myIndexPath animated:NO];
    }
}

@end
