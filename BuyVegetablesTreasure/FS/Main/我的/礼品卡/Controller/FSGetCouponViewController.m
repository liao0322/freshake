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

@interface FSGetCouponViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet XFLimitedTextField *couponNumTextField;
@property (weak, nonatomic) IBOutlet UIView *textViewLine;


@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;

@property (weak, nonatomic) IBOutlet UIButton *getCouponButton;

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
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;
    
    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
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
        
    }
    else{
        return [XFProgressHUD showMessage:@"请输入8位兑换码" inView:self.view];
    }
    
}


- (IBAction)textFieldChanged:(UITextField *)sender {
    self.getCouponButton.enabled = self.couponNumTextField.text.length;
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
