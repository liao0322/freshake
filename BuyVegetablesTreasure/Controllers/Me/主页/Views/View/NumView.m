//
//  NumView.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "NumView.h"

@implementation NumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    float width = ScreenWidth/3;
    
    for (int i=0; i< 3; i++)
    {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(i*width, 0, width, 70);
        _button.tag = 50 + i;
        [_button addTarget:self action:@selector(MebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.showsTouchWhenHighlighted = YES;
//        _button.backgroundColor = [UIColor redColor];
        [self addSubview:_button];
    }
    
    //线
    for (int i = 0; i < 2; i++)
    {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 10, 1, 50)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
        [self addSubview:line];
    }
    
    //线
    for (int i = 0; i < 2; i++)
    {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 69*i, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
        [self addSubview:line];
    }
    
    //可用积分
    _pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 30)];
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    _pointLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _pointLabel.text = @"0分";
    _pointLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_pointLabel];
    
    UILabel *pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pointLabel.frame)-5, width, 35)];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    pointLabel.text = @"可用积分";
    pointLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:pointLabel];
    
    
    //余额
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 5, width, 30)];
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    _balanceLabel.text = @"0元";
    _balanceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_balanceLabel];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, CGRectGetMaxY(_balanceLabel.frame)-5, width, 35)];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    balanceLabel.text = @"账户余额";
    balanceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:balanceLabel];
    
    //余额
    _couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 5, width, 30)];
    _couponLabel.textAlignment = NSTextAlignmentCenter;
    _couponLabel.textColor = Color;
    _couponLabel.text = @"0张";
    _couponLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_couponLabel];
    
    
    UILabel *couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, CGRectGetMaxY(_couponLabel.frame)-5, width, 35)];
    couponLabel.textAlignment = NSTextAlignmentCenter;
    couponLabel.textColor = [UIColor colorWithHexString:@"0x181818"];
    couponLabel.text = @"优惠券";
    couponLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:couponLabel];
}
-(void)setData:(MeModel *)model
{
    _pointLabel.text=model.point;
   
    _balanceLabel.text=[NSString stringWithFormat:@"￥%@",model.amount];
    
    _couponLabel.text=model.TickNum;
    
    //富文本
//    NSMutableAttributedString *couponString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@张",model.TickNum]];
//    [couponString setAttributes:@{NSForegroundColorAttributeName : Color,   NSFontAttributeName : [UIFont systemFontOfSize:22]} range:NSMakeRange(0, model.TickNum.length)];
    
}
-(void)MebtnClick:(UIButton *)btn
{
    _btnBlock(btn.tag);
}
@end
