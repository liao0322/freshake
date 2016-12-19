//
//  UserInfoView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "UserInfoView.h"

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSexButton];
    }
    
    return self;
}

- (void)initSexButton{
    
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 75, 20)];
    sex.font     = [UIFont systemFontOfSize:15];
    sex.text     = @"性别";
    sex.textAlignment = NSTextAlignmentRight;
    [self addSubview:sex];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self addSubview:line];
    
    UIButton *sexManButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sex.frame) + 25,
                                                               14, 60, 22)];
    [self addSubview:sexManButton];
    
    UIButton *sexGirlButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sexManButton.frame) + 20,
                                                                        14, 60, 22)];
    [self addSubview:sexGirlButton];
    
    NSArray *arr = @[@"先生",@"女士"];
    
    for (int i = 0; i < arr.count; i ++) {
        
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 40, 20)];
        sexLabel.font     = [UIFont systemFontOfSize:13];
        sexLabel.text     = arr[i];
        
        if ([arr[i] isEqualToString:@"先生"]) {

            _manButton          = [UIButton buttonWithType:UIButtonTypeCustom];
            _manButton.frame    = CGRectMake(0, 0, 16, 22);
            _manButton.selected = YES;
            
            [_manButton setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
            [_manButton setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
            [_manButton addTarget:self
                           action:@selector(man)
                 forControlEvents:UIControlEventTouchUpInside];
            
            [sexManButton addSubview:_manButton];
            [sexManButton addSubview:sexLabel];
        }
        else{
            
            _girlButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _girlButton.frame = CGRectMake(0, 0, 16, 22);
            
            [_girlButton setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
            [_girlButton setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
            [_girlButton addTarget:self
                           action:@selector(girl)
                 forControlEvents:UIControlEventTouchUpInside];
            
            [sexGirlButton addSubview:_girlButton];
            [sexGirlButton addSubview:sexLabel];
        }
    }
    
    [sexManButton addTarget:self
                   action:@selector(man)
         forControlEvents:UIControlEventTouchUpInside];
    
    [sexGirlButton addTarget:self
                    action:@selector(girl)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)man {
    
    _manButton.selected  = YES;
    _girlButton.selected = NO;
}

- (void)girl {
    
    _manButton.selected  = NO;
    _girlButton.selected = YES;
}

@end
