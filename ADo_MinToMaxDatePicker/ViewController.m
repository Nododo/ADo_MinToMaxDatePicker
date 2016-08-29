//
//  ViewController.m
//  ADo_MinToMaxDatePicker
//
//  Created by 杜维欣 on 15/11/9.
//  Copyright © 2015年 Nododo. All rights reserved.
//

#import "ViewController.h"
#import "ADo_DateModel.h"
#import "ADo_MinToMaxDatePicker.h"

@interface ViewController ()
- (IBAction)showTheDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTheDatePicker:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *datemin = @"20080706";
    NSString *datemax = @"20180706";
    NSDate *minDate = [formatter dateFromString:datemin];
    NSDate *maxDate = [formatter dateFromString:datemax];
    ADo_DateModel *max = [[ADo_DateModel alloc] initWithDate:maxDate style:YEAR_MONTH_DAY];
    ADo_DateModel *min = [[ADo_DateModel alloc] initWithDate:minDate style:YEAR_MONTH_DAY];
    ADo_DateModel *current = [[ADo_DateModel alloc] initWithDate:[NSDate date] style:YEAR_MONTH_DAY];
    ADo_MinToMaxDatePicker *pick = [[ADo_MinToMaxDatePicker alloc] initWithMaxDate:max minDate:min outDate:YES];
    [pick setCurrentDate:current];
    __weak typeof(self) weakSelf = self;
    [pick showWithBlock:^(ADo_DateModel *model) {
        weakSelf.dateLabel.text = [NSString stringWithFormat:@"%@年-%@月-%@日",model.year,model.month,model.day];
    }];
}
@end
