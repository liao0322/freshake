//
//  FSHelptextViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHelptextViewController.h"

@interface FSHelptextViewController ()

@end

@implementation FSHelptextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([Tools isBlankString:_titleText]) {
        _titleText = @"帮  助";
    }
    self.navigationItem.titleView = [Utillity customNavToTitle:_titleText];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    // 多行输入
    UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    // 设置内容
    textField.text = _context;
    
    // 不可编辑
    textField.editable = NO;
    textField.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    textField.dataDetectorTypes = UIDataDetectorTypeAll;
    textField.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:textField];
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
