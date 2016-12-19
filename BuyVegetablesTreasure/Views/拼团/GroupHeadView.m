//
//  GroupHeadView.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupHeadView.h"

@implementation GroupHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _storeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-100, 30)];
        _storeLabel.font=[UIFont systemFontOfSize:18];
        _storeLabel.textColor=[UIColor colorWithHexString:@"0x999999"];
        [self addSubview:_storeLabel];
        
        UIImageView *_rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 16, 10, 18)];
        _rightImageView.image=IMAGE(@"更多箭头");
        [self addSubview:_rightImageView];
        
        UIView *_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"0xD7D7D7"];
        [self addSubview:_lineView];
        
        UIButton *_choiceButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _choiceButton.frame=CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [_choiceButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_choiceButton];
    }
    return self;
}
-(void)clickButton:(UIButton *)sender{
    _choiceStore();
}
@end
