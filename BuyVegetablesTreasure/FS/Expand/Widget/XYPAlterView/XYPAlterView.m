//
//  XYPAlterView.m
//  XYPTestAlertView
//
//  Created by 江玉元 on 2017/2/23.
//  Copyright © 2017年 Jiang YY. All rights reserved.
//

#import "XYPAlterView.h"

@interface XYPAlterView ()

@end

@implementation XYPAlterView

// 领用礼品券
- (void)alertForGetGiftCardWithMessage:(NSString *)message Money:(NSString *)money Success:(BOOL)success {
    [self setUpWhiteView];
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor colorTextDomina];
    messageLabel.font = [UIFont systemFontOfSize:19.0];
    [messageLabel sizeToFit];
    messageLabel.frame = CGRectMake((XYPAlterWidth - CGRectGetWidth(messageLabel.frame)) / 2, 43, CGRectGetWidth(messageLabel.frame), 20);
    [self addSubview:messageLabel];
    
    UIImageView *stateImageView = [UIImageView new];
    stateImageView.frame = CGRectMake(messageLabel.x - 38, 0, 23, 23);
    stateImageView.centerY = messageLabel.centerY;
    stateImageView.image = [UIImage imageNamed:success ? @"card成功" : @"card失败"];
    [self addSubview:stateImageView];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = money;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = [UIColor colorTextDomina];
    moneyLabel.font = [UIFont systemFontOfSize:19.0];
    [moneyLabel sizeToFit];
    moneyLabel.frame = CGRectMake(0, CGRectGetMaxY(messageLabel.frame) + 10, XYPAlterWidth, 20);
    [self addSubview:moneyLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake((XYPAlterWidth - 60) / 2, CGRectGetMaxY(moneyLabel.frame) + 10 , 60, 25);
    closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorTextDomina] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    closeButton.layer.cornerRadius = 5.0;
    closeButton.layer.masksToBounds = YES;
    closeButton.layer.borderWidth = 1;
    closeButton.layer.borderColor = [UIColor colorDomina].CGColor;
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    [self showAlertWith:CGRectGetMaxY(closeButton.frame) + 19];
    
}

#pragma mark 白色背景样式
- (void)setUpWhiteView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

#pragma mark 显示弹出框 自适应高度
- (void)showAlertWith:(CGFloat)height {
    self.frame = CGRectMake(0, 0, XYPAlterWidth, height);
    self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 100);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)closeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(xypAlterView:closeButtonTouchUpInside:)]) {
        [self.delegate xypAlterView:self closeButtonTouchUpInside:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
