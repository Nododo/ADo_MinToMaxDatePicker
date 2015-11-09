//
//  ADo_DateModel.h
//
//  Created by 杜维欣 on 15/11/4.
//  Copyright © 2015年 杜维欣. All rights reserved.
//

#import <Foundation/Foundation.h>

//目前只支持这两种格式

typedef enum : NSUInteger {
    YEAR_MONTH_DAY,//20080808 - 20151111 年份四位数  月和日 两位
    YEAR_MONTH_NONE,//200808 - 201511
} DateStyle;


@interface ADo_DateModel : NSObject

//属性

@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *month;
@property (nonatomic, retain) NSString *day;
@property (nonatomic,assign ) DateStyle style;

//初始化对象   根据style创建日期

- (instancetype)initWithDate:(NSDate *)date style:(DateStyle)style;

@end
