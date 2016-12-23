//
//  FSHelpViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHelpViewController.h"
#import "FSHelpView.h"
#import "FSHelpModel.h"

@interface FSHelpViewController ()

@property (nonatomic, strong) FSHelpView *helpView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSHelpViewController

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"帮助"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];

}

#pragma mark 初始化帮助界面
- (void)initHelpView {
    
    _helpView = [[FSHelpView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_helpView];
    
    WS(weakSelf);
    _helpView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];

    };
}

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
                 
                 FSHelpModel *model = [[FSHelpModel alloc] init];
                 
                 [model setValuesForKeysWithDictionary:dic];
                 
                 [_dataSource addObject:model];
             }
             
             _helpView.dataSource = _dataSource;
             [_helpView refreshTableView];
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];

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
