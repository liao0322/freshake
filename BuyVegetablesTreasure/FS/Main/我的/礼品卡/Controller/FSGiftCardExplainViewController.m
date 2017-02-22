//
//  FSGiftCardExplainViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/2/22.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSGiftCardExplainViewController.h"

@interface FSGiftCardExplainViewController ()

@property (nonatomic, strong) UILabel *giftCardExplainLabel;

@end

@implementation FSGiftCardExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    self.title = @"什么是礼品卡";
    
    self.giftCardExplainLabel = [UILabel new];
    self.giftCardExplainLabel.text = @"鲜摇派礼品卡是鲜摇派独家发行的预付卡，目前仅限上海地区使用，可用于在鲜摇派快捷安全地支付各类产品订单。";
    self.giftCardExplainLabel.numberOfLines = 0;
    self.giftCardExplainLabel.font = [UIFont systemFontOfSize:14.0];
    self.giftCardExplainLabel.textColor = [UIColor colorTextDomina];
//    [self.view addSubview:self.giftCardExplainLabel];
    [self.giftCardExplainLabel sizeToFit];
    
}

- (void)addSubviews {
    [self.view addSubview:self.giftCardExplainLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.giftCardExplainLabel.x = 15.0;
    self.giftCardExplainLabel.y = 76;
    self.giftCardExplainLabel.width = SCREEN_WIDTH - 30;
    
    self.giftCardExplainLabel.sd_layout
    .autoHeightRatio(0);
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
