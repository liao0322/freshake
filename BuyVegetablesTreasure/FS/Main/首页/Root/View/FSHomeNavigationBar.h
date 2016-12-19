//
//  FSHomeNavigationBar.h
//  BuyVegetablesTreasure
//
//  自定义的首页导航条
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseView.h"
#import "XFNoHighlightButton.h"



@interface FSHomeNavigationBar : FSBaseView

@property (nonatomic) XFNoHighlightButton *leftButton;
@property (nonatomic) XFNoHighlightButton *titleButton;
@property (nonatomic) UIView *shadowView;

@end
