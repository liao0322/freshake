//
//  PaymentCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    [Single sharedInstance].payMent = WeCartPay;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self.contentView addSubview:line];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    titleImage.tintColor = [UIColor colorDomina];
    titleImage.image = [[UIImage imageNamed:@"选择支付方式图标"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.contentView addSubview:titleImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame) + 10, 15, ScreenWidth, 20)];
    titleLabel.text = @"选择支付方式";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = Color;
    [self.contentView addSubview:titleLabel];
    
    NSArray *payTextArray = @[@"余额支付",@"微信支付",@"支付宝支付"];
    NSArray *payImageArray = @[@"余额付款",@"微信支付图标",@"支付宝图标"];
    
    UIButton *btn;
    for (int i = 0; i < payTextArray.count; i++) {
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, CGRectGetMaxY(titleImage.frame) + 15 + 50 * i, ScreenWidth, 50);
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        UIImageView *payImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(btn.frame) / 2 - 10, 20, 20)];
        payImageView.image = IMAGE(payImageArray[i]);
        [btn addSubview:payImageView];
        
        UILabel *payTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(payImageView.frame) + 10, 0, 100, CGRectGetHeight(btn.frame))];
        payTextLabel.text = payTextArray[i];
        payTextLabel.font = [UIFont systemFontOfSize:13];
        [btn addSubview:payTextLabel];
        
        UIButton *selectPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectPayBtn.frame = CGRectMake(ScreenWidth - 35, CGRectGetHeight(btn.frame) / 2 - 10, 15, 20);
        selectPayBtn.selected = i == 1 ? YES : NO;
        selectPayBtn.tag = 20 + i;
        [selectPayBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        [selectPayBtn setImage:[UIImage imageNamed:@"勾图标"] forState:UIControlStateSelected];
        [selectPayBtn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:selectPayBtn];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [btn addSubview:l];
    }
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [btn addSubview:l];
}

- (void)selectPayType:(UIButton *)btn {
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i + 20];
        button.selected = NO;
    }
    
    btn = (UIButton *)[self viewWithTag:btn.tag < 20 ? btn.tag + 10 : btn.tag];
    btn.selected = YES;
    
    if (btn.tag == 10 || btn.tag == 20) [Single sharedInstance].payMent = AmountPlay;
    else [Single sharedInstance].payMent = (btn.tag == 11 || btn.tag == 21) ? WeCartPay : AliPay;
}

- (void)awakeFromNib {
    
    // 默认
    _weChatPayButton.selected = YES;
    [Single sharedInstance].payMent = WeCartPay;
    
    UITapGestureRecognizer *weChatTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(weChatPay)];
    [_weChatPayView addGestureRecognizer:weChatTapGestureRecognizer];
    
    UITapGestureRecognizer *alipayTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(alipayPay)];
    [_alipayPayView addGestureRecognizer:alipayTapGestureRecognizer];
    
    for (int i = 0; i < 4; i++) {
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 55 * i, ScreenWidth, 1)];
        l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
        [self.contentView addSubview:l];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)weChatPay{
    
    _weChatPayButton.selected = YES;
    _alipayPayButton.selected = NO;
    
    // 微信支付
    [Single sharedInstance].payMent = WeCartPay;
}

- (IBAction)alipayPay{
    
    _alipayPayButton.selected = YES;
    _weChatPayButton.selected = NO;
    
    // 支付宝支付
    [Single sharedInstance].payMent = AliPay;
}

@end
