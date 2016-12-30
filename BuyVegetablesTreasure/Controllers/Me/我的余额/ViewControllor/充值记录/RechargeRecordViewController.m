//
//  RechargeRecordViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeView.h"
#import "RecordTableViewCell.h"
#import "RechardModel.h"
@interface RechargeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    RechargeView *_rechargeView;
    UITableView *_tableview;
    NSMutableArray *_dataSourse;
}

@end

@implementation RechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourse = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.title = @"充值记录";

    [self initView];
    [self initUITableView];
    
    [self requestDatafromNet];

}

#pragma mark 初始化tableView
-(void)initUITableView {
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
-(void)initView {
    
    
    _rechargeView = [[RechargeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    _rechargeView.isBottomView = @"0";
    
    NSString *money = [[NSUserDefaults standardUserDefaults] objectForKey:@"amount"];
    [_rechargeView SetUI:[NSString stringWithFormat:@"￥ %.2f",[money floatValue]] WithTitle:@"当前余额:" AndColor:@"0xfd7f09"];
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
    NSString *userIdString = [userDefaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetRechargeLog,userIdString];
    NSLog(@"==充值记录==%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ( [[NSString stringWithFormat:@"%@",[data objectForKey:@"issuccess"]] isEqualToString:@"1"])
        {
            for (NSDictionary *dic in data[@"List"]) {
                
                RechardModel *model = [[RechardModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.contHeight = [Utillity getTextHeightWithText:dic[@"remark"]
                                                             width:SCREEN_WIDTH - 30
                                                              font:[UIFont systemFontOfSize:15]];
                [_dataSourse addObject:model];
            }
            
            [_tableview reloadData];
            [_tableview.mj_header endRefreshing];
            
        }else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];

}




@end
