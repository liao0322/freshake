//
//  FSMeHeadView.h
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNumView.h"

@class FSMeHeadView;

@protocol FSMeHeadViewDelegate <NSObject>

- (void)fsHeadView:(FSMeHeadView *)fsHeadView loginButtonTouchUpInside:(UIButton *)sender;

@end

@interface FSMeHeadView : UIView

@property (nonatomic, strong) UILabel *noticeLabel; // 未登录提示

@property (nonatomic, strong) UIButton *loginBtn; // 登录

@property (nonatomic, copy) UILabel *mobile; // 手机号

@property (nonatomic, copy) UILabel *name; // 昵称

@property (nonatomic, copy) UIImageView *rightImage;

@property (nonatomic, copy) UIImageView *icon;

//@property (nonatomic, copy) UIButton *isVip; // 会员

@property (nonatomic, copy) FSNumView *numView;

@property (nonatomic, copy) void(^pushLogin)(NSArray *arr);

@property (nonatomic, weak) id<FSMeHeadViewDelegate>delegate;

@property (nonatomic, copy) void(^goViewController)(UIViewController *viewController);

- (void)setUserData;

@end
