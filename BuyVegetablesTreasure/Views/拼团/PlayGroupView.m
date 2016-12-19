//
//  PlayGroupView.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/26.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "PlayGroupView.h"

@implementation PlayGroupView

-(id)initWithFrame:(CGRect)frame andShowNumber:(NSString *)numberStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _NStr=numberStr;
        
        UILabel *_leftlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        _leftlabel.textColor=[UIColor colorWithHexString:@"0x999999"];
        _leftlabel.text=@"拼团玩法";
        _leftlabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:_leftlabel];
        
        UILabel *_rightlabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 10, 100, 20)];
        _rightlabel.textColor=Color;
        _rightlabel.text=@"查看详情 >";
        _rightlabel.textAlignment=NSTextAlignmentRight;
        _rightlabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:_rightlabel];
        
        UIButton *_rBut=[UIButton buttonWithType:UIButtonTypeCustom];
        _rBut.frame=CGRectMake(SCREEN_WIDTH-120, 10, 100, 20);
        [_rBut addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rBut];
        
        for (int i =0; i<3; i++) {
            UIView *_lineView=[[UIView alloc]init];
            switch (i) {
                case 0:
                    _lineView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 1);
                    break;
                case 1:
                    _lineView.frame=CGRectMake(0, 39, SCREEN_WIDTH, 1);
                    break;
                default:
                    _lineView.frame=CGRectMake(0, 89, SCREEN_WIDTH, 1);
                    break;
            }
            _lineView.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
            [self addSubview:_lineView];
        }
        
        
        int  Gwidth=(SCREEN_WIDTH-40)/4;
        for (int i =0; i<4; i++) {
            UIView *_Tview=[[UIView alloc]initWithFrame:CGRectMake(20+Gwidth*i, 55, Gwidth, 20)];
            [self addSubview:_Tview];
            
            UIImageView *_TimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [_Tview addSubview:_TimageView];
            
            UILabel*_TLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            _TLabel.font=[UIFont systemFontOfSize:10];
            _TLabel.textAlignment=NSTextAlignmentCenter;
            [_Tview addSubview:_TLabel];
            
            UILabel *_upLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, Gwidth-30, 10)];
            _upLabel.font=[UIFont systemFontOfSize:8];
            [_Tview addSubview: _upLabel];
            
            UILabel *_downLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, Gwidth-30, 10)];
            _downLabel.font=[UIFont systemFontOfSize:8];
            [_Tview addSubview: _downLabel];
            
            switch (i) {
                case 0:
                    _TLabel.text=@"1";
                    _upLabel.text=@"选择";
                    _downLabel.text=@"心仪商品";
                    break;
                case 1:
                    _TLabel.text=@"2";
                    _upLabel.text=@"支付开团";
                    _downLabel.text=@"或参与";
                    break;
                case 2:
                    _TLabel.text=@"3";
                    _upLabel.text=@"等待好友";
                    _downLabel.text=@"参与支付";
                    break;
                default:
                    _TLabel.text=@"4";
                    _upLabel.text=@"达到人数";
                    _downLabel.text=@"团购成功";
                    break;
            }
            
            if (i==[_NStr intValue]-1) {
                _TimageView.image=IMAGE(@"选心仪高品");
                _TLabel.textColor=[UIColor colorWithHexString:@"0xffffff"];
                _upLabel.textColor=Color;
                _downLabel.textColor=Color;
            }else{
                _TimageView.image=IMAGE(@"第二步");
                _TLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
                _upLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
                _downLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
            }
        }
    }
    return self;
}
-(void)clickBut:(UIButton *)sender{
    _goPlayGroup();
}
@end
