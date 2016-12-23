//
//  FSMeBottomView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMeBottomView.h"
#import "FSMyCouponsViewController.h"

@interface FSMeBottomView ()

@property (nonatomic, strong) FSMeBottomView *fsMeBottomView;

@end

@implementation FSMeBottomView


// 我的订单
- (IBAction)myDingDanClick:(id)sender {
}

// 我的优惠券
- (IBAction)myYouHuiQuanClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(fsMeBottomView:couponsButtonClick:)]) {
        [self.delegate fsMeBottomView:self couponsButtonClick:sender];
    }
    
}

// 我的收藏
- (IBAction)myShouCangClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(fsMeBottomView:collecButtonClick:)]) {
        [self.delegate fsMeBottomView:self collecButtonClick:sender];
    }

}

// 我的拼团
- (IBAction)myPingTuanClick:(id)sender {
}

// 地址管理
- (IBAction)addressClick:(id)sender {
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
