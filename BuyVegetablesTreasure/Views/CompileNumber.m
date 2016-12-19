//
//  CompileNumber.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "CompileNumber.h"

@implementation CompileNumber

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCompileNumber];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self){
        
        [self initCompileNumber];
    }
    
    return self;
}

- (void)initCompileNumber{
    
    int width = ScreenWidth / 3;
    
    // 减
    UIButton *reduceGoodsQuantityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceGoodsQuantityBtn.frame = CGRectMake(0, 0, 30, 30);
    [reduceGoodsQuantityBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [reduceGoodsQuantityBtn addTarget:self action:@selector(reduceGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reduceGoodsQuantityBtn];
    
    // 加
    UIButton *addGoodsQuantityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addGoodsQuantityBtn.frame = CGRectMake(width / 3 * 2, 0, 30, 30);
    [addGoodsQuantityBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [addGoodsQuantityBtn addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addGoodsQuantityBtn];
    
    // 数量
    _goodsSumLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 3, 0, 30, 30)];
    _goodsSumLabel.font = [UIFont systemFontOfSize:12];
    _goodsSumLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_goodsSumLabel];
}

- (void)reduceGoods{
    
    NSLog(@"%@",_goodsSumLabel.text);
    
    if ([_goodsSumLabel.text intValue] > 0) {
        
        if ([_goodsSumLabel.text intValue] - 1 == 0) {
            
            _isDel = YES;
            _num = -1;
            [self goodsNumberWithisAdd:NO];
        }
        else {
            
            _isDel = NO;
            _num = -1;
            [self goodsNumberWithisAdd:NO];
        }
    }
}

- (void)addGoods{
    
    if ([_goodsSumLabel.text intValue] < 99) {
        
        _isDel = NO;
        _num = 1;
        [self goodsNumberWithisAdd:YES];
    }
}

- (void)goodsNumberWithisAdd:(BOOL)isAdd
{
    BOOL isStork = NO;
    
    if ([_goodsSumLabel.text integerValue] >= _stork) {
        
        _goodsSumLabel.text = [NSString stringWithFormat:@"%zd",_stork];
        
        isStork = YES;
    }
    
    _goodsNumberBlock([NSString stringWithFormat:@"%zd",[_goodsSumLabel.text integerValue] + _num],isStork,_isDel,isAdd);
}

@end
