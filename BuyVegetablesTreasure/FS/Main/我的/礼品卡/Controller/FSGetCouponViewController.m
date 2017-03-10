//
//  FSGetCouponViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/3/8.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGetCouponViewController.h"
#import "FSGiftCartQuestionAnswerViewController.h"
#import "XFLimitedTextField.h"
#import "XYPAlterView.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

@interface FSGetCouponViewController ()<XYPAlterViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *couponNumTextField;
@property (weak, nonatomic) IBOutlet UIView *textViewLine;


@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;

@property (weak, nonatomic) IBOutlet UIButton *getCouponButton;

@property (copy, nonatomic, readonly) NSDictionary *codeDict;


@property (nonatomic) XYPAlterView *xypAlterView;
@property (nonatomic) UIView *darkView;
@property (nonatomic) NSString *stateCode;

@property (nonatomic, copy) NSString *uidString; // 用户id


@end

@implementation FSGetCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)initialize {
    [super initialize];
    
    self.title = @"领用优惠券";
    
    self.couponNumTextField.maxCount = 8;
    self.attentionLabel.textColor = [UIColor colorTextDomina];
    self.textViewLine.backgroundColor = [UIColor colorSeparatorLine];
    
    [self.getCouponButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.getCouponButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    [self.getCouponButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonDisabled]] forState:UIControlStateDisabled];
    self.getCouponButton.layer.cornerRadius = 5.0f;
    self.getCouponButton.layer.masksToBounds = YES;
    
    self.darkView = [UIView new];
    self.darkView.userInteractionEnabled = YES;
    self.darkView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    self.xypAlterView = [XYPAlterView new];
    self.xypAlterView.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _uidString = [userDefaults objectForKey:@"UID"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
    
    self.darkView.frame = [UIScreen mainScreen].bounds;
}


// 如何领用按钮事件
- (IBAction)getExplainButtonAction:(id)sender {
    FSGiftCartQuestionAnswerViewController *answerVC = [FSGiftCartQuestionAnswerViewController new];
    answerVC.Status = 1;
    [self.navigationController pushViewController:answerVC animated:YES];
}

// 立即领用按钮事件
- (IBAction)getCouponButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if (!(self.couponNumTextField.text.length < 8)) {
            [self getCouponsWithCouponNumber:self.couponNumTextField.text];
    }
    else{
        return [XFProgressHUD showMessage:@"请输入8位兑换码" inView:self.view];
    }
    
}

- (void)getCouponsWithCouponNumber:(NSString *)couponNumber {
    
    NSString *urlString = [NSString stringWithFormat:GetCoupons,[_uidString integerValue],couponNumber];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        
        NSDictionary *dict = [self dictWithData:responseObject];
        self.stateCode = dict[@"code"];
        // 领取失败
        if (![self.stateCode isEqualToString:@"0"]) {
            if ([self.stateCode isEqualToString:@"030201"]) {
                return [XFProgressHUD showMessage:self.codeDict[dict[@"code"]] inView:self.view];
            } else if ([self.stateCode isEqualToString:@"030202"]) {
                return [XFProgressHUD showMessage:self.codeDict[dict[@"code"]] inView:self.view];
            } else if ([self.stateCode isEqualToString:@"030203"]) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.darkView];
                [self.xypAlterView alertForGetGiftCardWithMessage:self.codeDict[dict[@"code"]] Money:nil Success:NO];
                return;
            } else {
                [[UIApplication sharedApplication].keyWindow addSubview:self.darkView];
                [self.xypAlterView alertForGetGiftCardWithMessage:@"优惠券领用失败" Money:nil Success:NO];
                return;
            }
        }
        
        // 领取成功
        [[UIApplication sharedApplication].keyWindow addSubview:self.darkView];
        [self.xypAlterView alertForGetGiftCardWithMessage:@"优惠券领用成功" Money:nil Success:YES];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
}

// 弹出框关闭按钮事件
- (void)xypAlterView:(XYPAlterView *)xypAlterView closeButtonTouchUpInside:(UIButton *)sender {
    [self.darkView removeFromSuperview];
    [self.xypAlterView removeFromSuperview];
    [self removeSubviews];
    
    if ([self.stateCode isEqualToString:@"0"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 移除子视图
- (void)removeSubviews {
    if (self.xypAlterView.subviews.count != 0) {
        for (UIView *view in self.xypAlterView.subviews) {
            [view removeFromSuperview];
        }
    }
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.getCouponButton.enabled = self.couponNumTextField.text.length > 7;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    // 禁止输入字母和数字以外的其他字符
    cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    // 禁止输入空格
    NSString *spaceFiltered = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:filtered] || ![string isEqualToString:spaceFiltered]) {
        return NO;
    }
    return YES;
}

- (NSDictionary *)codeDict {
    return @{
             @"030201" : @"兑换码输入错误",
             @"030202" : @"每张优惠券只能领用一次哦",
             @"030203" : @"已失效"
             };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
