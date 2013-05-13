//
//  TimeTableModelViewController.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/09.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableModelViewController.h"
#import "TimeTableModelView.h"
#import "TimeTableModel.h"

@interface TimeTableModelViewController ()
@property (strong, nonatomic) IBOutletCollection(TimeTableModelView) NSArray *modelViewCollection;
@end

@implementation TimeTableModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setModelViewCollection:(NSArray *)modelViewCollection {
    _modelViewCollection = modelViewCollection;
    for(TimeTableModelView *view in _modelViewCollection) {
        for(int i=1;i<=100;i++) {
            TimeTableModel *model = [TimeTableModel findById:i];
            if(model) {
                view.model = model;
                break;
            }
        }
    }
}

@end
