//
//  LoginView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/9.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initLoginView];
        [self initQuickLogin];
    }
    return self;
}

- (void)initLoginView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    NSArray *arr = @[@"登陆-手机图标",@"登陆-密码"];
    for (int i = 0; i < 2; i++) {
        
        UIImage *img = [UIImage imageNamed:arr[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (25 - img.size.height / 2) + 50 * i, img.size.width, img.size.height)];
        imgView.image = img;
        [bgView addSubview:imgView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 20, 50 * i, ScreenWidth - CGRectGetMaxX(imgView.frame) - 40, 50)];
        textField.tag = i + 10;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = i == 0 ? @"请输入手机号" : @"请输入密码";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.secureTextEntry = i;
        [bgView addSubview:textField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20 + ((ScreenWidth - 60) / 2 + 20) * i, CGRectGetMaxY(bgView.frame) + 50, (ScreenWidth - 60) / 2, 45);
        btn.layer.borderColor = Color.CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = i + 20;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.backgroundColor = i == 0 ? Color : [UIColor clearColor];
        [btn setTitle:i == 0 ? @"登录" : @"注册" forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? [UIColor whiteColor] : Color forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xe2e2e2"];
        [bgView addSubview:line];
    }
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(ScreenWidth - 70, CGRectGetMaxY(bgView.frame), 55, 50);
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:Color forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetBtn];
}

- (void)initQuickLogin {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight / 3 - 64, ScreenWidth, ScreenHeight / 3)];
    [self addSubview:bgView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, ScreenWidth - 40, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
    [bgView addSubview:line];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 50, 0, 100, 12)];
    titleLabel.text = @"手机号码快捷登录";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [bgView addSubview:titleLabel];
    
    // 快捷登录图标
    UIImage *quickLoginImg = [UIImage imageNamed:@"登陆-手机登录"];
    
    // 快捷登录按钮
    UIButton *quickLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quickLoginBtn.frame = CGRectMake(bgView.frame.size.width / 2 - quickLoginImg.size.width / 2,
                                     bgView.frame.size.height / 2 - quickLoginImg.size.height / 2,
                                     quickLoginImg.size.width,
                                     quickLoginImg.size.height);
    [quickLoginBtn setImage:quickLoginImg forState:UIControlStateNormal];
    [quickLoginBtn addTarget:self action:@selector(quickLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:quickLoginBtn];
}

#pragma mark 手机快捷登录
- (void)quickLoginClick {
    _goViewController([NSClassFromString(@"MobLoginViewController") new]);
}

#pragma mark 登录
- (void)loginClick:(UIButton *)btn {
    
    if (btn.tag == 20) {
        _loginBlock([(UITextField *)[self viewWithTag:10] text], [(UITextField *)[self viewWithTag:11] text]);
    }
    else _goViewController([NSClassFromString(@"RegisterViewController") new]);
}

#pragma mark 忘记密码
- (void)forgetClick {
    _goViewController([NSClassFromString(@"ForgotPasswordViewController") new]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
