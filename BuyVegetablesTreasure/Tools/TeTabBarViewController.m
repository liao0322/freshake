//
//  TeTabBarViewController.m
//  PocketKitchen
//
//  Created by mac on 15-4-28.
//  Copyright (c) 2015年 yuanjinsong. All rights reserved.
//

#import "TeTabBarViewController.h"
#import "TetabBarBtn.h"
#import "TeNavigationViewController.h"
#import "HomePageViewController.h"
#import "MeViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "GoodsCartViewController.h"

#import "ClassificationViewController.h"

@interface TeTabBarViewController ()

@property(nonatomic,copy)UIView *backview;
@property(nonatomic,assign)BOOL notFirstLoad;

@end

@implementation TeTabBarViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    for (UIView *child in self.tabBar.subviews) {
        
        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [child removeFromSuperview];
            
        }
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewController];
    if (!_notFirstLoad)
    {
        _notFirstLoad = YES;
        NSArray *arr = self.tabBar.subviews;
        for (int i=0; i<arr.count; i++)
        {
            if ([arr[i] isKindOfClass:NSClassFromString(@"UITabBarButton")])
            {
                [arr[i] removeFromSuperview];
            }
        }
        //不隐藏
        //        self.tabBar.hidden = YES;
        CGFloat itemWidth = SCREEN_WIDTH / self.viewControllers.count;
        for (int i = 0; i < self.viewControllers.count; i++)
        {
            UIViewController *vc = self.viewControllers[i];
            TetabBarBtn *btn = [[TetabBarBtn alloc]initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 49) title:vc.tabBarItem.title selectedImage:vc.tabBarItem.selectedImage unselectedImage:vc.tabBarItem.image];
            btn.backgroundColor = [UIColor whiteColor];
            [self.tabBar addSubview:btn];
            btn.tag = 100 + i;
            
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [btn addGestureRecognizer:tap];
            
            if (self.selectedIndex == i)
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"change" object:nil];
}

-(void)change:(NSNotification *)objec{
    
    long index = [objec.object integerValue];
    
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        TetabBarBtn *scrbtn = (TetabBarBtn *)[self.tabBar viewWithTag:100 + i];
        scrbtn.selected = NO;
    }
    
    TetabBarBtn *btn=(TetabBarBtn *)[self.tabBar viewWithTag:100 + index];
    btn.selected=YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
// 初始化控制器
- (void)initViewController{
    
    /**
     设置名称
     */
    NSArray *_titles = @[@"首页",@"分类",@"购物车",@"我的"];
    NSArray *imageNmaes = @[@"首页2",
                            @"分类图标2",
                            @"Tabbar购物车灰色",
                            @"我的图标2"];
    NSArray *selectedImageNames = @[@"首页",
                                    @"分类图标",
                                    @"Tabbar购物车橙色",
                                    @"我的图标"];
    //初始化各控制器
    HomePageViewController *_3CMessageController      = [[HomePageViewController alloc]init];
    ClassificationViewController *_resourceListController   = [[ClassificationViewController alloc]init];
    GoodsCartViewController *_Controller   = [[GoodsCartViewController alloc]init];
    _Controller.isHiddenBackBtn = YES;
    MeViewController *_contacterListController  = [[MeViewController alloc]init];
//    MoreViewController *_settingViewController    = [[MoreViewController alloc]init];
    
    NSArray *_tabBars = @[_3CMessageController,_resourceListController,_Controller,_contacterListController];
    
    //设置导航控制器
    NSMutableArray *navs = [NSMutableArray arrayWithCapacity:imageNmaes.count];
    for (int i=0; i<imageNmaes.count; i++)
    {
        
        UIViewController *vc = _tabBars[i];
        
        // 添加NavigationController
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        nav.navigationBar.translucent = NO;
        
        // 设置图片
        nav.tabBarItem.image = [UIImage imageNamed:imageNmaes[i]];
        nav.tabBarItem.selectedImage = [UIImage imageNamed: selectedImageNames[i]];
        nav.tabBarItem.title = _titles[i];
        
        nav.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
        [navs addObject:nav];
    }
    
    self.viewControllers = navs;
}

#pragma mark btnclick
-(void)btnClick:(UITapGestureRecognizer *)tap
{
    TetabBarBtn *btn = (TetabBarBtn *)tap.view;
    TetabBarBtn *scrbtn = (TetabBarBtn *)[self.tabBar viewWithTag:100 + self.selectedIndex];
    // 如果当前点击的按钮不是原本选中的按钮，就进行状态的切换
    if (btn.tag != scrbtn.tag)
    {
        scrbtn.selected = NO;
        btn.selected = YES;
        
        self.selectedIndex = btn.tag - 100;
    }
    
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
