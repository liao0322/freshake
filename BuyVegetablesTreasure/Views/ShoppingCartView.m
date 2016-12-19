//
//  ShoppingCartView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/19.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "ShoppingCartView.h"

@implementation ShoppingCartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initShoppingCartView];
    }
    return self;
}

- (void)initShoppingCartView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3 - 50, SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
    imageView.image = [UIImage imageNamed:@"无商品"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, SCREEN_WIDTH, 20)];
    label.text = @"亲! 您的购物车是空的哟！";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:0.537 green:0.545 blue:0.545 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    _goHomePageShopping = [UIButton buttonWithType:UIButtonTypeCustom];
    _goHomePageShopping.frame = CGRectMake(SCREEN_WIDTH / 3, CGRectGetMaxY(label.frame) + 50, SCREEN_WIDTH / 3, 50);
    _goHomePageShopping.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_goHomePageShopping setTitle:@"去逛逛" forState:UIControlStateNormal];
    [_goHomePageShopping setTitleColor:Color forState:UIControlStateNormal];
    
    _goHomePageShopping.layer.masksToBounds = YES;
    _goHomePageShopping.layer.cornerRadius = 5;
    _goHomePageShopping.layer.borderColor = Color.CGColor;
    _goHomePageShopping.layer.borderWidth = 1;
    [_goHomePageShopping addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goHomePageShopping];
}

- (void)btnClick {
    _goHomePage();
}

@end
