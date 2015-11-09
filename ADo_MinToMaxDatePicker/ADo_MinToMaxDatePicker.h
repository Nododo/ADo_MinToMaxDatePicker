//
//  ADo_MinToMaxDatePicker.h
//
//  Created by 杜维欣 on 15/11/4.
//  Copyright © 2015年 杜维欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADo_DateModel.h"


typedef void(^DateBlock)(ADo_DateModel *model);

@interface ADo_MinToMaxDatePicker : UIView

//初始化对象  传两个日期  日期的style 必须一致  maxdate 必须大于 mindate

- (instancetype)initWithMaxDate:(ADo_DateModel *)maxDate minDate:(ADo_DateModel *)minDate;

//显示  点击确定  block把最终的日期传出来

- (void)showWithBlock:(DateBlock)dateBlcok;

@end
