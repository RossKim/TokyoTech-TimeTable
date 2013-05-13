//
//  TimeTableModelView.m
//  TimeTable
//
//  Created by Kim Minsu on 2013/05/09.
//  Copyright (c) 2013年 Kim Minsu. All rights reserved.
//

#import "TimeTableModelView.h"

@implementation TimeTableModelView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawContents];
}

- (void)drawContents {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * 0.15];
    NSString *contents = [self.model getSubject].name;
    NSString *newContents = @"";
    if([contents sizeWithFont:font].width > self.bounds.size.width) {
        for(int i=0;i<[contents length];i+=3) {
            NSRange r;
            r.location = i;
            if(i+3 >= [contents length]) {
                r.length = [contents length] - i;
            } else {
                r.length = 3;
            }
            newContents = [newContents stringByAppendingFormat:@"%@\n",[contents substringWithRange:r]];
        }
    } else {
        newContents = contents;
    }
    NSLog(@"%@",newContents);
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:newContents attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(self.bounds.size.width/2-[text size].width/2, self.bounds.size.height/2-[text size].height/2);
    textBounds.size = [text size];
    [text drawInRect:textBounds];
    
}

- (void)setModel:(TimeTableModel *)model {
    _model = model;
    [self setNeedsDisplay];
}

@end
