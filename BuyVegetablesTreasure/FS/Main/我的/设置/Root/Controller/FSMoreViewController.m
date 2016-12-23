//
//  FSMoreViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMoreViewController.h"
#import "FSSettingView.h"

@interface FSMoreViewController ()

@end

@implementation FSMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initSetView];
}

- (void)setNav {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"设置"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
}

- (void)initSetView {
    
    FSSettingView *setView = [[FSSettingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:setView];
    
    WS(weakSelf);
    setView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    setView.LogOut = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userChangeTuisong" object:nil];
        
        self.tabBarController.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"0"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
