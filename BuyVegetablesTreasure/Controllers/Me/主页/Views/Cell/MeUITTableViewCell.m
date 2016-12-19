//
//  MeUITTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/21.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "MeUITTableViewCell.h"

@implementation MeUITTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = IMAGE(@"icon_背景");
    bgImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImageView];
    
    bgImageView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(260);
    
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    _icon.layer.cornerRadius = 40;
    _icon.clipsToBounds = YES;
    [bgImageView addSubview:_icon];
    
    _icon.sd_layout
    .centerXEqualToView(bgImageView)
    .topSpaceToView(bgImageView, 30)
    .widthIs(80)
    .heightIs(80);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapclick:)];
    [_icon addGestureRecognizer:tap];
    
    _name = [UILabel new];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.textColor = [UIColor colorWithHexString:@"0x262525"];
    _name.font = [UIFont systemFontOfSize:20];
    [_name setSingleLineAutoResizeWithMaxWidth:ScreenWidth / 2];
    [bgImageView addSubview:_name];
    
    _name.sd_layout
    .centerXEqualToView(bgImageView)
    .topSpaceToView(_icon, 5)
    .heightIs(20);
    
    _isVip = [UIButton buttonWithType:UIButtonTypeCustom];
    [_isVip setImage:IMAGE(@"非会员") forState:UIControlStateNormal];
    [bgImageView addSubview:_isVip];
    
    _isVip.sd_layout
    .centerYEqualToView(_name)
    .rightSpaceToView(_name, 10)
    .widthIs(15)
    .heightIs(15);
    
    _mobile = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_name.frame)-10, SCREEN_WIDTH-30, 30)];
    _mobile.textAlignment = NSTextAlignmentCenter;
    _mobile.textColor = [UIColor colorWithHexString:@"0x262525"];
    _mobile.font = [UIFont systemFontOfSize:16];
    [_mobile setSingleLineAutoResizeWithMaxWidth:ScreenWidth / 2];
    [bgImageView addSubview:_mobile];
    
    _mobile.sd_layout
    .centerXEqualToView(bgImageView)
    .topSpaceToView(_name, 5)
    .heightIs(15);
    
    _numView = [[NumView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    [bgImageView addSubview:_numView];
    
    _numView.sd_layout
    .leftEqualToView(bgImageView)
    .rightEqualToView(bgImageView)
    .bottomSpaceToView(bgImageView, 0)
    .heightIs(70);
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 20)];
    _nameLabel.text = @"您还未登录/注册";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:_nameLabel];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(ScreenWidth / 2 - 60, CGRectGetMaxY(_nameLabel.frame) + 10, 130, 35);
    _loginBtn.backgroundColor = Color;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:_loginBtn];
}

- (void)tapclick:(UITapGestureRecognizer *)tap {
    _pushLogin(nil);
}

-(void)setDataSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"UID"]) {
        
        _icon.hidden = NO;
        _name.hidden = NO;
        _mobile.hidden = NO;
        _numView.hidden = NO;
        _isVip.hidden = NO;
        
        _nameLabel.hidden = YES;
        _loginBtn.hidden = YES;
        
        int group_id = [[userDefaults objectForKey:@"group_id"] intValue];
        if (group_id == 1) {
            [_isVip setImage:IMAGE(@"非会员") forState:UIControlStateNormal];
        }
        else if (group_id > 1) {
            [_isVip setImage:IMAGE(@"会员") forState:UIControlStateNormal];
        }
        
        if ([Tools isBlankString:[userDefaults objectForKey:@"nick_name"]]) {
            _name.text = @"去取个昵称吧~";
        }
        else {
            _name.text = [ userDefaults objectForKey:@"nick_name"];
        }
        
        _mobile.text = [userDefaults objectForKey:@"mobile"];
        
        [_icon sd_setImageWithURL:[userDefaults objectForKey:@"avatar"] placeholderImage:IMAGE(@"列表页未成功图片") options:SDWebImageRetryFailed];
    }
    else {
        
        _nameLabel.hidden = NO;
        _loginBtn.hidden = NO;
        
        _isVip.hidden = YES;
        _icon.hidden = YES;
        _name.hidden = YES;
        _mobile.hidden = YES;
        _numView.hidden = YES;
    }
}

- (void)goLogin {
    _goViewController([NSClassFromString(@"ShopLoginViewController") new]);
}


@end
