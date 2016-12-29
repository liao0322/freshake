//
//  HelpViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 15/12/19.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpView.h"
#import "HelpModel.h"

@interface HelpViewController ()

@property (nonatomic, strong) HelpView *helpView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HelpViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataFromNet];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];

    [self setNav];
    [self initHelpView];
    [self requestDataFromNet];
}

#pragma mark - 初始化
#pragma mark 设置导航条
- (void)setNav {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"帮助"];
    self.title = @"帮助";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark 初始化帮助界面
- (void)initHelpView {
    
    _helpView = [[HelpView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_helpView];
    
    WS(weakSelf);
    _helpView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
}

#pragma mark - 事件处理
#pragma mark 返回事件
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 获取数据
- (void)requestDataFromNet {
    
    [HttpRequest sendGetOrPostRequest:GetHelpLeve param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        [_dataSource removeAllObjects];
        
        if ([data[@"issuccess"] boolValue]) {
            
            for (NSDictionary *dic in data[@"List"]) {
                
                HelpModel *model = [[HelpModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataSource addObject:model];
            }
            
            _helpView.dataSource = _dataSource;
            [_helpView refreshTableView];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}


@end
