//
//  AdWebViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdWebViewController : UIViewController


@property (nonatomic, copy) NSString *url;      // 保存url
@property (nonatomic, copy) NSString *name;     // 名字
@property (nonatomic, assign) BOOL isCoupon;    // 是否有优惠券

@property (nonatomic, copy) UIButton *bottomBtn;

@end
