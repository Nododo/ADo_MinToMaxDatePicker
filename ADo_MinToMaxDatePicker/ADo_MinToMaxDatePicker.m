//
//  ADo_MinToMaxDatePicker.m
//
//  Created by 杜维欣 on 15/11/4.
//  Copyright © 2015年 杜维欣. All rights reserved.
//

#import "ADo_MinToMaxDatePicker.h"

#define WINDOW ([UIApplication sharedApplication].keyWindow)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define kDatePickerH 270.f
#define kPaddingW 10.f
#define kPaddingH 10.f
#define kButtonW 40.f
#define kButtonH 25.f
static  float animationDuration = .3f;
static  float initAlpha = .3f;
static  float finalAlpha = .8f;

@interface ADo_MinToMaxDatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

//数据部分
@property (nonatomic,strong)ADo_DateModel *maxDate;
@property (nonatomic,strong)ADo_DateModel *minDate;
@property (nonatomic,strong)NSMutableArray *years;
@property (nonatomic,strong)NSMutableArray *months;
@property (nonatomic,strong)NSMutableArray *days;
@property (nonatomic,copy)DateBlock dateBlock;

//保留处理的每个部分的index
@property (nonatomic,assign)int yearIndex;
@property (nonatomic,assign)int monthIndex;
@property (nonatomic,assign)int dayIndex;

//试图部分
@property (nonatomic,weak)UIView *bottomView;
@property (nonatomic,weak)UIPickerView *dateView;

@end



@implementation ADo_MinToMaxDatePicker

//懒加载部分

- (NSMutableArray *)years
{
    if (!_years) {
        self.years = [NSMutableArray array];
    }
    return _years;
}


- (NSMutableArray *)months
{
    if (!_months) {
        self.months = [NSMutableArray array];
    }
    return _months;
}

- (NSMutableArray *)days
{
    if (!_days) {
        self.days = [NSMutableArray array];
    }
    return _days;
}


//初始化

- (instancetype)initWithMaxDate:(ADo_DateModel *)maxDate minDate:(ADo_DateModel *)minDate
{
    NSAssert(maxDate.style == minDate.style , @"the model's style must be same");
    self = [super init];
    if (self) {
        self.maxDate = maxDate;
        self.minDate = minDate;
        [self setup];
        [self configureData];
    }
    return self;
}

//布局

- (void)setup
{
    self.frame = WINDOW.bounds;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = initAlpha;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kDatePickerH);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(kPaddingW, kPaddingH, kButtonW, kButtonH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.frame = CGRectMake(kScreenWidth - kPaddingW - kButtonW, kPaddingH, kButtonW, kButtonH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    
    UIPickerView *dateView = [[UIPickerView alloc] init];
    dateView.frame = CGRectMake(0, CGRectGetMaxY(confirmBtn.frame) + kPaddingH, kScreenWidth, kDatePickerH);
    dateView.dataSource = self;
    dateView.delegate = self;
    [bottomView addSubview:dateView];
    self.dateView = dateView;
}

//显示  动画 事件处理

- (void)showWithBlock:(DateBlock)dateBlcok
{
    [WINDOW addSubview:self];
    self.dateBlock = dateBlcok;
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -kDatePickerH);
        self.alpha = finalAlpha;
    }];
}

- (void)cancel:(UIButton *)btn
{
    [self dismiss];
}

- (void)confirm:(UIButton *)btn
{
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
    DateStyle tempStyle = self.maxDate.style;
    NSString *finalStr;
    if (tempStyle == YEAR_MONTH_DAY) {
        [tempFormatter setDateFormat:@"yyyyMMdd"];
        finalStr  = [NSString stringWithFormat:@"%d%02d%02d",[self.years[self.yearIndex] intValue],[self.months[self.monthIndex] intValue],[self.days[self.dayIndex] intValue]];
    }else
    {
        [tempFormatter setDateFormat:@"yyyyMM"];
        finalStr  = [NSString stringWithFormat:@"%d%02d",[self.years[self.yearIndex] intValue],[self.months[self.monthIndex] intValue]];
    }
    NSDate *finalDate = [tempFormatter dateFromString:finalStr];
    ADo_DateModel *finalModel = [[ADo_DateModel alloc] initWithDate:finalDate style:self.maxDate.style];
    if (self.dateBlock) {
        self.dateBlock(finalModel);
    }
    [self dismiss];
}

- (void)dismiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

