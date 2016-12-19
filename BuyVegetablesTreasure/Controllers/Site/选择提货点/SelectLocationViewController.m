//
//  SelectLocationViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectLocationViewController.h"
#import "MapView.h"

@interface SelectLocationViewController ()

@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initMapView];
    [self setNav];
}

#pragma mark - 初始化
#pragma mark 地图View
- (void)initMapView {
    
    MapView *mapView = [[MapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:mapView];
}

#pragma mark 设置导航条
- (void)setNav {
    self.navigationItem.titleView = [Utillity customNavToTitle:@"提货点"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
