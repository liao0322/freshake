//
//  UserAgreementViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/8/17.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "UserAgreementViewController.h"

@implementation UserAgreementViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"用户协议"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    // 路径
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"用户协议" ofType:@"txt"];
    NSString *txtString = [NSString stringWithContentsOfFile:txtPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];

    UITextView *textView = [UITextView new];
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.text = txtString;
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [self.view addSubview:textView];
    
    textView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
