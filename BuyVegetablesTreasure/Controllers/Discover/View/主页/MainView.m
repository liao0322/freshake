//
//  MainView.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MainView.h"
#import "RockViewController.h"
#import "ScanViewController.h"

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self SetUI];
    }
    return self;
}
-(void)SetUI
{
    
    float width = 200,height = 200;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5){
        width = 150;
        height = 150;
    }else if (IS_IPAD){
        width = 250;
        height = 250;
    }
    
    float _space1 = 50;
    if (IS_IPAD) {
        _space1 = 100;
    }
    
    UIButton *rockBgButon = [UIButton buttonWithType:UIButtonTypeCustom];
    rockBgButon.frame = CGRectMake(SCREEN_WIDTH/2-width/2,(SCREEN_HEIGHT/2-_space1)-height-30, width, height);
    rockBgButon.tag = 11;
    [self addSubview:rockBgButon];
    [rockBgButon addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float imagewidth = 120,imageheight = 120;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5){
        imagewidth = 90;
        imageheight = 90;
    }else if (IS_IPAD){
        imagewidth = 180;
        imageheight = 180;
    }
    
    
    
    UIImageView *rockImage = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-imagewidth/2, 10, imagewidth, imageheight)];
    rockImage.image = IMAGE(@"摇一摇");
//    rockImage.contentMode = UIViewContentModeCenter;
    [rockBgButon addSubview:rockImage];
    
    UILabel *rockLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rockImage.frame)+10, width, 30)];
    rockLabel.text = @"摇一摇";
    rockLabel.textColor = [UIColor colorWithHexString:@"0x151515"];
    rockLabel.font = [UIFont systemFontOfSize:18];
    rockLabel.textAlignment = NSTextAlignmentCenter;
    [rockBgButon addSubview:rockLabel];
    
    
    float _space2 = 30;
    if (IS_IPAD) {
        _space2 = 10;
    }
    
    UIButton *scanBgButon = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBgButon.frame = CGRectMake(SCREEN_WIDTH/2-width/2,SCREEN_HEIGHT/2-_space2, width, height);
    scanBgButon.tag = 12;
    [self addSubview:scanBgButon];
    [scanBgButon addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *scanImage = [[UIImageView alloc]initWithFrame:CGRectMake(width/2-imagewidth/2, 0, imagewidth, imageheight)];
    scanImage.image = IMAGE(@"扫一扫");
    scanImage.contentMode = UIViewContentModeScaleAspectFit;
    [scanBgButon addSubview:scanImage];
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scanImage.frame)+10, width, 30)];
    scanLabel.text = @"扫一扫";
    scanLabel.textColor = [UIColor colorWithHexString:@"0x151515"];
    scanLabel.font = [UIFont systemFontOfSize:18];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [scanBgButon addSubview:scanLabel];
    
}
-(void)btnClick:(UIButton *)btn
{
    _BtnClick(btn.tag);
}
@end
