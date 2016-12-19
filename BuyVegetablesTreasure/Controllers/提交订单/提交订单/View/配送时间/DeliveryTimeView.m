//
//  DeliveryTimeView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "DeliveryTimeView.h"

@interface DeliveryTimeView ()

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@end

@implementation DeliveryTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initArray];
        [self initDeliveryTime];
        
        
    }
    return self;
}

- (void)initArray {

    NSDate *date = [NSDate date];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [format1 stringFromDate:date];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    dateArray = [dateArray[0] componentsSeparatedByString:@"-"];
    
    _hour = [[dateStr componentsSeparatedByString:@" "][1] componentsSeparatedByString:@":"][0];
    _month = [dateArray[1] integerValue];
    _day = [dateArray[2] integerValue];
    
    _dateArray = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        
        if (i == 0 && [_hour integerValue] < 12) {
            [_dateArray addObject:@"当天配送"];
        }
        else {

            [self isBeyond];
            [_dateArray addObject:[NSString stringWithFormat:@"%@/%02zd/%02zd",dateArray[0],_month,_day]];
        }
    }
    
    if ([_dateArray[0] isEqualToString:@"当天配送"]) {
        _timeArray = @[@"13:00-17:00"];
    }
    else _timeArray = @[@"10:00-11:30",@"13:00-17:00"];
}

- (void)isBeyond {

    if (_month <= 7) {
        
        int a = _month % 7;
        int day = 31;
        
        if (_month == 2) day = 28;
        else if (a != 1) day = 30;
        
        if (_day + 1 > day) {
            
            _month++;
            _day = 1;
            return;
        }
    }
    else {
        
        int a = _month % 2;
        int day = 31;
        
        if (a == 1) {
            day = 30;
        }
        
        if (_day + 1 > day) {
            
            _month++;
            _day = 1;
            return;
        }
    }
    
    _day++;
}

- (void)initDeliveryTime {
    
    UIPickerView *deliveryTimerPickerView = [UIPickerView new];
    deliveryTimerPickerView.backgroundColor = [UIColor colorWithHexString:@"0xC5CBD2"];
    deliveryTimerPickerView.delegate = self;
    deliveryTimerPickerView.dataSource = self;
    deliveryTimerPickerView.showsSelectionIndicator = YES;
    [self addSubview:deliveryTimerPickerView];
    
    deliveryTimerPickerView.sd_layout
    .heightIs(216)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    // 背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = [UIColor colorWithHexString:@"0xd7d7d7"].CGColor;
    bgView.layer.borderWidth = 0.5;
    [self addSubview:bgView];
    
    bgView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(deliveryTimerPickerView, 0)
    .heightIs(40);
    
    // 取消、确定按钮
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        btn.sd_layout
        .heightIs(40)
        .widthIs(30)
        .topEqualToView(bgView);
        
        if (i == 1) {
            
            btn.sd_layout.rightSpaceToView(bgView, 15);
            [btn setTitle:@"确定" forState:UIControlStateNormal];
        }
        else {
            
            btn.sd_layout.leftSpaceToView(bgView, 15);
        }
    }
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"选择城市";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    [titleLabel setPreferredMaxLayoutWidth:100];
    [bgView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .centerXEqualToView(bgView)
    .centerYEqualToView(bgView)
    .autoHeightRatio(0);
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 100) {
        _selectTime(@"");
    }
    else {
        
        if (_timeString == nil) {
            
            _timeString = [NSString stringWithFormat:@"%@ %@", _dateArray[0], _timeArray[0]];
        }
        
        _selectTime(_timeString);
    }
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return _dateArray.count;
    }
    else {
        return _timeArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 1) {
        return _timeArray[row];
    }
    
    return _dateArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (isBlankString(_date)) {
        _date = _dateArray[0];
    }
    
    if (isBlankString(_time)) {
        _time = _timeArray[0];
    }
    
    if (component == 0) {
        _date = _dateArray[row];
    }
    
    if (component == 1) {
        _time = _timeArray[row];
    }
    
    if (component == 0 && [_date isEqualToString:@"当天配送"]) {
        _timeArray = @[@"13:00-17:00"];
        [pickerView reloadComponent:1];
    }
    else {
        _timeArray = @[@"10:00-11:30",@"13:00-17:00"];
        [pickerView reloadComponent:1];
    };
    
    _timeString = [NSString stringWithFormat:@"%@ %@",_date, _time];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return ScreenWidth / 2;
    }
    else {
        return ScreenWidth / 2;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        titleLabel.text = [_dateArray objectAtIndex:row];
    }
    else {
        titleLabel.text = [_timeArray objectAtIndex:row];
    }
    
    return titleLabel;
}

@end
