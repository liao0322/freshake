//
//  FSHomeHeaderView.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHomeHeaderView.h"
#import "UIColor+Extension.h"
#import "XFCarouselView.h"

@interface FSHomeHeaderView ()

@end

@implementation FSHomeHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorViewBG];
        [self addSubview:self.carouselView];
        [self addSubview:self.fourButtonView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 轮播图的尺寸
    CGFloat ScaleFactor = 375 / 214.0f;
    self.carouselView.frame = CGRectMake(0, 0, self.width, self.width / ScaleFactor);
    
    self.fourButtonView.y = self.carouselView.bottom;
    self.fourButtonView.width = self.width;
    
}


#pragma mark - LazyLoad

- (XFCarouselView *)carouselView {
    if (!_carouselView) {
        _carouselView = [[XFCarouselView alloc] init];
    }
    return _carouselView;
}

- (FSHomeFourButtonView *)fourButtonView {
    if (!_fourButtonView) {
        _fourButtonView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSHomeFourButtonView class]) owner:nil options:nil] lastObject];
    }
    return _fourButtonView;
}


+ (CGFloat)height {
    CGFloat ScaleFactor = 375 / 214.0f;
    return SCREEN_WIDTH / ScaleFactor + 85 + 10;
}

@end
