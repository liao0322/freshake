//
//  FSNumView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSNumView.h"

@implementation FSNumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    float width = ScreenWidth / 3;
    for (int i  = 0; i < 3; i++) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(i * width, 0, width, 50);
        _button.tag = 50 + i;
        _button.adjustsImageWhenHighlighted = NO;
        [_button addTarget:self action:@selector(meBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    
    // 分隔线
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((i + 1) * width, 10, 1, 30)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
    }
    
    // 可用积分
    _pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, width, 20)];
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    _pointLabel.textColor = [UIColor whiteColor];
    _pointLabel.text = @"0分";
    _pointLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:_pointLabel];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pointLabel.frame) - 5, width, 20)];
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.text = @"可用积分";
    pointLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:pointLabel];
    
    // 账户余额
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 5, width, 20)];
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.textColor = [UIColor whiteColor];
    _balanceLabel.text = @"0元";
    _balanceLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:_balanceLabel];
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, CGRectGetMaxY(_balanceLabel.frame) - 5, width, 20)];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.text = @"账户余额";
    balanceLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:balanceLabel];
    
    // 优惠券
    _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 2, 5, width, 20)];
    _couponLabel.textAlignment = NSTextAlignmentCenter;
    _couponLabel.textColor = [UIColor whiteColor];
    _couponLabel.text = @"0张";
    _couponLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:_couponLabel];
    
    UILabel *couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 2, CGRectGetMaxY(_couponLabel.frame) - 5, width, 20)];
    couponLabel.textAlignment = NSTextAlignmentCenter;
    couponLabel.textColor = [UIColor whiteColor];
    couponLabel.text = @"优惠券";
    couponLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:couponLabel];
}

- (void)setData:(FSMeModel *)model {
    
    _pointLabel.text = model.point;
    
    _balanceLabel.text = [NSString stringWithFormat:@"￥%@", model.amount];
    
    _couponLabel.text = model.tickNum;
    
}

- (void)meBtnClick:(UIButton *)btn {
    NSLog(@"获取积分、余额");
    _btnBlock(btn.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
