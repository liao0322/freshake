//
//  FSGroupBuyHelperViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/28.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSGroupBuyHelperViewController.h"

@interface FSGroupBuyHelperViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FSGroupBuyHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拼团玩法";
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 2650.0f / (1080.0f / SCREEN_WIDTH));
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.scrollView.width;
    self.imageView.height = 2650.0f / (1080.0f / SCREEN_WIDTH);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
