//
//  CityPickerView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/31.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CityPickerView.h"

@interface CityPickerView ()

@property (nonatomic, copy) UIPickerView *selectCityPickerView;

@end

@implementation CityPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _selectCityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height - 40)];
    _selectCityPickerView.backgroundColor = [UIColor colorWithHexString:@"0xC5CBD2"];
    _selectCityPickerView.delegate = self;
    _selectCityPickerView.dataSource = self;
    [self addSubview:_selectCityPickerView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
        [bgView addSubview:line];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.frame = CGRectMake(10 + (ScreenWidth - 50) * i, 0, 35, CGRectGetHeight(bgView.frame));
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 0, 100, CGRectGetHeight(bgView.frame))];
    titleLabel.text = @"选择城市";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"0xABACAD"];
    [bgView addSubview:titleLabel];
}

- (void)buttonClick:(UIButton *)btn {
    
    if (btn.tag == 100) _buttonClickBlock(@"");
    else _buttonClickBlock(_cityString);
}

- (void)refreshCity {
    
    if (_cityArray.count > 0) {
        _cityString = _cityArray[0];
    }
    
    [_selectCityPickerView reloadAllComponents];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _cityArray.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _cityArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _cityString = _cityArray[row];
}

@end