//UIPickerView代理部分

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.maxDate.style == YEAR_MONTH_DAY) {
        return 3;
    }else if (self.maxDate.style == YEAR_MONTH_NONE)
    {
        return 2;
    }
    return 0;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.maxDate.style == YEAR_MONTH_DAY)
    {
        if (component == 0) {
            return self.years.count;
        }else if (component == 1)
        {
            return self.months.count;
        }else
        {
            return self.days.count;
        }
    }else if (self.maxDate.style == YEAR_MONTH_NONE)
    {
        if (component == 0) {
            return self.years.count;
        }else if (component == 1)
        {
            return self.months.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.years[row];
    }else if (component == 1)
    {
        return self.months[row];
    }else if (component == 2)
    {
        return self.days[row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.yearIndex = (int)row;
        [self monthsFromYear:[self.years[self.yearIndex] intValue]];
        if (self.monthIndex >= self.months.count) {//暂时没有想到更好的处理办法 处理最大年份上一年 月数越界
            self.monthIndex = 0;
        }
        [self daysFromYear:[self.years[self.yearIndex] intValue] andMonth:[self.months[self.monthIndex] intValue]];
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        if (self.maxDate.style == YEAR_MONTH_DAY) {
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
    }else if (component == 1)
    {
        self.monthIndex = (int)row;
        [self monthsFromYear:[self.years[self.yearIndex] intValue]];
        [self daysFromYear:[self.years[self.yearIndex] intValue] andMonth:[self.months[self.monthIndex] intValue]];
        if (self.maxDate.style == YEAR_MONTH_DAY) {
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }else if (component == 2)
    {
        self.dayIndex = (int)row;
    }
    [pickerView reloadAllComponents];
}

//其他部分   取得年 月  日  准确数据   关键就这里   坑点就是最大日期和最小日期的月数和天数的计算

- (void)configureData
{
    int maxYear = [self.maxDate.year intValue];
    int minYear = [self.minDate.year intValue];
    NSAssert(maxYear >= minYear, @"maxDate.year can't smaller than minDate.year");
    
    for (int i = minYear; i <= maxYear; i ++) {
        NSString *yearStr = [NSString stringWithFormat:@"%d年",i];
        [self.years addObject:yearStr];
    }
    int minMonth = [self.minDate.month intValue];
    
    [self monthsFromYear:minYear];
    [self daysFromYear:minYear andMonth:minMonth];
}

//获取年对应的月份

- (void)monthsFromYear:(int)year
{
    [self.months removeAllObjects];
    if ([self.maxDate.year intValue] == [self.minDate.year intValue]) {
        int maxMonth = [self.maxDate.month intValue];
        int minMonth = [self.minDate.month intValue];
        NSAssert(maxMonth >= minMonth, @"your maxDate and minDate should be exchange?");
        for (int i = minMonth; i <= maxMonth; i ++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02d月",i];
            [self.months addObject:monthStr];
        }
    }else if (year == [self.maxDate.year intValue]) {
        int maxMonth = [self.maxDate.month intValue];
        for (int i = 1; i <= maxMonth; i ++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02d月",i];
            [self.months addObject:monthStr];
        }
    }else if (year == [self.minDate.year intValue])
    {
        int minMonth = [self.minDate.month intValue];
        for (int i = minMonth; i <= 12; i ++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02d月",i];
            [self.months addObject:monthStr];
        }
    }else
    {
        for (int i = 1; i <= 12; i ++) {
            NSString *monthStr = [NSString stringWithFormat:@"%02d月",i];
            [self.months addObject:monthStr];
        }
    }
}

- (void)daysFromYear:(int)year andMonth:(int)month
{
    int maxYear = [self.maxDate.year intValue];
    int minYear = [self.minDate.year intValue];
    int maxMonth = [self.maxDate.month intValue];
    int minMonth = [self.minDate.month intValue];
    int maxDay = [self.maxDate.day intValue];
    int minDay = [self.minDate.day intValue];
    
    NSAssert(maxYear != 0 && maxMonth != 0 && maxDay != 0, @"wrong maxdate");
    NSAssert(minYear != 0 && minMonth != 0 && minDay != 0, @"wrong minDate");
    
    if (maxYear == minYear && maxMonth == minMonth)
    {
        NSAssert(maxDay >= minDay, @"joke me? the maxday should bigger than minday or equal than to minday");
    }
    
    BOOL isRunNian = year % 4 ==0 ? (year % 100== 0 ? (year % 400 == 0 ? YES : NO) : YES) : NO;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            if (maxYear == minYear && maxMonth == minMonth) {
                [self setDayArrayWithMinDay:minDay maxDay:maxDay];
            }else if (year == maxYear && month == maxMonth)
            {
                [self setDayArrayWithMinDay:1 maxDay:maxDay];
            }else if (year == minYear && month == minMonth)
            {
                [self setDayArrayWithMinDay:minDay maxDay:31];
            }else
            {
                [self setDayArrayWithMinDay:1 maxDay:31];
            }
            
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
        {
            if (maxYear == minYear && maxMonth == minMonth) {
                [self setDayArrayWithMinDay:minDay maxDay:maxDay];
            }else if (year == maxYear && month == maxMonth)
            {
                [self setDayArrayWithMinDay:1 maxDay:maxDay];
            }else if (year == minYear && month == minMonth)
            {
                [self setDayArrayWithMinDay:minDay maxDay:30];
            }else
            {
                [self setDayArrayWithMinDay:1 maxDay:30];
            }
        }
            break;
        case 2:{
            if (isRunNian)
            {
                if (maxYear == minYear && maxMonth == minMonth) {
                    [self setDayArrayWithMinDay:minDay maxDay:maxDay];
                }else if (year == maxYear && month == maxMonth)
                {
                    [self setDayArrayWithMinDay:1 maxDay:maxDay];
                }else if (year == minYear && month == minMonth)
                {
                    [self setDayArrayWithMinDay:minDay maxDay:29];
                }else
                {
                    [self setDayArrayWithMinDay:1 maxDay:29];
                }
            }else{
                if (year == maxYear && month == maxMonth)
                {
                    [self setDayArrayWithMinDay:1 maxDay:maxDay];
                }else if (year == minYear && month == minMonth)
                {
                    [self setDayArrayWithMinDay:minDay maxDay:28];
                }else
                {
                    [self setDayArrayWithMinDay:1 maxDay:28];
                }
            }
        }
            break;
        default:
            break;
    }
}


//获取这个月的可以显示的天

- (void)setDayArrayWithMinDay:(int)minDay maxDay:(int)maxDay
{
    [self.days removeAllObjects];
    for (int i = minDay; i <= maxDay; i++) {
        [self.days addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
}

//处理日期   这里可以写成nsdate的分类

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

@end
