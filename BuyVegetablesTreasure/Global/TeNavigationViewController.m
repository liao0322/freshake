//
//  TeNavigationViewController.m
//  PocketKitchen
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import "TeNavigationViewController.h"
@interface TeNavigationViewController ()

@end

@implementation TeNavigationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"0x606060"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
