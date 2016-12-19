//
//  FirstStarView.h
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/12.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstStarView : UIView<UIScrollViewDelegate>{
    UIScrollView *_firstStartScrollView;
    UIPageControl *_firstStartPageControl;
}
@property (nonatomic, copy) void(^removeFirstViewBlock)();

@end
