//
//  GroupFootView.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupFootView.h"

@implementation GroupFootView
-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _butStr=@"1";
        for (int i=0; i<3; i++) {
            UIView *_bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*i, SCREEN_WIDTH, 50)];
            _bottomView.backgroundColor=[UIColor whiteColor];
            [self addSubview: _bottomView];
            
            UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 1)];
            _lineView.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
            [_bottomView addSubview:_lineView];
            
            UIImageView *_bImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
            [_bottomView addSubview:_bImageView];
            
            UILabel *_bLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 30)];
            _bLabel.font=[UIFont systemFontOfSize:14];
            [_bottomView addSubview:_bLabel];
            
            if (i != 0 ) {
                UIImageView *_leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 20, 10, 10)];
                [_bottomView addSubview:_leftImageView];
                UIButton *_Bbutton=[UIButton buttonWithType:UIButtonTypeCustom];
                _Bbutton.frame=CGRectMake(0, 0, SCREEN_WIDTH, 50);
                [_Bbutton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:_Bbutton];
                switch (i) {
                    case 1:
                        _leftImageView.image=IMAGE(@"勾图标");
                        _leftImageView.tag=101;
                        _Bbutton.tag=100;
                        break;
                        
                    default:
                        _leftImageView.image=IMAGE(@"1");
                        _leftImageView.tag=201;
                        _Bbutton.tag=200;
                        break;
                }
            }
            
            switch (i) {
                case 0:
                    _bImageView.image=[IMAGE(@"选择支付方式图标") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    _bImageView.tintColor = [UIColor colorDomina];
                    _bLabel.text=@"选择支付方法";
                    _bLabel.textColor=[UIColor colorWithHexString:@"0xff6600"];
                    break;
                   
                case 1:
                    _bImageView.image=IMAGE(@"微信支付图标");
                    _bLabel.text=@"微信支付";
                    _bLabel.textColor=[UIColor colorWithHexString:@"0x606060"];
                    break;
                    
                default:
                    _bImageView.image=IMAGE(@"支付宝图标");
                    _bLabel.text=@"支付宝支付";
                    _bLabel.textColor=[UIColor colorWithHexString:@"0x606060"];
                    break;
            }
        }
        
        UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0 , 149 , SCREEN_WIDTH, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        [self addSubview:_lineView];
        
        UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(40, 160, SCREEN_WIDTH-80, 40);
        _button.tag=300;
        _button.backgroundColor=[UIColor colorWithHexString:@"0xfc9d15"];
        _button.layer.cornerRadius=7;
        [_button setTitleColor:[UIColor colorWithHexString:@"0xffffff"] forState:UIControlStateNormal];
        [_button setTitle:@"立即支付" forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:17];
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        
    }
    return self;
}
-(void)clickButton:(UIButton *)sender{
     UIImageView *_Uimage=(UIImageView *)[self viewWithTag:101];
     UIImageView *_DmageV=(UIImageView *)[self viewWithTag:201];
    switch (sender.tag) {
        case 100:
           _DmageV.image=IMAGE(@"1");
           _Uimage.image=IMAGE(@"勾图标");
            _butStr=@"1";
            break;
        case 200:
            _Uimage.image=IMAGE(@"1");
            _DmageV.image=IMAGE(@"勾图标");
            _butStr=@"2";
            break;
        default:
            _goPay(_butStr);
            break;
    }
}

@end
