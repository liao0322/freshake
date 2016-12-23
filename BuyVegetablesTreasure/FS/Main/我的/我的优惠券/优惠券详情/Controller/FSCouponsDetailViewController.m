//
//  FSCouponsDetailViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSCouponsDetailViewController.h"
#import "FSCouponsDetailView.h"

@interface FSCouponsDetailViewController ()

@end

@implementation FSCouponsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xdf3c5c"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"优惠券详情"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    [self initCouponsDetailView];
}

- (void)initCouponsDetailView {
    
    FSCouponsDetailView *detailView = [[FSCouponsDetailView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    detailView.couponModel = _couponModel;
    [self.view addSubview:detailView];
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
