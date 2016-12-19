//
//  RegisterView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initRegisterView];
    }
    return self;
}

- (void)initRegisterView {
    
    NSArray *imageArray = @[@"登陆-手机图标",@"登陆-验证码图标",@"登陆-密码",@"登陆-密码"];
    NSArray *textArray = @[@"请输入手机号",@"请输入验证码",@"请输入密码",@"请输入密码"];
    UIView *bgView;
    for (int i = 0; i < imageArray.count; i++) {
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + i * 50, ScreenWidth, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UIImage *img = [UIImage imageNamed:imageArray[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(bgView.frame) / 2 - img.size.height / 2, img.size.width, img.size.height)];
        imgView.image = img;
        [bgView addSubview:imgView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, ScreenWidth - (i == 1 ? 160 : 80), CGRectGetHeight(bgView.frame))];
        textField.tag = i + 10;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = textArray[i];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.secureTextEntry = i > 1 ? YES : NO;
        textField.keyboardType = i > 1 ? UIKeyboardTypeDefault : UIKeyboardTypePhonePad;
        [bgView addSubview:textField];

        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xe8e8e8"];
        [bgView addSubview:line];
        
        if (i == 1) {
            
            _countdownBtn = [[CountdownButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 10, 10, 80, CGRectGetHeight(bgView.frame) - 20)];
            _countdownBtn.time = 60;
            _countdownBtn.fontSize = 12;
            _countdownBtn.countdownTtitle = @"获取验证码";
            _countdownBtn.countdownTextColor = [UIColor whiteColor];
            _countdownBtn.startBgColor = [UIColor colorWithHexString:@"0x999999"];;
            _countdownBtn.endBgColor = Color;
            [_countdownBtn addTarget:self action:@selector(sendVerificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:_countdownBtn];
        }
    }
    
    UIImage *img = [UIImage imageNamed:@"登陆-未勾选"];
    UIImage *selectImg = [UIImage imageNamed:@"登陆-勾选"];

    // 同意协议按钮
    _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreementBtn.selected = YES;
    [_agreementBtn setImage:img forState:UIControlStateNormal];
    [_agreementBtn setImage:selectImg forState:UIControlStateSelected];
    [_agreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_agreementBtn];
    
    _agreementBtn.sd_layout
    .widthIs(img.size.width)
    .heightIs(img.size.height)
    .leftSpaceToView(self, 20)
    .topSpaceToView(bgView, 10);

    // 同意协议文本
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"我已看过并同意";
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(_agreementBtn, 10)
    .topSpaceToView(bgView, 10)
    .heightIs(img.size.height);
    
    // 协议按钮
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreementBtn setTitle:@"《鲜摇派用户协定》" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:Color forState:UIControlStateNormal];
    [agreementBtn addTarget:self
                     action:@selector(goAgreement)
           forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:agreementBtn];
    
    agreementBtn.sd_layout
    .leftSpaceToView(titleLabel,0)
    .centerYEqualToView(titleLabel)
    .heightIs(14)
    .widthIs(130);
    
    // 注册
    UIButton *registered = [UIButton buttonWithType:UIButtonTypeCustom];
    registered.layer.borderColor = Color.CGColor;
    registered.layer.borderWidth = 1;
    [registered setTitle:@"注册" forState:UIControlStateNormal];
    [registered setTitleColor:Color forState:UIControlStateNormal];
    [registered addTarget:self action:@selector(registeredBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registered];

    registered.sd_layout
    .topSpaceToView(_agreementBtn, 10)
    .widthRatioToView(self, 0.5)
    .centerXEqualToView(self)
    .heightIs(45);
}

- (void)goAgreement {
    
    _goViewContrller([NSClassFromString(@"UserAgreementViewController") new]);
}

#pragma mark 点击同意协议按钮
- (void)btnClick:(UIButton *)btn {
    
    [self endEditing:YES];
    btn.selected = !btn.selected;
}

#pragma mark 点击发送验证按钮
- (void)sendVerificationBtnClick {
    
    [self endEditing:YES];
    
    if ([Tools isBlankString:[(UITextField *)[self viewWithTag:10] text]]) {
        return [Tools myHud:@"请输入您的手机号" inView:self];
    }
    else if (![Tools isMobileNum:[(UITextField *)[self viewWithTag:10] text]]) {
        return [Tools myHud:@"请输入正确的手机号!" inView:self];
    }

    _sendVerification([(UITextField *)[self viewWithTag:10] text]);
}

#pragma mark 点击注册按钮
- (void)registeredBtnClick {
    
    [self endEditing:YES];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [arr addObject:[(UITextField *)[self viewWithTag:i + 10] text]];
    }
    
    if ([Tools isBlankString:arr[0]]) {
        return [Tools myHud:@"请输入您的手机号" inView:self];
    }
    else if ([Tools isBlankString:arr[1]]) {
        return [Tools myHud:@"请先获取验证码" inView:self];
    }
    else if ([Tools isBlankString:arr[2]]) {
        return [Tools myHud:@"请输入密码" inView:self];
    }
    else if ([Tools isBlankString:arr[3]]) {
        return [Tools myHud:@"请再次输入密码" inView:self];
    }
    else if (![arr[2] isEqualToString:arr[3]]) {
        return [Tools myHud:@"两次密码不一致" inView:self];
    }
    
    _registered((NSArray *)arr);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
