//
//  GroupDetailsImageViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/15.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupDetailsImageViewController.h"

@interface GroupDetailsImageViewController ()

@end

@implementation GroupDetailsImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initImageScrollView];
    [self setNav];
}

- (void)initImageScrollView {

    UIImage *image = [Utillity imageCompressForWidth:IMAGE(@"img_spelling_step.jpg") targetWidth:ScreenWidth];
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageScrollView.contentSize = CGSizeMake(0, image.size.height + 64);
    [self.view addSubview:imageScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, image.size.height);
    imageView.userInteractionEnabled = YES;
    [imageScrollView addSubview:imageView];
}

#pragma mark 设置导航
- (void)setNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"拼团玩法"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark - 事件处理
#pragma makr 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
