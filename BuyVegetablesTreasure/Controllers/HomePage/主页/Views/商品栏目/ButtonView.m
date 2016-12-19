//
//  ButtonView.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

{
    NSArray *titleArray;
    NSArray *image;
    UIImageView *imageView;
    UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        image = @[@"拼团Icon",@"摇一摇Icon",@"新品Icon",@"促销Icon"];
        titleArray = @[@"拼团",@"摇一摇",@"厨艺节目",@"促销"];
        
        for (int i = 0; i < titleArray.count; i++)
        {
            int btnWidth = SCREEN_WIDTH / titleArray.count;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height);
            button.tag = i + 70;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, button.frame.size.width, 50)];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.image = IMAGE(image[i]);
            [button addSubview:imageView];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, button.frame.size.width, 20)];
            label.text = titleArray[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHexString:@"0x606060"];
            label.font = [UIFont systemFontOfSize:14];
            [button addSubview:label];
        }
        
    }
    
    return self;
}

- (void)btnClick:(UIButton *)button {
    
    _refreshUI(button.tag);
    
}


@end
