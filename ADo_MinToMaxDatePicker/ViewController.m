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
    NSDate *date = [formatter dateFromString:datemin];
    
    ADo_DateModel *max = [[ADo_DateModel alloc] initWithDate:[NSDate date] style:YEAR_MONTH_DAY];
    ADo_DateModel *min = [[ADo_DateModel alloc] initWithDate:date style:YEAR_MONTH_DAY];
    ADo_MinToMaxDatePicker *pick = [[ADo_MinToMaxDatePicker alloc] initWithMaxDate:max minDate:min];
    [pick showWithBlock:^(ADo_DateModel *model) {
        NSLog(@"%@====%@=====%@",model.year,model.month,model.day);
    }];
}
@end
