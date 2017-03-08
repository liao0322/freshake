//
//  FSGiftCardViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/21.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGiftCardViewController.h"
#import "FSGetGiftCardViewController.h"
#import "FSGiftCartQuestionAnswerViewController.h"
#import "FSGetCouponViewController.h"
#import "FSCardExplainViewController.h"

@interface FSGiftCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIView *firstBgView;

// 礼品卡
@property (weak, nonatomic) IBOutlet UIImageView *getCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *getCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCardButton;

// 优惠券
@property (weak, nonatomic) IBOutlet UIImageView *getCouponImageView;
@property (weak, nonatomic) IBOutlet UILabel *getCouponLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCouponButton;

@property (weak, nonatomic) IBOutlet UIView *secondBgView;

// 礼品卡说明
@property (weak, nonatomic) IBOutlet UIImageView *cardExplainImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *cardExplainButton;

// 礼品卡领用说明
@property (weak, nonatomic) IBOutlet UIImageView *getExplainImageView;
@property (weak, nonatomic) IBOutlet UILabel *getExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *getExplainButton;

// 优惠券说明
@property (weak, nonatomic) IBOutlet UIImageView *couponExplainImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *couponExplainButton;

@property (weak, nonatomic) IBOutlet UIImageView *getCouponExplainImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *getCouponExplainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *getCouponExplainRowImage;
@property (weak, nonatomic) IBOutlet UIButton *getCouponExplainButton;


@property (weak, nonatomic) IBOutlet UIView *secondBgViewLine;

@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *lineThree;
@property (weak, nonatomic) IBOutlet UIView *lineFour;
@property (weak, nonatomic) IBOutlet UIView *lineFive;


@end

@implementation FSGiftCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    
    self.title = @"礼品卡";
        
    self.getCardLabel.textColor = [UIColor colorTextDomina];
    self.getCouponLabel.textColor = [UIColor colorTextDomina];
    self.cardExplainLabel.textColor = [UIColor colorTextDomina];
    self.couponExplainLabel.textColor = [UIColor colorTextDomina];
    self.getExplainLabel.textColor = [UIColor colorTextDomina];
    self.getCouponExplainLabel.textColor = [UIColor colorTextDomina];
    
    self.secondBgViewLine.backgroundColor = [UIColor colorSeparatorLine];
    
    self.lineOne.backgroundColor = [UIColor colorSeparatorLine];
    self.lineTwo.backgroundColor = [UIColor colorSeparatorLine];
    self.lineThree.backgroundColor = [UIColor colorSeparatorLine];
    self.lineFour.backgroundColor = [UIColor colorSeparatorLine];
    self.lineFive.backgroundColor = [UIColor colorSeparatorLine];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width = self.view.width;

    self.bgImageView.x = 0;
    self.bgImageView.y = 64;
    self.bgImageView.width = width;
    self.bgImageView.height = width / (375 / 398.0f);
    
}

// 领用礼品卡事件
- (IBAction)getCardButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGetGiftCardViewController new] animated:YES];
    
}

// 领用优惠券事件
- (IBAction)getCouponButtonAction:(id)sender {
    [self.navigationController pushViewController:[FSGetCouponViewController new] animated:YES];
}


// 礼品卡说明事件
- (IBAction)cardExplainButtonAction:(id)sender {
    FSCardExplainViewController *gCExplainVC = [FSCardExplainViewController new];
    gCExplainVC.Status = 0;
    [self.navigationController pushViewController:gCExplainVC animated:YES];
}

// 领用礼品卡说明事件
- (IBAction)getExplainButtonAction:(id)sender {
    FSGiftCartQuestionAnswerViewController *answerVC = [FSGiftCartQuestionAnswerViewController new];
    answerVC.Status = 0;
    [self.navigationController pushViewController:answerVC animated:YES];
}

// 优惠券说明事件
- (IBAction)couponExplainButtonAction:(id)sender {
    
    FSCardExplainViewController *GCExplainVC = [FSCardExplainViewController new];
    GCExplainVC.Status = 1;
    [self.navigationController pushViewController:GCExplainVC animated:YES];
    
}

// 领用优惠券说明事件
- (IBAction)getCouponExplainButtonAction:(id)sender {
    FSGiftCartQuestionAnswerViewController *AnswerVC = [FSGiftCartQuestionAnswerViewController new];
    AnswerVC.Status = 1;
    [self.navigationController pushViewController:AnswerVC animated:YES];
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
