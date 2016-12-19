//
//  HotTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/4.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (void)SetupUIWithArray:(NSArray *)arr
{
    for (id view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    float width =70*(SCREEN_WIDTH/320);
    float height = 35;
    float jili=20/3*(SCREEN_WIDTH/320);

    for (int i = 0; i < arr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame  = CGRectMake(10*(SCREEN_WIDTH/320) + (width+jili)*(i%4),(height +10)*(i/4), width, height);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x454c53"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:IMAGE(@"搜索边框") forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.cornerRadius = 35/2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"0xd7d7d7"].CGColor;
        
        [self addSubview:btn];
    }
}
-(void)clickButton:(UIButton *)sender{
    _GoSearch(sender.tag);
}

@end
