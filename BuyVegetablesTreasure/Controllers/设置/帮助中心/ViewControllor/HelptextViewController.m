//
//  HelptextViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 15/12/19.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "HelptextViewController.h"

@interface HelptextViewController ()

@end

@implementation HelptextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Tools isBlankString:_titleText])
    {
        _titleText = @"帮  助";
    }
    self.navigationItem.titleView = [Utillity customNavToTitle:_titleText];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    //多行输入框
    UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //设置内容
    textField.text = _context;
    //不可编辑
    textField.editable = NO;
    textField.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    textField.dataDetectorTypes = UIDataDetectorTypeAll;
    textField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textField];
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
