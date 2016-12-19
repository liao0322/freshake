//
//  ModifyPasswordViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/1.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ShopLoginViewController.h"
#import "NSString+MD5.h"

@interface ModifyPasswordViewController ()

@property (nonatomic, copy) UIView *currentPhoneView;
@property (nonatomic, copy) UIButton *getTestBtn;
@property (nonatomic, copy) NSTimer *time;
@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isTiming;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"重置密码"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self
                                                                        action:@selector(back)];
    [self initCurrentPhoneView];
    [self initModifyPasswordView];
    [self initCompleteBtn];
}

#pragma mark - 控件初始化
#pragma mark 当前手机号码
- (void)initCurrentPhoneView {
    
    NSString *headString = [_phoneString substringWithRange:NSMakeRange(0,3)];
    NSString *tailString = [_phoneString substringWithRange:NSMakeRange(7,4)];
    
    _currentPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    _currentPhoneView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [self.view addSubview:_currentPhoneView];
    
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_currentPhoneView.frame) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
        [_currentPhoneView addSubview:line];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    titleLabel.text = @"我们已经发送了验证码到您的手机:";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_currentPhoneView addSubview:titleLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, ScreenWidth, 40)];
    phoneLabel.text = [NSString stringWithFormat:@"%@****%@",headString,tailString];
    phoneLabel.font = [UIFont systemFontOfSize:21];
    phoneLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [_currentPhoneView addSubview:phoneLabel];
}

#pragma mark 修改密码
- (void)initModifyPasswordView {

    for (int i = 0; i < 2; i++) {

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_currentPhoneView.frame) + 10 + 60 * i, ScreenWidth, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];

        _bgView = bgView;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, i == 0 ? ScreenWidth - ScreenWidth / 3 - 15 : ScreenWidth - 15, 50)];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = i == 0 ? @"请输入验证码" : @"设置新登录密码（6-20）位";
        textField.secureTextEntry = i == 0 ? NO : YES;
        textField.keyboardType = i == 0 ? UIKeyboardTypeDefault :UIKeyboardTypeASCIICapable;
        textField.font = [UIFont systemFontOfSize:15];
        textField.tag = i == 0 ? 100 : 101;
        [bgView addSubview:textField];
        
        if (i == 0) {
            
            _getTestBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            _getTestBtn.frame = CGRectMake(ScreenWidth - 110, CGRectGetHeight(_bgView.frame) / 2 - 20, 110, 40);
            [_getTestBtn addTarget:self action:@selector(sendTest:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:_getTestBtn];
            
            _timeLabel = [[UILabel alloc] initWithFrame:_getTestBtn.bounds];
            _timeLabel.text = @"获取验证码";
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            [_getTestBtn addSubview:_timeLabel];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 1, 30)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
            [_getTestBtn addSubview:line];
        }
    }
    
    [self sendTest:_getTestBtn];
}

#pragma mark 完成按钮
- (void)initCompleteBtn {
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.layer.borderColor = Color.CGColor;
    completeBtn.layer.borderWidth = 1;
    completeBtn.frame = CGRectMake(60, CGRectGetMaxY(_bgView.frame) + 45, ScreenWidth - 120, 45);
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [completeBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [completeBtn setTitleColor:Color forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(requestResetUserPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取验证码点击
- (void)sendTest:(UIButton *)btn {
    
    if (_isTiming) return;
    _isTiming = YES;
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    textField.text = @"";
    if (_isSend) [self requestValidation];
    else _isSend = YES;

    _timeLabel.text = @"60 s";
    _time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

#pragma mark 倒计时
- (void)timerFireMethod:(NSTimer *)timer {
    
    NSArray *array = [_timeLabel.text componentsSeparatedByString:@" "];
    
    int timeTick = (int)[array[0] integerValue];
    timeTick--;
    
    if(timeTick <= 0) {
        
        _isTiming = NO;
        [_time invalidate];
        
        _timeLabel.text = @"获取验证码";
        _getTestBtn.enabled = YES;
    }
    else {
        
        _isTiming = YES;
        _getTestBtn.enabled = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%d s",timeTick];
    }
}

#pragma mark - 发送验证码数据请求
- (void)requestValidation {
    
    [self.view endEditing:YES];
    NSString *urlString = [NSString stringWithFormat:GETCODE,_phoneString,@"1"];
    NSLog(@"==发送验证码== %@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {

         if ([data[@"issuccess"] boolValue]) {
             
             [Tools myHud:@"发送成功" inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}

#pragma mark 重置密码
- (void)requestResetUserPassword {
    
    [self.view endEditing:YES];
    
    NSString *newPwdString;
    NSString *codeString;
    
    for (int i = 0; i < 2; i++) {
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:100 + i];
        
        if (i == 0) {
                
            if ([Tools isBlankString:textField.text])
            {
                [Tools myHud:@"请输入验证码" inView:self.view];
                return;
            }
            else{
                codeString = textField.text;
            }
        }
        else {
            NSString *temp = [textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([Tools isBlankString:textField.text])
            {
                [Tools myHud:@"请输入新密码" inView:self.view];
                return;
            }
            //全部为空格
            if ([temp length]==0)
            {
                [Tools myHud:@"密码不能为空格" inView:self.view];
                return;
            }
            if (textField.text.length < 6)
            {
                [Tools myHud:@"密码不得小于6位数，请重新输入" inView:self.view];
                return;
            }
            if (textField.text.length > 20)
            {
                [Tools myHud:@"密码不得大于20位数，请重新输入" inView:self.view];
                return;
            }
            NSLog(@"textField.text=%@,leng=%zd",textField.text,textField.text.length);
            NSArray  *array= [textField.text componentsSeparatedByString:@" "];
            //中间有空格
            if (array.count > 1)
            {
                [Tools myHud:@"密码不能有空格符号" inView:self.view];
                return;
            }
            else{
                newPwdString = textField.text;
            }
        }
    }
    NSString *urlString = [NSString stringWithFormat:ResetUserPwdUrl,[newPwdString md5String],_phoneString,codeString];
    NSLog(@"==重置密码== %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
             [Tools myHud:@"修改密码成功" inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

@end
