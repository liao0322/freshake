//
//  FSAboutMeViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSAboutMeViewController.h"
#import "FSAboutView.h"

@interface FSAboutMeViewController ()

@end

@implementation FSAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self initAboutView];
}

- (void)setNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"关于我们"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

- (void)initAboutView {
    FSAboutView *aboutView = [[FSAboutView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:aboutView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
