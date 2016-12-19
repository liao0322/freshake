//
//  CountdownButton.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownButton : UIButton

// 倒计时文本
@property (nonatomic, copy) NSString *countdownTtitle;
// 字体大小     默认60
@property (nonatomic, assign) CGFloat fontSize;
// 倒计时时间    默认60
@property (nonatomic, assign) NSInteger time;
// 开始背景颜色   默认白色
@property (nonatomic, strong) UIColor *startBgColor;
// 结束背景颜色   默认白色
@property (nonatomic, strong) UIColor *endBgColor;
// 文字颜色      默认黑色
@property (nonatomic, strong) UIColor *countdownTextColor;
// 倒计时Label
@property (nonatomic, strong) UILabel *countdownLabel;

// 开始计时
- (void)startTiming;

@end
