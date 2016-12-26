//
//  FSMeBottomView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSMeBottomView;

@protocol FSMeBottomViewDelegate <NSObject>

// 我的订单
- (void)fsMeBottonView:(FSMeBottomView *)fsMeBottomView myOrderButtonClick:(UIButton *)sender;

// 优惠券按钮
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView couponsButtonClick:(UIButton *)sender;

// 收藏按钮
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView collecButtonClick:(UIButton *)sender;

// 地址管理
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView addressButtonClick:(UIButton *)sender;

@end

@interface FSMeBottomView : UIView
//@property (strong, nonatomic) IBOutlet UIView *fsBottomView;

- (IBAction)myDingDanClick:(id)sender;

- (IBAction)myYouHuiQuanClick:(id)sender;

- (IBAction)myShouCangClick:(id)sender;

- (IBAction)myPingTuanClick:(id)sender;

- (IBAction)addressClick:(id)sender;

@property (nonatomic, weak) id<FSMeBottomViewDelegate> delegate;

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

@end
