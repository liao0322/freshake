//
//  IconInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/4/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "IconInfoCell.h"

@implementation IconInfoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        [self addSubview:bgImageView];
        bgImageView.image = IMAGE(@"icon_背景");
        bgImageView.userInteractionEnabled = YES;
        
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 30, 80, 80)];
        _icon.userInteractionEnabled = YES;
        [bgImageView addSubview:_icon];
        _icon.layer.cornerRadius = _icon.frame.size.width/2;
        _icon.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
        [_icon addGestureRecognizer:tap];
        
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_icon.frame), SCREEN_WIDTH-30, 50)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = [UIColor colorWithHexString:@"0x262525"];
        _name.font = [UIFont systemFontOfSize:20];
        [bgImageView addSubview:_name];
        
        _mobile = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_name.frame)-10, SCREEN_WIDTH-30, 30)];
        _mobile.textAlignment = NSTextAlignmentCenter;
        _mobile.textColor = [UIColor colorWithHexString:@"0x262525"];
        _mobile.font = [UIFont systemFontOfSize:16];
        [bgImageView addSubview:_mobile];
        
    }
    return self;
}

-(void)tapclick:(UITapGestureRecognizer *)tap
{
    _pushLogin(nil);
}

-(void)setDataSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [_icon sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"] placeholderImage:IMAGE(@"列表页未成功图片")];
    if ([Tools isBlankString:[userDefaults objectForKey:@"nick_name"]])
    {
        _name.text = @"去取个昵称吧~";
    }
    else
    {
        _name.text = [ userDefaults objectForKey:@"nick_name"];
    }
    
    _mobile.text = [userDefaults objectForKey:@"mobile"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
