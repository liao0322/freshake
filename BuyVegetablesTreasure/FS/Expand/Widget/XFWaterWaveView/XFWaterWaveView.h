//
//  XFWaterWaveView.h
//  ttttt
//
//  Created by DamonLiao on 2017/1/6.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFWaterWaveView : UIView

- (void)startWaveToPercent:(CGFloat)percent;

- (void)setGrowthSpeed:(CGFloat)growthSpeed;    // 设置上升速度

- (void)dismissWithCompletion:(void (^)())completion;

+ (void)showLoading;
+ (void)dismissLoading;

+ (void)dismissWithCompletion:(void (^)())completion;

@end
