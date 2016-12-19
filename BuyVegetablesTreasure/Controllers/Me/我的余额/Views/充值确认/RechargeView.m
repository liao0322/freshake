//
//  RechargeView.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RechargeView.h"

@implementation RechargeView
{
    UIView *view;
    UIView *line;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self)
    {
     
    }
    
    return self;
}
-(void)SetUI:(NSString *)money WithTitle:(NSString *)title AndColor:(NSString *)color
{
    for (id Typeview in self.subviews)
    {
        [Typeview removeFromSuperview];
    }
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    
    _TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(view.frame))];
    _TitleLabel.text = title;
    _TitleLabel.font = [UIFont systemFontOfSize:16];
    _TitleLabel.textAlignment = NSTextAlignmentCenter;
    _TitleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    _TitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_TitleLabel];
    
    
    if ([_isBottomView isEqualToString:@"1"])
    {
        _SumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_TitleLabel.frame)-5, 0, SCREEN_WIDTH - CGRectGetWidth(_TitleLabel.frame) - 150, CGRectGetHeight(view.frame))];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,1)];
        
    }else{
    _SumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_TitleLabel.frame)-5, 0, SCREEN_WIDTH - CGRectGetWidth(_TitleLabel.frame), CGRectGetHeight(view.frame))];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), SCREEN_WIDTH,1)];
    }
//    _SumLabel.text = [NSString stringWithFormat:@"￥ %.2f",[money floatValue]];
//    _SumLabel.textColor = [UIColor colorWithHexString:@"0xff5f3e"];
    _SumLabel.textColor = [UIColor colorWithHexString:color];
    _SumLabel.text = money;
    _SumLabel.backgroundColor = [UIColor clearColor];
    _SumLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_SumLabel];
    
    
    if ([_isBottomView isEqualToString:@"1"])
    {
        _PayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _PayButton.frame = CGRectMake(SCREEN_WIDTH - 120, 0, 120, CGRectGetHeight(view.frame));
        [_PayButton setTitle:@"充 值" forState:UIControlStateNormal];
        _PayButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_PayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _PayButton.backgroundColor = [UIColor colorWithHexString:@"0xff9700"];
        [view addSubview:_PayButton];
        
        
        [_PayButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    line.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
    [view addSubview:line];
    
}
-(void)btnClick
{
    _RechargeBtn(_money);
}
@end
