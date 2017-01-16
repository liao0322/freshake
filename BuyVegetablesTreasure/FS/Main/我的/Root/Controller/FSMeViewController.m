//
//  FSMeViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/13.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMeViewController.h"
#import "FSMeHeadView.h"
#import "FSMeCenterView.h"
#import "FSMeBottomView.h"
#import "FSMoreViewController.h"
#import "FSMeModel.h"
#import "MyOrderModel.h"
#import "FSNumView.h"
#import "FSLoginViewController.h"
#import "FSMyCouponsViewController.h"
#import "FSNavigationController.h"
#import "FSMyCollectViewController.h"
#import "MySiteViewController.h"
#import "MyOrderViewController.h"
#import "MyGroupViewController.h"
#import "MyCollectViewController.h"
#import "MoreViewController.h"
#import "PersonalDataViewController.h"
#import "PointRecordViewController.h"
#import "AmountViewController.h"

@interface FSMeViewController ()<FSMeHeadViewDelegate, FSMeBottomViewDelegate, UIScrollViewDelegate,FSMeCenterViewDelegate>

@property (nonatomic, copy) FSMeHeadView *headView;

@property (nonatomic, copy) FSMeCenterView *centerView;

@property (nonatomic, copy) FSMeBottomView *bottomView;

@property (nonatomic, copy) NSString *uidString;

@property (nonatomic, copy) NSString *pointString;

@property (nonatomic, copy) NSString *moneyString;

@property (nonatomic, copy) NSMutableArray *dataSourse;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *orderCountArray;


@end

@implementation FSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self createUI];
    [_headView setUserData];
    _orderCountArray = [NSMutableArray array];
    _dataSourse = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        
        [self requestPoint];
        [self getCount];

    }
    else {
        [self getCount];

        [_dataSourse removeAllObjects];
    }
    [_headView setUserData];
    // 导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    // 黑线消失的办法
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)setNavi {
    
    self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"FS设置") WithTarget:self action:@selector(goSetting)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}



- (void)createUI {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT == 568 ? 667 : SCREEN_HEIGHT)];
    if (SCREEN_HEIGHT == 480) {
        scrollView.contentSize = CGSizeMake(0, scrollView.frame.size.height + 50);
    } else if (SCREEN_HEIGHT == 568) {
        scrollView.contentSize = CGSizeMake(0, scrollView.frame.size.height - 80);
    }
    scrollView.showsVerticalScrollIndicator = NO;
    if (SCREEN_HEIGHT <= 568) {
        scrollView.alwaysBounceVertical = YES;
        scrollView.scrollEnabled = YES;
    } else {
        scrollView.alwaysBounceVertical = NO;
        scrollView.scrollEnabled = NO;
    }
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    _bgScrollView = scrollView;
    
    _headView = [[FSMeHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_WIDTH == 320 ? 183.5 : 215)];
    _headView.delegate = self;
    [_bgScrollView addSubview:_headView];
    
    WS(weakSelf);
    _headView.numView.btnBlock = ^(NSInteger tag) {
        if (tag == 50) {
            PointRecordViewController *pointVC = [[PointRecordViewController alloc] init];
            pointVC.point = weakSelf.pointString;
            [weakSelf.navigationController pushViewController:pointVC animated:YES];
        }
        else if (tag == 51) {
            [weakSelf pushViewControllerWithVC:[AmountViewController new]];
        }else {
            [weakSelf pushViewControllerWithVC:[FSMyCouponsViewController new]];
        }
    };
    
    _centerView = [[FSMeCenterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame) + 10, SCREEN_WIDTH, 115)];
    _centerView.delegate = self;
    [_bgScrollView addSubview:_centerView];
    
    
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSMeBottomView class]) owner:self options:nil] lastObject];
    _bottomView.delegate = self;
//    _bottomView = [[FSMeBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerView.frame) + 10, SCREEN_WIDTH, 200)];
    [_bgScrollView addSubview:_bottomView];
}



- (void)viewDidLayoutSubviews {
    _bottomView.frame = CGRectMake(0, SCREEN_WIDTH == 320 ? 318.5 : 350, SCREEN_WIDTH, 200);

}

#pragma mark - 前往登录
- (void)fsHeadView:(FSMeHeadView *)fsHeadView loginButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"登录");
    
    FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
    
    FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navController animated:YES completion:nil];
    
    //[self pushViewControllerWithVC:[FSLoginViewController new]];
}

#pragma mark - 前往个人信息
- (void)fsHeadView:(FSMeHeadView *)fsHeadView myMessageButtonClick:(UIButton *)sender {
    
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        [self pushViewControllerWithVC:[PersonalDataViewController new]];

    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }

}

#pragma mark 前往我的订单
- (void)fsCenterView:(FSMeCenterView *)fsCenterView allOrderButtonClick:(UIButton *)sender {
    
    NSLog(@"%@", [sender currentTitle]);
    

    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
        myOrderVC.Index = self.centerView.btnIndex;
        NSLog(@"^^^^^^^^^^^&&&&&%ld", myOrderVC.Index);

        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myOrderVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
//        [self pushViewControllerWithVC:[MyOrderViewController new]];
    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
}


#pragma mark 前往我的拼团
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView myPTButtonClick:(UIButton *)sender {
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        [self pushViewControllerWithVC:[MyGroupViewController new]];
    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }

}

#pragma mark 前往我的优惠券
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView couponsButtonClick:(UIButton *)sender {
    
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        [self pushViewControllerWithVC:[FSMyCouponsViewController new]];
    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark 前往我的收藏
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView collecButtonClick:(UIButton *)sender {
    
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        
        [self pushViewControllerWithVC:[MyCollectViewController new]];
        
    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }

}

#pragma mark 前往地址管理
- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView addressButtonClick:(UIButton *)sender {
    
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if (![Tools isBlankString:_uidString]) {
        
        [self pushViewControllerWithVC:[MySiteViewController new]];

    }
    else {
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navController animated:YES completion:nil];
    }

}

#pragma mark 前往设置界面
- (void)goSetting {
    [self pushViewControllerWithVC:[MoreViewController new]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 跳转到下个页面
- (void)pushViewControllerWithVC:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 订单状态总条数
- (void)getCount {
    
    [_orderCountArray removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:GetOrderSum,_uidString];
    NSLog(@"获取角标数量 = %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         MyOrderModel *model = [[MyOrderModel alloc] init];
         [model setDic:data];
         [_orderCountArray addObject:model];
         
         [_centerView setLabelCountWithModel:_orderCountArray[0]];
         
     } failure:nil];
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
             
             FSMeModel *model = [[FSMeModel alloc]init];
             model.point = [NSString stringWithFormat:@"%@",data[@"point"]];
             model.tickNum = [NSString stringWithFormat:@"%@",data[@"TickNum"]];
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
             
             if (_dataSourse.count > 0) {
                 [_headView setpointCountWithModel:_dataSourse[0]];
             }

         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

@end
