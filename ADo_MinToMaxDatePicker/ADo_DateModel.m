
//
//  ADo_DateModel.m
//
//  Created by 杜维欣 on 15/11/4.
//  Copyright © 2015年 杜维欣. All rights reserved.
//

#import "ADo_DateModel.h"

static NSDateFormatter *adoFormatter = nil;

@implementation ADo_DateModel

- (instancetype)initWithDate:(NSDate *)date style:(DateStyle)style;
{
    self = [super init];
    if (self) {
        if (!adoFormatter) {
            adoFormatter = [[NSDateFormatter alloc]init];
        }
        
        if (style == YEAR_MONTH_DAY) {
            [adoFormatter setDateFormat:@"yyyyMMdd"];
        }else if (style == YEAR_MONTH_NONE)
        {
            [adoFormatter setDateFormat:@"yyyyMM"];
        }
        NSString *dateString = [adoFormatter stringFromDate:date];
        self.year     = [dateString substringWithRange:NSMakeRange(0, 4)];
        self.month    = [dateString substringWithRange:NSMakeRange(4, 2)];
        if (style == YEAR_MONTH_DAY) {
            self.day = [dateString substringWithRange:NSMakeRange(6, 2)];
        }else if (style == YEAR_MONTH_NONE)
        {
            self.day = nil;
        }
        self.style = style;
    }
    return self;
}
@end
