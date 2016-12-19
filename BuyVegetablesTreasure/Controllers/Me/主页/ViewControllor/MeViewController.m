//
//  MeViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/14.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "MeViewController.h"
#import "ShopLoginViewController.h"
#import "MoreViewController.h"
#import "MeTableView.h"
#import "MeModel.h"

@interface MeViewController ()

@property (nonatomic, copy) NSString *pointString;
@property (nonatomic, copy) NSString *moneyString;
@property (nonatomic, copy) NSString *uidString;
@property (nonatomic, copy) NSMutableArray *dataSourse;

@property (nonatomic, copy) MeTableView *meTableView;

@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        
        [self requestPoint];
    }
    else {
        
        [_dataSourse removeAllObjects];
        _meTableView.dataScoure = _dataSourse;
        [_meTableView refreshTableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSourse = [NSMutableArray array];

    [self setNav];
    [self initMeTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserChange:) name:@"UserChange" object:nil];
}

#pragma mark - 初始化
- (void)initMeTableView {
    
    if (_meTableView == nil) {
        
        WS(weakSelf);
        _meTableView = [[MeTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _meTableView.goViewController = ^(UIViewController *viewController) {
            [weakSelf pushViewControllerWithVC:viewController];
        };
        [self.view addSubview:_meTableView];
    }
    else {
        _meTableView.dataScoure = _dataSourse;
        _meTableView.pointString = _pointString;
        _meTableView.moneyString = _moneyString;
        [_meTableView refreshTableView];
    }
}

#pragma mark 设置导航条
- (void)setNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"个人中心"];
    self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"设置图标") WithTarget:self action:@selector(goSetting)];
}

#pragma mark 事件处理
#pragma mark 通知
- (void)UserChange:(NSNotification *)objec {
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    [self requestPoint];
}

#pragma mark 前往设置界面
- (void)goSetting {
    [self pushViewControllerWithVC:[MoreViewController new]];
}

#pragma mark 跳转到下个页面
- (void)pushViewControllerWithVC:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 数据请求
#pragma mark 获取积分
- (void)requestPoint {

    NSString *urlString = [NSString stringWithFormat:GetUSERINFO,_uidString];
    NSLog(@"==获取积分、余额、优惠券==%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
    {
        if ([[data objectForKey:@"issuccess"] boolValue]) {
            
            [_dataSourse removeAllObjects];
            
            MeModel *model = [[MeModel alloc]init];
            model.point = [NSString stringWithFormat:@"%@",data[@"point"]];
            model.TickNum = [NSString stringWithFormat:@"%@",data[@"TickNum"]];
            model.amount = [NSString stringWithFormat:@"%@",data[@"amount"]];
            model.group_id = [NSString stringWithFormat:@"%@",data[@"group_id"]];
            [_dataSourse addObject:model];
            
            _pointString = model.point;
            _moneyString = model.amount;
            
            // 积分
            [[NSUserDefaults standardUserDefaults] setObject:data[@"point"] forKey:@"point"];
            // 金额
            [[NSUserDefaults standardUserDefaults] setObject:data[@"amount"] forKey:@"amount"];
            // 优惠券数量
            [[NSUserDefaults standardUserDefaults] setObject:data[@"group_id"] forKey:@"group_id"];
            
            [self initMeTableView];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

@end
