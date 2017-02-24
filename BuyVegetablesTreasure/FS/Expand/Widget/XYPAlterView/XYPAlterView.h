//
//  XYPAlterView.h
//  XYPTestAlertView
//
//  Created by 江玉元 on 2017/2/23.
//  Copyright © 2017年 Jiang YY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYPAlterView;

#define XYPAlterWidth  SCREEN_WIDTH - 30

@protocol XYPAlterViewDelegate <NSObject>

- (void)xypAlterView:(XYPAlterView *)xypAlterView closeButtonTouchUpInside:(UIButton *)sender;

@end

@interface XYPAlterView : UIView

@property (nonatomic, weak) id<XYPAlterViewDelegate>delegate;

// 领用礼品券
- (void)alertForGetGiftCardWithMessage:(NSString *)message Money:(NSString *)money Success:(BOOL)success;


@end
