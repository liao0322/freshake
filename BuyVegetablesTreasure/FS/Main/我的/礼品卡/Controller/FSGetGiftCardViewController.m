//
//  FSGetGiftCardViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/21.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGetGiftCardViewController.h"
#import "XFLimitedTextField.h"
#import "FSGiftCartQuestionAnswerViewController.h"
#import "XYPAlterView.h"

@interface FSGetGiftCardViewController ()<XYPAlterViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *textBgView;

@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *cardPwdTextField;
@property (weak, nonatomic) IBOutlet UIView *textViewLine;
@property (weak, nonatomic) IBOutlet UIView *secondTextViewLine;

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UIButton *getExplainButton;
@property (weak, nonatomic) IBOutlet UIButton *getCardButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (copy, nonatomic, readonly) NSDictionary *codeDict;

@property (nonatomic) XYPAlterView *xypAlterView;
@property (nonatomic) UIView *darkView;
@property (nonatomic) NSString *stateCode;

@property (nonatomic, copy) NSString *uidString; // 用户id
@property (nonatomic, copy) NSString *userCode;  // 用户账号
@property (nonatomic, copy) NSString *userName;  // 用户名

@end

@implementation FSGetGiftCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    
    self.title = @"激活礼品卡";
    
    self.cardNumTextField.borderStyle = UITextBorderStyleNone;
    self.cardNumTextField.tintColor = [UIColor colorDomina];
    self.cardNumTextField.delegate = self;
    
    self.textViewLine.backgroundColor = [UIColor colorSeparatorLine];
    self.secondTextViewLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.cardPwdTextField.borderStyle = UITextBorderStyleNone;
    self.cardPwdTextField.maxCount = 6;
    self.cardPwdTextField.tintColor = [UIColor colorDomina];
    
    self.attentionLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 13.0 : 15.0];
    self.getExplainButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 13.0 : 15.0];
    
    [self.getCardButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.getCardButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.getCardButton.layer.cornerRadius = 5.0f;
    self.getCardButton.layer.masksToBounds = YES;
    
    self.darkView = [UIView new];
    self.darkView.userInteractionEnabled = YES;
    self.darkView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    self.xypAlterView = [XYPAlterView new];
    self.xypAlterView.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _uidString = [userDefaults objectForKey:@"UID"];
    _userCode = [userDefaults objectForKey:@"mobile"];
    _userName = [userDefaults objectForKey:@"nick_name"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    CGFloat margin = 15.0f;
    
    self.textBgView.x = 0;
    self.textBgView.y = 64;
    self.textBgView.width = width;
    
    self.cardNumTextField.x = margin;
    self.cardNumTextField.centerY = self.textBgView.height / 4;
    self.cardNumTextField.width = width - margin * 2;
    
    self.textViewLine.centerY = self.textBgView.height / 2;
    self.textViewLine.width = width;
    
    self.cardPwdTextField.x = margin;
    self.cardPwdTextField.centerY = self.textBgView.height * 3 / 4;
    self.cardPwdTextField.width = width - margin * 2;
    
    self.secondTextViewLine.width = width;
    
    self.attentionLabel.x = margin;
    self.attentionLabel.y = self.textBgView.bottom + margin;
    self.attentionLabel.width = SCREEN_WIDTH == 320 ? 215 : 254;
    
    self.getExplainButton.x = width - margin - self.getExplainButton.width;
    self.getExplainButton.centerY = self.attentionLabel.centerY;
    
    self.getCardButton.x = margin;
    self.getCardButton.y = self.attentionLabel.bottom + margin * 3;
    self.getCardButton.width = width - margin * 2;
    
    self.cardImageView.x = margin * 3;
    self.cardImageView.y = self.getCardButton.bottom + 28;
    self.cardImageView.width = width - margin * 6;
    self.cardImageView.height = 190 * (ScreenWidth / 375.0f);
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
    
    self.darkView.frame = [UIScreen mainScreen].bounds;
}

// 如何领取按钮事件
- (IBAction)getExplainButtonAction:(id)sender {
    FSGiftCartQuestionAnswerViewController *answerVC = [FSGiftCartQuestionAnswerViewController new];
    answerVC.Status = 0;
    [self.navigationController pushViewController:[FSGiftCartQuestionAnswerViewController new] animated:YES];
}

// 领取按钮事件
- (IBAction)getCardButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if (![Tools isBlankString:self.cardNumTextField.text]) {
        if (!(_cardNumTextField.text.length < 14)) {
            if (![Tools isBlankString:self.cardPwdTextField.text]) {
                if (!(self.cardPwdTextField.text.length < 6)) {
                    // 获取去除空格的卡号
                    NSString *cardNumberStr = [self.cardNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [self getGiftCardWithCardNumber:cardNumberStr passWord:self.cardPwdTextField.text];
                    
                } else {
                    
                    return [XFProgressHUD showMessage:@"请输入6位密码" inView:self.view];
                }
            } else {
                
                return [XFProgressHUD showMessage:@"密码不能为空" inView:self.view];
            }
        }else {
            
            return [XFProgressHUD showMessage:@"请输入12位卡券号" inView:self.view];
            
        }
    }else {
        return [XFProgressHUD showMessage:@"请输入卡券号" inView:self.view];
    }
}

- (void)getGiftCardWithCardNumber:(NSString *)cardNumber passWord:(NSString *)passWord {

    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    NSDictionary *cardDic = @{@"cardNo" : cardNumber,
                              @"cardPwd" : passWord};
    NSDictionary *chargeUserDic = @{@"userId" : _uidString,
                                    @"userCode" : _userCode,
                                    @"userName" : _userName};
    NSDictionary *operUserDic = @{@"userId" : _uidString,
                                  @"userCode" : _userCode,
                                  @"userName" : _userName};
    [parameterDict setValue:cardDic forKey:@"card"];
    [parameterDict setValue:chargeUserDic forKey:@"chargeUser"];
    [parameterDict setValue:operUserDic forKey:@"operUser"];
    [parameterDict setValue:@"004" forKey:@"syscode"];
    [parameterDict setValue:@"1" forKey:@"sourceCode"];
    
    [XFNetworking POST:GiftCardRecharge parameters:parameterDict success:^(id responseObject, NSInteger statusCode) {
        
        NSDictionary *dict = [self dictWithData:responseObject];
        self.stateCode = dict[@"code"];
        // 领取失败
        if (![self.stateCode isEqualToString:@"0"]) {
            
            if ([self.stateCode isEqualToString:@"030101"]) {
                
                return [XFProgressHUD showMessage:@"卡券号或密码错误" inView:self.view];
                
            } else {
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.darkView];
                [self.xypAlterView alertForGetGiftCardWithMessage:self.codeDict[dict[@"code"]] Money:nil Success:NO];
                
                return;
            }
        }
        
        // 领取成功
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.darkView];
        [self.xypAlterView alertForGetGiftCardWithMessage:@"礼品卡领用成功" Money:[NSString stringWithFormat:@"￥%.2f", [dict[@"result"] floatValue]] Success:YES];
        
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
-(void)removeSubviews{
    if (self.xypAlterView.subviews.count != 0) {
        for (UIView *view in self.xypAlterView.subviews) {
            [view removeFromSuperview];
        }
    }
}

// 卡号间隔格式化处理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    BOOL returnValue = YES;
    
    NSMutableString *newText = [NSMutableString stringWithCapacity:0];
    [newText appendString:self.cardNumTextField.text]; // 拿到原有的text,根据下面判断给它添加“ ”(空格);
    
    NSString *noBlankStr = [self.cardNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSInteger textLength = [noBlankStr length];
    
    if (string.length) {
        if (textLength < 12) { // 限制字符串长度12位
            
            if (textLength > 0 && textLength % 4 == 0) {
                newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [newText appendString:@" "];
                [newText appendString:string];
                self.cardNumTextField.text = newText;
                returnValue = NO; // 在此return NO,因为textField.text = newText;text已经替换好了,就不需要系统添加了,如果ruturnYES的话,会发现多出一个字符串
            } else {
                [newText appendString:string];
            }
        }else { // 比12位长在这里判断输入无效
            returnValue = NO;
        }
    }else { // 这里判断如果输入为空，保持原样
        [newText replaceCharactersInRange:range withString:string];
    }
    
    return returnValue;
    
}

- (NSDictionary *)codeDict {
    return @{
             @"000001" : @"礼品卡领用失败",
             @"030102" : @"已失效",
             @"030103" : @"已过期"
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
