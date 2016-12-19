//
//  GroupPeopleView.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupPeopleView.h"

@implementation GroupPeopleView

-(id)initWithFrame:(CGRect)frame andNumberOfPeople:(int)numberStr{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
#pragma mark - 1
        UIView *_upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        [self addSubview:_upView];
        
        for (int i=0; i<5; i++) {
            UIImageView *_peopleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20+((SCREEN_WIDTH -240)/4 +40)*i, 10, 40, 40)];
            _peopleImageView.layer.cornerRadius=20;
            _peopleImageView.layer.borderColor=[[UIColor colorWithHexString:@"0xf8f8f8"] CGColor];
            _peopleImageView.clipsToBounds=YES;
            _peopleImageView.layer.borderWidth=1;
            [_upView addSubview:_peopleImageView];
            if (i<numberStr) {
                _peopleImageView.image=IMAGE(@"图层-people");
            }else{
               _peopleImageView.image=IMAGE(@"椭圆-people");
            }
        }
        
#pragma mark - 2
        
        UIView *_middleView=[[UIView alloc]init];
        if (numberStr !=5) {
          _middleView.frame=CGRectMake(0, CGRectGetMaxY(_upView.frame),SCREEN_WIDTH, 80);
            
            UILabel *_ULabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            _ULabel.text=[NSString stringWithFormat:@"差参团%d人,快去分享吧!",5-numberStr];
            _ULabel.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _ULabel.font=[UIFont systemFontOfSize:16];
            _ULabel.textAlignment=NSTextAlignmentCenter;
            [_middleView addSubview:_ULabel];
            
            UILabel *_label1=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-230)/2, 40, 60, 30)];
            _label1.text=@"剩余";
            _label1.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label1.font=[UIFont systemFontOfSize:16];
            _label1.textAlignment=NSTextAlignmentCenter;
            [_middleView addSubview:_label1];
            
            UILabel *_label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame), 40, 30, 30)];
            _label2.text=@"23";
            _label2.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label2.font=[UIFont systemFontOfSize:16];
            _label2.textAlignment=NSTextAlignmentCenter;
            _label2.layer.borderWidth=1;
            _label2.layer.borderColor=[[UIColor colorWithHexString:@"0xfc9d15"] CGColor];
            [_middleView addSubview:_label2];
            
            UILabel *_label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label2.frame), 40, 10, 30)];
            _label3.text=@":";
            _label3.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label3.font=[UIFont systemFontOfSize:16];
            _label3.textAlignment=NSTextAlignmentCenter;
            [_middleView addSubview:_label3];
            
            UILabel *_label4=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label3.frame), 40, 30, 30)];
            _label4.text=@"40";
            _label4.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label4.font=[UIFont systemFontOfSize:16];
            _label4.textAlignment=NSTextAlignmentCenter;
            _label4.layer.borderWidth=1;
            _label4.layer.borderColor=[[UIColor colorWithHexString:@"0xfc9d15"] CGColor];
            [_middleView addSubview:_label4];
            
            UILabel *_label5=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label4.frame), 40, 10, 30)];
            _label5.text=@":";
            _label5.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label5.font=[UIFont systemFontOfSize:16];
            _label5.textAlignment=NSTextAlignmentCenter;
            [_middleView addSubview:_label5];
            
            
            UILabel *_label6=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label5.frame), 40, 30, 30)];
            _label6.text=@"20";
            _label6.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label6.font=[UIFont systemFontOfSize:16];
            _label6.textAlignment=NSTextAlignmentCenter;
            _label6.layer.borderWidth=1;
            _label6.layer.borderColor=[[UIColor colorWithHexString:@"0xfc9d15"] CGColor];
            [_middleView addSubview:_label6];
            
            
            UILabel *_label7=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label6.frame), 40, 60, 30)];
            _label7.text=@"结束";
            _label7.textColor=[UIColor colorWithHexString:@"0xfc9d15"];
            _label7.font=[UIFont systemFontOfSize:16];
            _label7.textAlignment=NSTextAlignmentCenter;
            [_middleView addSubview:_label7];
            
        }else{
            _middleView.frame=CGRectMake(0, CGRectGetMaxY(_upView.frame),SCREEN_WIDTH, 0);
        }
        [self addSubview:_middleView];
        
        
