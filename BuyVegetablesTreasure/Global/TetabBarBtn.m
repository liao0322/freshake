//
//  TetabBarBtn.m
//  PocketKitchen
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import "TetabBarBtn.h"
@implementation TetabBarBtn

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
               selectedImage:(UIImage *)selectedImage
             unselectedImage:(UIImage *)unselectedImage
{
    if (self = [super initWithFrame:frame])
    {
        // icon图片
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, 40)];
        _iconImageView.image = unselectedImage;
        _iconImageView.contentMode = UIViewContentModeTop;
        [self addSubview:_iconImageView];
        
        CGFloat labelHeight = 21;
        _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 49 - labelHeight, _iconImageView.bounds.size.width, labelHeight)];
        _titlelabel.text = title;
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.textColor = [UIColor grayColor];
        _titlelabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titlelabel];
        
        _selectedImg = selectedImage;
        _unselectedImg = unselectedImage;
        
        self.selected = NO;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if (_selected != selected)
    {
        _selected = selected;
        
        if (selected)
        {
            _iconImageView.image = _selectedImg;
            _titlelabel.textColor = Color;
        }
        else
        {
            _iconImageView.image = _unselectedImg;
            _titlelabel.textColor = [UIColor grayColor];
        }
    }
}









@end
