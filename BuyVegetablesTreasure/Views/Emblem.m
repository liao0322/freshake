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
        _backImage.image = IMAGE(@"detail-椭圆");
        
        [self addSubview:_backImage];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        
        _numLabel.font = [UIFont systemFontOfSize:8];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor whiteColor];
        [_backImage addSubview:_numLabel];
        
    }
    return self;
}

@end
