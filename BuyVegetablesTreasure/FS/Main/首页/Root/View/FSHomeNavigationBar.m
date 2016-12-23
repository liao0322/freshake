//
//  FSHomeNavigationBar.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHomeNavigationBar.h"
#import "UIColor+Extension.h"
#import "XFMacroSize.h"
#import "UIImage+Create.h"

@interface FSHomeNavigationBar ()


@end


@implementation FSHomeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.shadowView];
        [self addSubview:self.leftButton];
        [self addSubview:self.titleButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shadowView.frame = self.bounds;
    
    // 左边button frame
    [self.leftButton sizeToFit];
    self.leftButton.left = 15;
    self.leftButton.centerY = ((self.height - STATUS_BAR_HEIGHT) * 0.5) + STATUS_BAR_HEIGHT;
    self.leftButton.width = 48;
    
    self.titleButton.centerY = self.leftButton.centerY;
    self.titleButton.x = self.leftButton.right + 8;
    self.titleButton.width = self.width - (self.leftButton.width + 30 + 8);
    self.titleButton.height = 28;
    //self.titleButton.centerX = self.centerX;
    

}

#pragma mark - LazyLoad

- (XFNoHighlightButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [XFNoHighlightButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"上海" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setImage:[[UIImage imageNamed:@"locate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _leftButton.tintColor = [UIColor whiteColor];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        
    }
    return _leftButton;
}

- (XFNoHighlightButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [XFNoHighlightButton buttonWithType:UIButtonTypeCustom];
        
        [_titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:40 alpha:0.5f]] forState:UIControlStateNormal];
        
        [_titleButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _titleButton.layer.cornerRadius = 5.0f;
        _titleButton.layer.masksToBounds = YES;
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleButton setImage:[[UIImage imageNamed:@"home_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _titleButton.tintColor = [UIColor whiteColor];
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _titleButton;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.hidden = YES;
        
        // 设置阴影
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOpacity = .5f;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowRadius = 1;
        _shadowView.layer.shouldGroupAccessibilityChildren = NO;
    }
    return _shadowView;
}

@end
