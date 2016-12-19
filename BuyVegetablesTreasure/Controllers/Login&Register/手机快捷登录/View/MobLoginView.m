//
//  MobLoginView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MobLoginView.h"

@implementation MobLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initLoginView];
    }
    return self;
}

- (void)initLoginView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    NSArray *arr = @[@"登陆-手机图标",@"登陆-验证码图标"];
    for (int i = 0; i < 2; i++) {
        
        UIImage *img = [UIImage imageNamed:arr[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (25 - img.size.height / 2) + 50 * i, img.size.width, img.size.height)];
        imgView.image = img;
        [bgView addSubview:imgView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 20, 50 * i, ScreenWidth - CGRectGetMaxX(imgView.frame) - 40 - 100 * i, 50)];
        textField.tag = i + 10;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = i == 0 ? @"请输入手机号" : @"请输入验证码";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:textField];
        
        if (i == 1) {
            
            _countdownBtn = [[CountdownButton alloc] initWithFrame:CGRectMake(ScreenWidth - 90, CGRectGetHeight(bgView.frame) / 2 + 10, 80, 30)];
            _countdownBtn.time = 60;
            _countdownBtn.fontSize = 15;
            _countdownBtn.countdownTtitle = @"获取验证码";
            _countdownBtn.countdownTextColor = [UIColor whiteColor];
            _countdownBtn.startBgColor = [UIColor colorWithHexString:@"0x999999"];;
            _countdownBtn.endBgColor = Color;
            [_countdownBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:_countdownBtn];
        }
    }
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xe2e2e2"];
        [bgView addSubview:line];
    }

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(ScreenWidth / 6, CGRectGetMaxY(bgView.frame) + 30, ScreenWidth / 6 * 4, 45);
    loginBtn.layer.borderColor = Color.CGColor;
    loginBtn.layer.borderWidth = 1;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginBtn setTitle:@"验证并登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:Color forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
}

- (void)btnClick {
    
    [self endEditing:YES];
    
    NSString *phoneString = [(UITextField *)[self viewWithTag:10] text];
    if ([Tools isBlankString:phoneString]) {
        return [Tools myHud:@"请输入手机号" inView:self];
    }
    else if (![Tools isMobileNum:phoneString]) {
        return [Tools myHud:@"请输入正确的手机号!" inView:self];
    }
    
    _sendVerification(phoneString);
}

- (void)loginClick {
    
    NSString *phoneString = [(UITextField *)[self viewWithTag:10] text];
    NSString *verification = [(UITextField *)[self viewWithTag:11] text];
    
    if ([Tools isBlankString:phoneString]) {
        return [Tools myHud:@"请输入您的手机号" inView:self];
    }
    else if (![Tools isMobileNum:phoneString]) {
        return [Tools myHud:@"请输入正确的手机号!" inView:self];
    }
    else if ([Tools isBlankString:verification]) {
        return [Tools myHud:@"请输入验证码" inView:self];
    }
    
    _login(phoneString, verification);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
