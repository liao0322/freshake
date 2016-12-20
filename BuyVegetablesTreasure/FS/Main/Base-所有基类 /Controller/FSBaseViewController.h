//
//  FSBaseViewController.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBaseViewController : UIViewController

/// 从远程服务器获取数据
- (void)getDataFromRemote;

/// 创建UI前初始化成员变量数据
- (void)initialization;

/// 配置导航栏
- (void)setupNavigationBar;

/// 添加子控件
- (void)addSubviews;

/// 注册各种cell
- (void)registerCells;


/// 解析二进制数据，返回一个字典
- (NSDictionary *)dictWithData:(NSData *)data;

- (void)showInfoWidthError:(NSError *)error;


@end
