//
//  SelectCityPickerView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/9.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "SelectCityPickerView.h"

@implementation SelectCityPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSelectCityView];
    }
    return self;
}

- (void)initSelectCityView {
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnBgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_WIDTH - 60, 10, 40, 20);
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:btn];
    
    _provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200)];
    _provincePickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_provincePickerView];
}

- (void)btnClick {
    
    _btnClickBlock(nil);
}
@end
