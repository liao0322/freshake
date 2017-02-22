//
//  FSGetGiftCardViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/21.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGetGiftCardViewController.h"
#import "XFLimitedTextField.h"
#import "FSGiftCardProblemViewController.h"

@interface FSGetGiftCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *textBgView;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *cardNumTextField;

@property (weak, nonatomic) IBOutlet UITextField *cardPwdTextField;
@property (weak, nonatomic) IBOutlet UIView *textViewLine;
@property (weak, nonatomic) IBOutlet UIView *secondTextViewLine;

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UIButton *getExplainButton;
@property (weak, nonatomic) IBOutlet UIButton *getCardButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@end

@implementation FSGetGiftCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    
    self.title = @"领用礼品卡";
    
    self.cardNumTextField.maxCount = 12;
    self.cardNumTextField.borderStyle = UITextBorderStyleNone;
    self.cardNumTextField.tintColor = [UIColor colorDomina];
    
    self.textViewLine.backgroundColor = [UIColor colorSeparatorLine];
    self.secondTextViewLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.cardPwdTextField.borderStyle = UITextBorderStyleNone;
    self.cardPwdTextField.tintColor = [UIColor colorDomina];
    
    self.attentionLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 13.0 : 15.0];
    self.getExplainButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH == 320 ? 13.0 : 15.0];
    
    [self.getCardButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorDomina]] forState:UIControlStateNormal];
    [self.getCardButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorButtonHighlighted]] forState:UIControlStateHighlighted];
    self.getCardButton.layer.cornerRadius = 5.0f;
    self.getCardButton.layer.masksToBounds = YES;
    
    
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
    
}

// 如何领取按钮事件
- (IBAction)getExplainButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGiftCardProblemViewController new] animated:YES];
}

// 领取按钮事件
- (IBAction)getCardButtonAction:(id)sender {
    
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
