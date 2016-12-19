//
//  CouponsDetailViewController.m
//  VegetablesApp
//
//  Created by M on 16/6/1.
//  Copyright © 2016年 M. All rights reserved.
//

#import "CouponsDetailViewController.h"
#import "CouponsDetailView.h"

@interface CouponsDetailViewController ()

@end

@implementation CouponsDetailViewController

- (void)viewDidLoad {

    self.view.backgroundColor = [UIColor colorWithHexString:@"0xfcce30"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"优惠券详情"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];

    [self initCouponsDetailView];
}

- (void)initCouponsDetailView {
    
    CouponsDetailView *couponsDetailView = [[CouponsDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    couponsDetailView.couponsModel = _couponsModel;
    [self.view addSubview:couponsDetailView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
