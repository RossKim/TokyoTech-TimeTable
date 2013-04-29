//
//  TimeTableNotificationUtil.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/29.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableNotificationUtil.h"

@implementation TimeTableNotificationUtil

+ (void)alertWithMessage:(NSString*)title message:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)alertDBError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Fail to connect DB"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
