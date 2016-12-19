//
//  PointRecordViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "PointRecordViewController.h"
#import "RechargeView.h"
#import "RecordTableViewCell.h"
#import "RechardModel.h"

@interface PointRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    RechargeView *_rechargeView;
    UITableView *_tableview;
    NSMutableArray *_dataSourse;
    
}
@end

@implementation PointRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourse = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"积分记录"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    [self initView];
    [self initUITableView];
    
    [self requestDatafromNet];

}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 初始化tableView
-(void)initUITableView
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableview.backgroundColor = [UIColor clearColor];
    
    _tableview.tableHeaderView = _rechargeView;
    
    //去除多余的分割线
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableview setTableFooterView:view];
    
    [_tableview registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableview];
    
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_dataSourse.count > 0)
        {
            [_dataSourse removeAllObjects];
        }
        
        [self requestDatafromNet];
        
    }];
    
}
#pragma mark 初始化上、下View
-(void)initView
{
    _rechargeView = [[RechargeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    _rechargeView.isBottomView = @"0";
    [_rechargeView SetUI:[NSString stringWithFormat:@"%@分",_point] WithTitle:@"当前积分:" AndColor:@"0xff6600"];
}
#pragma mark 设置行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark 设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSourse.count > 0)
    {
        return _dataSourse.count;
    }else
        return 1;
}
#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *cell   = [_tableview dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataSourse.count > 0)
    {
        RechardModel *model = _dataSourse[indexPath.section];
        [cell setData:model];
    }
    
    return cell;
}
#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourse.count > 0)
    {
        RechardModel *model = _dataSourse[indexPath.section];
        return 40 + model.contHeight +25;
    }
    return 0;
}
#pragma mark 设置段头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 设置断尾
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark 数据请求
-(void)requestDatafromNet {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:GETPOINTRECATD,uid];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         
         if ([data[@"issuccess"] boolValue]) {
             
             for (NSDictionary *dic in data[@"List"]) {
                 
                 RechardModel *model = [[RechardModel alloc]init];
                 [model setValuesForKeysWithDictionary:dic];
                 model.isPoint = YES;
                 model.contHeight = [Utillity getTextHeightWithText:dic[@"remark"] width:SCREEN_WIDTH - 30 font:[UIFont systemFontOfSize:13]];
                 [_dataSourse addObject:model];
             }
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
         [_tableview reloadData];
         [_tableview.mj_header endRefreshing];
         
     } failure:^(NSError *error) {
         
         [_tableview.mj_header endRefreshing];

     }];
}


@end
