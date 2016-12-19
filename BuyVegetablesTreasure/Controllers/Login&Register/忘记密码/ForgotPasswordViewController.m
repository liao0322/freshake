//
//  ForgotPasswordViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/1.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ModifyPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (nonatomic, copy) UIView *writePhoneView;
@property (nonatomic, copy) UITextField *phoneTextField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"发送验证码"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self
                                                                        action:@selector(back)];
    [self initWritePhoneView];
    [self initNewButton];
}

#pragma mark - 控件初始化
#pragma mark 填写手机号码
- (void)initWritePhoneView {
    
    _writePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 50)];
    _writePhoneView.backgroundColor = [UIColor colorWithHexString:@"0xffffff"];
    [self.view addSubview:_writePhoneView];

    for (int i = 0; i < 2; i++) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_writePhoneView.frame) * i, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xd7d7d7"];
        [_writePhoneView addSubview:line];
    }
    
    UIImage *img = [UIImage imageNamed:@"登陆-手机图标"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25 - img.size.height / 2, img.size.width, img.size.height)];
    imgView.image = img;
    [_writePhoneView addSubview:imgView];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 20, 0, ScreenWidth - CGRectGetMaxX(imgView.frame) - 40, CGRectGetHeight(_writePhoneView.frame))];
    _phoneTextField.delegate = self;
    _phoneTextField.font = [UIFont systemFontOfSize:15];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_writePhoneView addSubview:_phoneTextField];
}

#pragma mark 下一步按钮
- (void)initNewButton {
    
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_writePhoneView.frame) + 30, ScreenWidth - 120, 45)];
    newBtn.layer.borderColor = Color.CGColor;
    newBtn.layer.borderWidth = 1;
    newBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [newBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [newBtn setTitleColor:Color forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(newBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
}

#pragma mark - 数据请求
- (void)requestValidation {
    
    NSString *urlString = [NSString stringWithFormat:GETCODE,_phoneTextField.text,@"1"];
    NSLog(@"验证码 = %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
         
         if ([issuccess isEqualToString:@"1"]) {
             [Tools myHud:@"发送成功" inView:[[UIApplication sharedApplication].delegate window]];
             
             ModifyPasswordViewController *modifyPasswordView = [[ModifyPasswordViewController alloc] init];
             modifyPasswordView.phoneString = _phoneTextField.text;
             [self.navigationController pushViewController:modifyPasswordView animated:YES];
         }
         else
         {
             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         
     } failure:nil];
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击下一步按钮
- (void)newBtn {
    
    [self.view endEditing:YES];
    
    if ([Tools isMobileNum:_phoneTextField.text]) [self requestValidation];
    else [Tools myHud:@"请输入正确的手机号!" inView:self.view];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self newBtn];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