#pragma mark - 3
        UIView *_peopleView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_middleView.frame), SCREEN_WIDTH, 60*numberStr)];
        _peopleView.backgroundColor=[UIColor whiteColor];
        [self addSubview: _peopleView];
        
        for (int i=0; i<numberStr; i++) {
            UIView *_BpeopleView=[[UIView alloc]initWithFrame:CGRectMake(0, 60*i, SCREEN_WIDTH, 60)];
            [_peopleView addSubview:_BpeopleView];
            
            UIImageView *_BimageView=[[UIImageView alloc]init];
            [_BpeopleView addSubview:_BimageView];
            
            UIView *_BlineView=[[UIView alloc]initWithFrame:CGRectMake(0 , 59 , SCREEN_WIDTH, 1)];
            _BlineView.backgroundColor=[UIColor colorWithHexString:@"0x94ce2d"];
            [_BpeopleView addSubview:_BlineView];
            
            UIImageView *_BeopleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 40, 40)];
            _BeopleImageView.layer.cornerRadius=20;
            _BeopleImageView.layer.borderColor=[[UIColor colorWithHexString:@"0xf8f8f8"] CGColor];
            _BeopleImageView.layer.borderWidth=1;
            _BeopleImageView.clipsToBounds=YES;
            _BeopleImageView.image=IMAGE(@"图层-people");
            [_BpeopleView addSubview:_BeopleImageView];
            
            UILabel *_BLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_BeopleImageView.frame), 20, (SCREEN_WIDTH-120)/3, 30)];
            _BLabel.text=@"152****1453";
            _BLabel.font=[UIFont systemFontOfSize:10];
            _BLabel.textAlignment=NSTextAlignmentCenter;
            [_BpeopleView addSubview:_BLabel];
            
            UILabel *_BLabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_BLabel.frame), 20, (SCREEN_WIDTH-120)/3, 30)];
            _BLabel1.text=@"2015-11-25";
            _BLabel1.font=[UIFont systemFontOfSize:10];
            _BLabel1.textAlignment=NSTextAlignmentCenter;
            [_BpeopleView addSubview:_BLabel1];
            
            UILabel *_BLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_BLabel1.frame), 20, (SCREEN_WIDTH-120)/3, 30)];
            _BLabel2.text=@"10:20:12";
            _BLabel2.font=[UIFont systemFontOfSize:10];
            _BLabel2.textAlignment=NSTextAlignmentCenter;
            [_BpeopleView addSubview:_BLabel2];
            
            UILabel *_BLabel3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 40, 30)];
            _BLabel3.font=[UIFont systemFontOfSize:10];
            _BLabel3.textAlignment=NSTextAlignmentRight;
            [_BpeopleView addSubview:_BLabel3];
            
            if (i==0) {
                _BimageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 60);
                _BimageView.image=IMAGE(@"三角形people");
                _BLabel.textColor=[UIColor colorWithHexString:@"0xffffff"];
                _BLabel1.textColor=[UIColor colorWithHexString:@"0xffffff"];
                _BLabel2.textColor=[UIColor colorWithHexString:@"0xffffff"];
                _BLabel3.textColor=[UIColor colorWithHexString:@"0xffffff"];
                _BLabel3.text=@"开团";
            }else{
                _BimageView.frame=CGRectMake(0, 10, SCREEN_WIDTH, 50);
                _BimageView.image=IMAGE(@"矩形-17people");
                
                _BLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
                _BLabel1.textColor=[UIColor colorWithHexString:@"0x999999"];
                _BLabel2.textColor=[UIColor colorWithHexString:@"0x999999"];
                _BLabel3.textColor=[UIColor colorWithHexString:@"0x999999"];
                _BLabel3.text=@"参团";
                
                UIView *_BDlineView=[[UIView alloc]initWithFrame:CGRectMake(0 , 9, SCREEN_WIDTH, 1)];
                _BDlineView.backgroundColor=[UIColor colorWithHexString:@"0x94ce2d"];
                [_BpeopleView addSubview:_BDlineView];
            }
        }
#pragma mark - 4
        UIButton *_button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(40, CGRectGetMaxY(_peopleView.frame)+10, SCREEN_WIDTH-80, 40);
        _button.backgroundColor=[UIColor colorWithHexString:@"0xfc9d15"];
        _button.layer.cornerRadius=7;
        [_button setTitleColor:[UIColor colorWithHexString:@"0xffffff"] forState:UIControlStateNormal];
        [_button setTitle:@"分享好友" forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:17];
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
    }
    return self;
}
-(void)clickButton:(UIButton *)sender{
    _shar();
}
@end
