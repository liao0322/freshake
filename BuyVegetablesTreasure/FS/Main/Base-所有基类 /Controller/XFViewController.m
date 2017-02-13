//
//  XFViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFViewController.h"

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self initialize];
    [self setupViews];
    [self setupNavigationBar];
    [self addSubviews];
    [self registerViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Custom

- (void)requestData {}
- (void)initialize {}
- (void)setupViews {}
- (void)setupNavigationBar {}
- (void)addSubviews {}
- (void)registerViews {}


@end
