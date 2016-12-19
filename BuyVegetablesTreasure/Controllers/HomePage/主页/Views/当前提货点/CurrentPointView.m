//
//  CurrentPointView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/18.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CurrentPointView.h"

#define FrameWidth self.frame.size.width

@interface CurrentPointView ()

@property (nonatomic, copy) UILabel *nameLabel;
@property (nonatomic, copy) UIImageView *addressIconImageView;
@property (nonatomic, copy) UIImageView *openAddressImageView;

@end

@implementation CurrentPointView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _addressIconImageView = [[UIImageView alloc] initWithImage:IMAGE(@"地址")];
    _addressIconImageView.frame = CGRectMake(ScreenWidth / 2 - 10, 13, 13, 18);
    [self addSubview:_addressIconImageView];
    
    _openAddressImageView = [[UIImageView alloc] initWithImage:IMAGE(@"地址展开")];
    _openAddressImageView.frame = CGRectMake(ScreenWidth / 2 + 10, 18.5, 13, 7);
    [self addSubview:_openAddressImageView];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = Color;
    [self addSubview:_nameLabel];
}

- (void)setText:(NSString *)textString {
    
    float width = [Utillity getTextWidthWithText:textString height:20 font:[UIFont systemFontOfSize:17]];
    _nameLabel.frame = CGRectMake(ScreenWidth / 2 - width / 2, 0, width, 44);
    _nameLabel.text = textString;
    
    CGRect frame = _addressIconImageView.frame;
    frame.origin.x = _nameLabel.frame.origin.x - 23;
    _addressIconImageView.frame = frame;
    
    CGRect frame1 = _openAddressImageView.frame;
    frame1.origin.x = CGRectGetMaxX(_nameLabel.frame) + 10;
    _openAddressImageView.frame = frame1;
}

@end
