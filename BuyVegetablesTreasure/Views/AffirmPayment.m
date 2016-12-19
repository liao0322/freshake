//
//  AffirmPayment.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "AffirmPayment.h"

@implementation AffirmPayment

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createAffirmPaymentView];
    }
    return self;
}

- (void)createAffirmPaymentView{
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SYSTEM_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 70, 20)];
    label.text = @"应付金额:";
    label.font = [UIFont systemFontOfSize:15];
    [self addSubview:label];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),15, 95, 20)];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    [self addSubview:_priceLabel];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(SYSTEM_WIDTH - 100, 1, 100, 49);
    _payBtn.backgroundColor = Color;
    [_payBtn setTitle:@"确定付款" forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_payBtn];
}

- (void)buttonClick {
    
    _gopPayment(nil);
}

@end
