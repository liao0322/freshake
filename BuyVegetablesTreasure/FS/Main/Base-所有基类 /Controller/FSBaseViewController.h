//
//  FSBaseViewController.h
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSNoDataView.h"
#import "FSNetErrorView.h"

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

- (void)requestData;
- (void)initialize;
- (void)setupViews;
- (void)registerViews;


/// 解析二进制数据，返回一个字典
- (NSDictionary *)dictWithData:(NSData *)data;

- (void)showInfoWidthError:(NSError *)error;

@property (nonatomic) FSNoDataView *noDataView;
@property (nonatomic) FSNetErrorView *netErrorView;
@property (nonatomic) XFWaterWaveView *loadingView;

- (void)showLoading;
- (void)dismissLoading;

@end
