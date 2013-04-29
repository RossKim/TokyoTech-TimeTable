//
//  TimeTableNotificationUtil.h
//  TimeTable
//
//  Created by Kim Minsu on 2013/04/29.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTableNotificationUtil : NSObject

+ (void)alertWithMessage:(NSString *)title message:(NSString *)message;
+ (void)alertDBError;

@end
