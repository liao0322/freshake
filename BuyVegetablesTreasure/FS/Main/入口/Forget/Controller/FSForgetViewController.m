//
//  FSForgetViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSForgetViewController.h"
#import "XFLimitedTextField.h"
#import "FSResetPasswordViewController.h"

@interface FSForgetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *accountIconImageView;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation FSForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)initialization {
    [super initialization];
    
    self.title = @"发送验证码";
    
    self.accountTextField.maxCount = 11;
    
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.accountTextField.tintColor = [UIColor colorDomina];
    
    self.separatorLine.backgroundColor = [UIColor colorSeparatorLine];
    
    // next button
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonDisabled]] forState:UIControlStateDisabled];
    self.nextButton.layer.cornerRadius = 5.0f;
    self.nextButton.layer.masksToBounds = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat height = self.view.height;
    CGFloat spacing = 30.0f;
    CGFloat viewWidth = width - spacing * 2;
    
    CGFloat marginTop = height * 0.2;
    
    self.accountIconImageView.x = spacing;
    self.accountIconImageView.y = marginTop;
    
    self.accountTextField.x = self.accountIconImageView.right + 15;
    self.accountTextField.centerY = self.accountIconImageView.centerY;
    self.accountTextField.width = viewWidth - self.accountIconImageView.width - 15;
    
    self.separatorLine.height = 0.5;
    self.separatorLine.width = viewWidth;
    self.separatorLine.x = spacing;
    self.separatorLine.y = self.accountIconImageView.bottom + 5;
    
    self.nextButton.x = spacing;
    self.nextButton.height = 44;
    self.nextButton.width = viewWidth;
    self.nextButton.y = self.separatorLine.bottom + height * 0.1;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
}

#pragma mark - Custom

- (IBAction)nextButtonTouchUpInside:(UIButton *)sender {
    FSResetPasswordViewController *resetPasswordVC = [FSResetPasswordViewController new];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
