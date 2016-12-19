//
//  DiscoverViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/22.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "DiscoverViewController.h"
#import "RockViewController.h"
#import "ScanViewController.h"
#import "ShopLoginViewController.h"
#import "MainView.h"

@interface DiscoverViewController ()
{
    MainView *_mainView;
}

@end

@implementation DiscoverViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"发现"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
-(void)initView
{
    _mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_mainView];
    
    WS(weakSelf);
    _mainView.BtnClick = ^(NSInteger index){
        
        if (index == 11) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:[RockViewController new] animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }else{
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:[ScanViewController new] animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }
        
        
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
