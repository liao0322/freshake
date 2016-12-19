//
//  SelectSexView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectSexView.h"

@implementation SelectSexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sex = YES;
        [self initSelectSexView];
    }
    return self;
}

- (void)initSelectSexView {
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.tag = i + 10;
        bgButton.frame = CGRectMake(((ScreenWidth - 110) / 2 + 10) * i, 0, (ScreenWidth - 110) / 2, 50);
        [bgButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        UIButton *sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sexBtn.selected = i == 0 ? YES : NO;
        sexBtn.tag = i + 20;
        sexBtn.frame = CGRectMake(10, 17.5, 15, 15);
        sexBtn.layer.cornerRadius = 7.5;
        sexBtn.layer.borderWidth = 0.5;
        sexBtn.layer.borderColor = [UIColor colorWithHexString:@"0xDBDEDD"].CGColor;
        [sexBtn setImage:[UIImage imageNamed:@"勾图标"] forState:UIControlStateSelected];
        [bgButton addSubview:sexBtn];
        
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sexBtn.frame) + 10, 0, 100, CGRectGetHeight(bgButton.frame))];
        sexLabel.text = i == 0 ? @"先生" : @"女士";
        sexLabel.font = [UIFont systemFontOfSize:14];
        [bgButton addSubview:sexLabel];
    }
}

- (void)buttonClick:(UIButton *)btn {
    
    UIButton *button = (UIButton *)[self viewWithTag:btn.tag - 10 + 20];
    button.selected = !button.selected;
    
    UIButton *button_1 = (UIButton *)[self viewWithTag:(!(btn.tag - 10)) + 20];
    button_1.selected = !button.selected;
    
    if (btn.tag == 10) {
        _sex = YES;
    }
    else {
        _sex = NO;
    }

    NSLog(@"%zd",_sex);
}

- (void)setSexBtn:(BOOL)sex {
    
    UIButton *button = (UIButton *)[self viewWithTag:20 + !sex];
    button.selected = YES;
    
    UIButton *button_1 = (UIButton *)[self viewWithTag:20 + sex];
    button_1.selected = NO;
}

@end
