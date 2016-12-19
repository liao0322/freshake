//
//  HomePageFootView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HomePageFootView.h"

@implementation HomePageFootView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
    
        [self initFootView];
    }
    
    return self;
}

- (void)initFootView {
    
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn.layer.borderColor = Color.CGColor;
    footBtn.layer.borderWidth = 0.5;
    footBtn.layer.cornerRadius = 15;
    footBtn.layer.masksToBounds = YES;
    footBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [footBtn setTitle:@"查看全部商品 >>" forState:UIControlStateNormal];
    [footBtn setTitleColor:Color forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(look) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:footBtn];
    
    footBtn.sd_layout
    .centerYEqualToView(self)
    .centerXEqualToView(self)
    .widthIs(150)
    .heightIs(30);
}

- (void)look {
    self.lookAllGoods();
}

@end
