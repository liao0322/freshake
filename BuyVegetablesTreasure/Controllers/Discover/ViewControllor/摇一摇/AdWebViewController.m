//
//  AdWebViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "AdWebViewController.h"
#import "MyCouponsViewController.h"

@interface AdWebViewController ()

@end

@implementation AdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:_name];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49 * _isCoupon)];
    webView.backgroundColor = [UIColor redColor];
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [webView loadRequest:request];
    
    [self initBottomBtn];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBottomBtn {
    
    if (_isCoupon) {
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bottomBtn.frame = CGRectMake(0, SCREEN_HEIGHT- 64 - 49, SCREEN_WIDTH, 49);
        _bottomBtn.backgroundColor = Color;
        [_bottomBtn setTitle:@"查看我的优惠券" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomBtn];
    }
}

#pragma mark 进入我的优惠券
-(void)btnClick {
    [self.navigationController pushViewController:[MyCouponsViewController new] animated:YES];
}

@end
