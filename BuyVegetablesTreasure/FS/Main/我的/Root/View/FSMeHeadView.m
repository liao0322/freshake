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
    bgImageView.image = IMAGE(@"FSHead背景");
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    
    bgImageView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(215);
    
    // 头像
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.layer.cornerRadius = 35;
    _icon.clipsToBounds = YES;
    [bgImageView addSubview:_icon];
    
    _icon.sd_layout
    .leftSpaceToView(bgImageView, 22)
    .topSpaceToView(bgImageView, 64)
    .widthIs(70)
    .heightIs(70);
    
    UIButton *myMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myMessageBtn.frame = CGRectMake(0, 64, ScreenWidth, bgImageView.frame.size.height - 64 - 50);
    [myMessageBtn addTarget:self action:@selector(myMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:myMessageBtn];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
//    [_icon addGestureRecognizer:tap];
    
       // 用户昵称
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 40, 74, SCREEN_WIDTH / 2, 18)];
//    _name.backgroundColor = [UIColor whiteColor];
//    _name.layer.masksToBounds = YES;
//    _name.layer.cornerRadius = 8;
    _name.textAlignment = NSTextAlignmentLeft;
    _name.textColor = [UIColor colorWithHexString:@"0x404040"];
    [_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    [bgImageView addSubview:_name];
    
    // 用户手机号
    _mobile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame) + 40, CGRectGetMaxY(_name.frame) + 15, SCREEN_WIDTH / 2, 20)];
    //    _mobile.textAlignment = NSTextAlignmentLeft;
    _mobile.textColor = [UIColor whiteColor];
    [_mobile setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
    [bgImageView addSubview:_mobile];
    

    
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
    .topSpaceToView(bgImageView, 91)
    .widthIs(10)
    .heightIs(20);
    
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
    [bgImageView addSubview:_noticeLabel];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(ScreenWidth / 2 - 60, CGRectGetMaxY(_noticeLabel.frame) + 10, 93, 34);
    _loginBtn.center = CGPointMake(ScreenWidth / 2, bgImageView.frame.size.height / 2 + 20);
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"0x71ab19"];
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:_loginBtn];
}

- (void)myMessageClick:(UIButton *)sender {
    
    NSLog(@"设置个人信息");
    if ([self.delegate respondsToSelector:@selector(fsHeadView:myMessageButtonClick:)]) {
        [self.delegate fsHeadView:self myMessageButtonClick:sender];
    }
//    _pushLogin(nil);
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
        
        _noticeLabel.hidden = YES;
        _loginBtn.hidden = YES;
        
        
        if ([Tools isBlankString:[userDefaults objectForKey:@"nick_name"]]) {
            _name.text = @"去取个昵称吧~";
        }
        else {
            _name.text = [userDefaults objectForKey:@"nick_name"];
        }
        
        NSString *mobileStr = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"mobile"]];
        
        if (mobileStr.length >= 11) {
            _mobile.text = [mobileStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        } else {
            _mobile.text = [userDefaults objectForKey:@"mobile"];
        }

        
        
        
        [_icon sd_setImageWithURL:[userDefaults objectForKey:@"avatar"] placeholderImage:IMAGE(@"FS头像") options:SDWebImageRetryFailed];
        
    } else {
        
        _noticeLabel.hidden = NO;
        _loginBtn.hidden = NO;
        
        _icon.hidden = YES;
        _name.hidden = YES;
        _mobile.hidden = YES;
        _numView.hidden = YES;
        _rightImage.hidden = YES;
    }
}

- (void)setpointCountWithModel:(FSMeModel *)model {
    _numView.pointLabel.text = model.point;
    
    _numView.balanceLabel.text = [NSString stringWithFormat:@"￥%@", model.amount];
    
    _numView.couponLabel.text = model.tickNum;

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
