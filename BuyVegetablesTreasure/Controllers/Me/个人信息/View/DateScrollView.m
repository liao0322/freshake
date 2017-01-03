//
//  DateScrollView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/2.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "DateScrollView.h"

@implementation DateScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDateScrollView];
    }
    return self;
}

- (void)initDateScrollView {
 
    UIView *dateView = [[UIView alloc] init];
    dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    [self addSubview:dateView];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    btnView.backgroundColor = [UIColor colorWithHexString:@"0xff6600"];
    btnView.backgroundColor = [UIColor colorDomina];
    [dateView addSubview:btnView];
    
    for (int i = 0; i < 2; i++)
    {
        
        CGFloat x = i == 0 ? 10 : SCREEN_WIDTH - 70;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.frame = CGRectMake(x, 5, 60, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:17];

        [btn setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    datePicker.frame = CGRectMake(0, 40, SCREEN_WIDTH, 120);
    //时间模式
    datePicker.datePickerMode = UIDatePickerModeDate;
    //最大事件限度（当前日期）
    datePicker.maximumDate = [NSDate date];
    
    [datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
    
    [dateView addSubview:datePicker];
    
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"y/M/d";
    NSString *dateString = [formatter stringFromDate:date];
    _dateString = dateString;
}

- (void)selectDate:(UIDatePicker *)picker
{
    //接收选择日期
    NSDate *date = picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"y/M/d";
    NSString *dateString = [formatter stringFromDate:date];
    _dateString = dateString;
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 100) {
        
        self.hidden = YES;
    }
    else {
    
        _dateBlock(_dateString);
        self.hidden = YES;
    }
}

@end
