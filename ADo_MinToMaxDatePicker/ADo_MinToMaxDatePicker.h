//
//  ADo_MinToMaxDatePicker.h
//
//  Created by 杜维欣 on 15/11/4.
//  Copyright © 2015年 杜维欣. All rights reserved.
//

/**    使用方法
 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 [formatter setDateFormat:@"yyyyMM"];
 NSString *datemin = @"200807";
 NSDate *date = [formatter dateFromString:datemin];
 
 ADo_DateModel *max = [[ADo_DateModel alloc] initWithDate:[NSDate date] style:YEAR_MONTH_NONE];
 ADo_DateModel *min = [[ADo_DateModel alloc] initWithDate:date style:YEAR_MONTH_NONE];
 ADo_MinToMaxDatePicker *pick = [[ADo_MinToMaxDatePicker alloc] initWithMaxDate:max minDate:min];
 __weak typeof(self) weakSelf = self;
 [pick showWithBlock:^(ADo_DateModel *model) {
 weakSelf.dateLabel.text = [NSString stringWithFormat:@"%@年-%@月-%@日",model.year,model.month,model.day];
 }];
 */

#import <UIKit/UIKit.h>
#import "ADo_DateModel.h"


typedef void(^DateBlock)(ADo_DateModel *model);

@interface ADo_MinToMaxDatePicker : UIView

//初始化对象  传两个日期  日期的style 必须一致  maxdate 必须大于 mindate
//outDate 是否有已过期选项

- (instancetype)initWithMaxDate:(ADo_DateModel *)maxDate minDate:(ADo_DateModel *)minDate outDate:(BOOL)outDate;

//显示  点击确定  block把最终的日期传出来

- (void)showWithBlock:(DateBlock)dateBlcok;

//正序 yes 2014 2015...     倒叙no 2015 2014...
@property (nonatomic,assign)BOOL inOrder;

//标题栏名称
@property (nonatomic,copy)NSString *titleName;


@end