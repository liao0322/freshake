//
//  Emblem.m
//  BaoqianliShop
//
//  Created by ky on 15/10/8.
//  Copyright (c) 2015年 ky. All rights reserved.
//

#import "Emblem.h"

@implementation Emblem


-(instancetype)initWithFrame:(CGRect)frame
{
   self =  [super initWithFrame:frame];
    if (self)
    {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _backImage.image = IMAGE(@"椭圆-1");
        
        [self addSubview:_backImage];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(1.7, 1.8, 11, 11)];
        
        _numLabel.font = [UIFont systemFontOfSize:9];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor redColor];
        [_backImage addSubview:_numLabel];
        
    }
    return self;
}

@end
