//
//  FSTabBarController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSTabBarController.h"
#import "FSNavigationController.h"
// #import "HomePageViewController.h"
#import "FSHomeViewController.h"
//#import "MeViewController.h"
// #import "GoodsCartViewController.h"
#import "FSShoppingCartViewController.h"
//#import "ClassificationViewController.h"
#import "FSClassificationViewController.h"

#import "FSMeViewController.h"
#import "XFMeViewController.h"

@interface FSTabBarController ()

@end

@implementation FSTabBarController

+ (void)initialize {
    UITabBar *tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [tabBar setTintColor:[UIColor colorDomina]];
    
    // tabBar.translucent = NO; // 取消tab bar透明
    
    // 去除tab bar顶部的边框
    // tabBar.backgroundImage = [[UIImage alloc] init];
    // tabBar.shadowImage = [[UIImage alloc] init];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self addChildViewControllers];
    
    [self setupChildViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom

/// 添加所有的子控制器
- (void)addChildViewControllers {
    
    // 首页
    FSHomeViewController *homeVC = [[FSHomeViewController alloc] init];
    [self p_addChildViewController:homeVC];
    
    // 分类
    FSClassificationViewController *classificationVC = [[FSClassificationViewController alloc] init];
    [self p_addChildViewController:classificationVC];
    
    // 购物车
    FSShoppingCartViewController *goodsCartVC = [[FSShoppingCartViewController alloc] init];
    [self p_addChildViewController:goodsCartVC];
    
    // 我

//    FSMeViewController *meVC = [[FSMeViewController alloc] init];
    
    XFMeViewController *meVC = [[XFMeViewController alloc] init];
    [self p_addChildViewController:meVC];
    
}

- (void)p_addChildViewController:(UIViewController *)viewController {
    
    // 包装一层 navigation 控制器
    FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navController];
    
}

/// 设置所有的子控制器
- (void)setupChildViewControllers {
    // 首页
    UINavigationController *homeNavController = self.childViewControllers[0];
    homeNavController.tabBarItem.title = @"首页";
    homeNavController.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    homeNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_home_selected"];
    
    // 分类
    UINavigationController *messageNavController = self.childViewControllers[1];
    messageNavController.tabBarItem.title = @"分类";
    messageNavController.tabBarItem.image = [UIImage imageNamed:@"tabbar_fenlei"];
    messageNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_fenlei_selected"];
    
    // 购物车
    UINavigationController *discoverNavController = self.childViewControllers[2];
    discoverNavController.tabBarItem.title = @"购物车";
    discoverNavController.tabBarItem.image = [UIImage imageNamed:@"tabbar_cart"];
    discoverNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_cart_selected"];
    
    // 我
    UINavigationController *meNavController = self.childViewControllers[3];
    meNavController.tabBarItem.title = @"我";
    meNavController.tabBarItem.image = [UIImage imageNamed:@"tabbar_me"];
    meNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_me_selected"];
    
}

@end
