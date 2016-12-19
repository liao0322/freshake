//
//  FSHomeFourButtonView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseView.h"
@class XFVerticalButton;
@class FSHomeFourButtonView;

@protocol FSHomeFourButtonViewDelegate <NSObject>

/// 拼团按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView togetherBuyButtonTouchUpInside:(XFVerticalButton *)sender;

/// 充值按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView topUpButtonTouchUpInside:(XFVerticalButton *)sender;

/// 新品按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView newCommodityButtonTouchUpInside:(XFVerticalButton *)sender;

/// 促销按钮点击事件
- (void)fourButtonView:(FSHomeFourButtonView *)fourButtonView salesPromotionButtonTouchUpInside:(XFVerticalButton *)sender;

@end


@interface FSHomeFourButtonView : FSBaseView

@property (weak, nonatomic) id<FSHomeFourButtonViewDelegate> delegate;

/// 拼团
@property (weak, nonatomic) IBOutlet XFVerticalButton *togetherBuyButton;

/// 充值
@property (weak, nonatomic) IBOutlet XFVerticalButton *topUpButton;

/// 新品
@property (weak, nonatomic) IBOutlet XFVerticalButton *commodityButton;

/// 促销
@property (weak, nonatomic) IBOutlet XFVerticalButton *salesPromotionButton;
@end
