//
//  FSBaseViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSBaseViewController.h"

@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromRemote];
    [self initialization];
    [self setupNavigationBar];
    [self addSubviews];
    [self registerCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataFromRemote {
    
}

- (void)initialization {

}

- (void)setupNavigationBar {
    
}

- (void)addSubviews {
    
}

- (void)registerCells {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Custom

- (NSDictionary *)dictWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return error ? nil : dict;
}

@end
