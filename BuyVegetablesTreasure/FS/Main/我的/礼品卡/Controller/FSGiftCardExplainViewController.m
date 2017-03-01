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
@property (copy, nonatomic) NSString *explainString;

@end

#define LINE_SPACING 8.0f

@implementation FSGiftCardExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initialization {
    [super initialization];
    self.title = @"什么是礼品卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.giftCardExplainLabel = [UILabel new];
    self.giftCardExplainLabel.numberOfLines = 0;
    self.giftCardExplainLabel.font = [UIFont systemFontOfSize:14.0];
    self.giftCardExplainLabel.textColor = [UIColor colorTextDomina];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.explainString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINE_SPACING];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.explainString length])];
    self.giftCardExplainLabel.attributedText = attributedString;
    
    [self.giftCardExplainLabel sizeToFit];
    
}

- (void)addSubviews {
    [self.view addSubview:self.giftCardExplainLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.giftCardExplainLabel.x = 15.0;
    self.giftCardExplainLabel.y = 64.0;
    self.giftCardExplainLabel.width = SCREEN_WIDTH - 30;
    self.giftCardExplainLabel.height = CGRectGetHeight(self.giftCardExplainLabel.frame) + 40;
  
}

- (NSString *)explainString {
    return @"鲜摇派礼品卡是鲜摇派独家发行的预付卡，目前仅限上海地区使用，可用于在鲜摇派快捷安全地支付各类产品订单。";
}


@end
