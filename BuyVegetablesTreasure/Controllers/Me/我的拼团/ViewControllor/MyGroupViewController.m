//
//  MyGroupViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "MyGroupViewController.h"
#import "MyGroupTableView.h"

@interface MyGroupViewController ()

@property (nonatomic, copy) MyGroupTableView *myGroupTableView;
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"我的拼团"];
    self.title = @"我的拼团";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    [self initMyGroupTableView];
    [self getOrderList];
}

#pragma mark - 初始化
- (void)initMyGroupTableView {
    
    WS(weakSelf);
    if (_myGroupTableView == nil) {
        
        _myGroupTableView = [[MyGroupTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _myGroupTableView.goViewController = ^(UIViewController *viewController) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        };
        [self.view addSubview:_myGroupTableView];
        
        
        _myGroupTableView.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (_dataSource.count > 0)
            {
                [_dataSource removeAllObjects];
            }
            
            [self getOrderList];
            
        }];
        
    }
    else {
        
        _myGroupTableView.dataArray = _dataSource;
        [_myGroupTableView refreshGoods];
    }
    
    
    
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 数据请求
#pragma mark 团购记录列表
- (void)getOrderList {
    
    NSString *urlString = [NSString stringWithFormat:ActivityOrderList,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    NSLog(@"我的团购 == %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            for (NSDictionary *dic in data[@"List"]) {
                
                MyGroupModel *model = [[MyGroupModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
            
            [self initMyGroupTableView];
            if (_dataSource == 0) {
                _myGroupTableView.groupTableView.backgroundView = self.noDataView;
            } else {
                _myGroupTableView.groupTableView.backgroundView = nil;
            }
            
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        [_myGroupTableView.groupTableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [_myGroupTableView.groupTableView.mj_header endRefreshing];
    }];
}

@end
