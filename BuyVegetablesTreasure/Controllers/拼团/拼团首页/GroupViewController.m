//
//  GroupViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/25.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupDetailsViewController.h"
#import "GroupTableView.h"
#import "GroupModel.h"

#define MIDNameHeight 50

@interface GroupViewController ()

@property (nonatomic, copy) NSMutableArray *dataArray;
@property (nonatomic, copy) GroupTableView *groupTableView;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    
    _dataArray = [NSMutableArray array];

    [self setNav];
    [self initGroupTableView];
//    [self initMidNameView];
    [self requestDataFromNet];
}

#pragma mark - 初始化
- (void)initGroupTableView {

    _groupTableView = [[GroupTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:_groupTableView];
    
    WS(weakSelf);
    _groupTableView.goDetails = ^(GroupModel *model) {
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        
        GroupDetailsViewController *groupDateilVC = [[GroupDetailsViewController alloc] init];
        groupDateilVC.model = model;
        [weakSelf.navigationController pushViewController:groupDateilVC animated:YES];
    };
    
    _groupTableView.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.dataArray removeAllObjects];
        [self requestDataFromNet];
    }];
}

#pragma mark 提货点名字
- (void)initMidNameView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(bgView.frame))];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:nameLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame) - 1, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
    [bgView addSubview:line];
}

#pragma mark 设置导航条
- (void)setNav {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"拼团"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}
#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 数据请求
#pragma mark 获取数据
- (void)requestDataFromNet {
    
    NSString *midSitnrg = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GetProduct_ActivityList, midSitnrg];
    NSLog(@"%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            NSArray *arr = data[@"List"];
            
            for (NSDictionary *dict in arr) {
                
                GroupModel *groupModel = [[GroupModel alloc] init];
                [groupModel setValuesForKeysWithDictionary:dict];
                groupModel.titleHight = [Utillity getTextHeightWithText:groupModel.Remark width:ScreenWidth - 40 font:[UIFont systemFontOfSize:15]];
                [_dataArray addObject:groupModel];
            }
            
            _groupTableView.dataArray = _dataArray;
            [_groupTableView refreshGoods];
         }
        
        [_groupTableView.groupTableView.mj_header endRefreshing];
        
    } failure:nil];
}

@end
