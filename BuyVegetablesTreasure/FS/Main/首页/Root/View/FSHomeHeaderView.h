//
//  FSHomeHeaderView.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeFourButtonView.h"

@class XFCarouselView;


@interface FSHomeHeaderView : UICollectionReusableView

/// 轮播图
@property (nonatomic) XFCarouselView *carouselView;

/// 四个按钮
@property (nonatomic) FSHomeFourButtonView *fourButtonView;

+ (CGFloat)height;


@end
