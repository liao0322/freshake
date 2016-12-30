//
//  FSHomeFourButtonView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHomeFourButtonView.h"
#import "XFVerticalButton.h"

#define FONT_SIZE 14

@implementation FSHomeFourButtonView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.togetherBuyButton.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:FONT_SIZE];
    self.topUpButton.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:FONT_SIZE];
    self.commodityButton.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:FONT_SIZE];
    self.salesPromotionButton.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:FONT_SIZE];

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    CGFloat buttonWidth = self.togetherBuyButton.width;
//    CGFloat horizontalInset = 30;
    
    CGFloat spacing = (self.width - buttonWidth * 4) / 5.0f;
    
    
    self.togetherBuyButton.x = spacing;
    self.topUpButton.x = self.togetherBuyButton.right + spacing;
    self.commodityButton.x = self.topUpButton.right + spacing;
    self.salesPromotionButton.x = self.commodityButton.right + spacing;

    
}

/// 拼团
- (IBAction)togetherBuyButtonTouchUpInside:(XFVerticalButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fourButtonView:togetherBuyButtonTouchUpInside:)]) {
        [self.delegate fourButtonView:self togetherBuyButtonTouchUpInside:sender];
    }
}

/// 充值
- (IBAction)topUpButtonTouchUpInside:(XFVerticalButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fourButtonView:topUpButtonTouchUpInside:)]) {
        [self.delegate fourButtonView:self topUpButtonTouchUpInside:sender];
    }
}

/// 新品
- (IBAction)commodityButtonTouchUpInside:(XFVerticalButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fourButtonView:newCommodityButtonTouchUpInside:)]) {
        [self.delegate fourButtonView:self newCommodityButtonTouchUpInside:sender];
    }
}

/// 促销
- (IBAction)salesPromotionButtonTouchUpInside:(XFVerticalButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fourButtonView:salesPromotionButtonTouchUpInside:)]) {
        [self.delegate fourButtonView:self salesPromotionButtonTouchUpInside:sender];
    }
}
@end
