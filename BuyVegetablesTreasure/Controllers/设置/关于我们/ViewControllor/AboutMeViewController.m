//
//  AboutMeViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutView.h"

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self initAboutView];
}

- (void)setNav {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"关于我们"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

- (void)initAboutView {
    
    AboutView *aboutView = [[AboutView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:aboutView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
