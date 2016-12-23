//
//  FSMeHeadView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMeHeadView.h"
#import "MoreViewController.h"
#import "NSObject+Ext.h"
#import "FSLoginViewController.h"

#import "FSBaseTabBarController.h"

@implementation FSMeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = IMAGE(@"FS背景");
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    bgImageView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(200);
    
    // 头像
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.layer.cornerRadius = 35;
    _icon.clipsToBounds = YES;
    [bgImageView addSubview:_icon];
    
    _icon.sd_layout
    .leftSpaceToView(bgImageView, 22)
    .topSpaceToView(bgImageView, 50)
    .widthIs(70)
    .heightIs(70);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
    [_icon addGestureRecognizer:tap];
    
    // 用户手机号
    _mobile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 40, 60, SCREEN_WIDTH / 2, 20)];
//    _mobile.textAlignment = NSTextAlignmentLeft;
    _mobile.textColor = [UIColor whiteColor];
    [_mobile setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    [bgImageView addSubview:_mobile];
    
    // 用户昵称
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 40, CGRectGetMaxY(_mobile.frame) + 10, 100, 18)];
    _name.backgroundColor = [UIColor whiteColor];
    _name.layer.masksToBounds = YES;
    _name.layer.cornerRadius = 8;
    _name.textAlignment = NSTextAlignmentCenter;
    _name.textColor = [UIColor colorWithHexString:@"0xf18316"];
    _name.font = [UIFont systemFontOfSize:14.0];
    [bgImageView addSubview:_name];
    
    // 设置 
//    UIImageView *setImage = [UIImageView new];
//    setImage.image = IMAGE(@"FS设置");
//    setImage.userInteractionEnabled = YES;
//    [bgImageView addSubview:setImage];
//    
//    setImage.sd_layout
//    .rightSpaceToView(bgImageView, 22)
//    .topSpaceToView(bgImageView, 20)
//    .widthIs(30)
//    .heightIs(30);
    
//    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setClick:)];
//    [setImage addGestureRecognizer:setTap];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = IMAGE(@"FS进入");
    [bgImageView addSubview:_rightImage];
    
    _rightImage.sd_layout
    .rightSpaceToView(bgImageView, 22)
    .topSpaceToView(bgImageView, 65)
    .widthIs(15)
    .heightIs(30);
    
    _numView = [[FSNumView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    _numView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [bgImageView addSubview:_numView];
    
    _numView.sd_layout
    .leftEqualToView(bgImageView)
    .rightEqualToView(bgImageView)
    .bottomSpaceToView(bgImageView, 0)
    .heightIs(50);
    
    _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, ScreenWidth, 20)];
    _noticeLabel.text = @"您还未登录/注册";
    _noticeLabel.font = [UIFont systemFontOfSize:17.0];
    _noticeLabel.textColor = [UIColor whiteColor];
    _noticeLabel.textAlignment = NSTextAlignmentCenter;
    _noticeLabel.hidden = YES;
    [bgImageView addSubview:_noticeLabel];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(ScreenWidth / 2 - 60, CGRectGetMaxY(_noticeLabel.frame) + 10, 93, 34);
    _loginBtn.center = CGPointMake(ScreenWidth / 2, bgImageView.frame.size.height / 2 + 20);
    _loginBtn.backgroundColor = [UIColor colorOrange];
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.hidden = YES;
    [bgImageView addSubview:_loginBtn];
}

- (void)iconClick:(UITapGestureRecognizer *)tap {
    _pushLogin(nil);
}

//- (void)setClick:(UITapGestureRecognizer *)tap {
//
//    NSLog(@"跳转到设置页面");
//}

- (void)setUserData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"UID"]) {
        _icon.hidden = NO;
        _name.hidden = NO;
        _mobile.hidden = NO;
        _numView.hidden = NO;
        _rightImage.hidden = NO;
        
        if ([Tools isBlankString:[userDefaults objectForKey:@"nick_name"]]) {
            _name.text = @"去取个昵称吧~";
        }
        else {
            _name.text = [userDefaults objectForKey:@"nick_name"];
        }
        
        _mobile.text = [userDefaults objectForKey:@"mobile"];
        
        [_icon sd_setImageWithURL:[userDefaults objectForKey:@"avatar"] placeholderImage:IMAGE(@"FS头像") options:SDWebImageRetryFailed];
        
    } else {
        
        _icon.hidden = YES;
        _name.hidden = YES;
        _mobile.hidden = YES;
        _numView.hidden = YES;
        _rightImage.hidden = YES;
    }
}


- (void)goLogin:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(fsHeadView:loginButtonTouchUpInside:)]) {
        [self.delegate fsHeadView:self loginButtonTouchUpInside:sender];
    }
//    ShopLoginViewController *shopVC = [ShopLoginViewController new];
//    FSMyCouponsViewController *coupVC = [FSMyCouponsViewController new];
//    FSBaseTabBarController *tabbarVC = [self getCurrentVC];
//    UINavigationController *nav = tabbarVC.viewControllers[3];
//    [nav pushViewController:coupVC animated:YES];
    
//    _goViewController([NSClassFromString(@"ShopLoginViewController") new]);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
