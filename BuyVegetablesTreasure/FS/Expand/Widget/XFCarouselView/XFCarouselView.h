//
//  XFCarouselView.h
//  BuyVegetablesTreasure
//
//  轮播图控件
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFCarouselView;

@protocol XFCarouselViewDelegate <NSObject>

@optional
- (void)carouselView:(XFCarouselView *)carouselView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XFCarouselView : UIView

@property (nonatomic) NSMutableArray *imageUrlArray;

@property (weak, nonatomic) id<XFCarouselViewDelegate> delegate;

@end
