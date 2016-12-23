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
#import "FSLoginViewController.h"
#import "FSMyCouponsViewController.h"
#import "FSNavigationController.h"

@interface FSMeViewController ()<FSMeHeadViewDelegate, FSMeBottomViewDelegate>

@property (nonatomic, copy) FSMeHeadView *headView;

@property (nonatomic, copy) FSMeCenterView *centerView;

@property (nonatomic, copy) FSMeBottomView *bottomView;

@property (nonatomic, copy) NSString *uidString;

@property (nonatomic, copy) NSString *pointString;

@property (nonatomic, copy) NSString *moneyString;

@property (nonatomic, copy) NSMutableArray *dataSourse;
@end

@implementation FSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self createUI];
    [_headView setUserData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    _headView = [[FSMeHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _headView.delegate = self;
    [self.view addSubview:_headView];
    
    _centerView = [[FSMeCenterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame) + 10, SCREEN_WIDTH, 115)];
    [self.view addSubview:_centerView];
    
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSMeBottomView class]) owner:self options:nil] lastObject];
    _bottomView.delegate = self;
//    _bottomView = [[FSMeBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerView.frame) + 10, SCREEN_WIDTH, 200)];
    [self.view addSubview:_bottomView];
}



- (void)viewDidLayoutSubviews {
    _bottomView.frame = CGRectMake(0, 335, SCREEN_WIDTH, 200);

}

- (void)fsHeadView:(FSMeHeadView *)fsHeadView loginButtonTouchUpInside:(UIButton *)sender {
    NSLog(@"登录");
    
    FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
    
    FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navController animated:YES completion:nil];
    
    //[self pushViewControllerWithVC:[FSLoginViewController new]];
}

- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView couponsButtonClick:(UIButton *)sender {
    [self pushViewControllerWithVC:[FSMyCouponsViewController new]];
}

- (void)fsMeBottomView:(FSMeBottomView *)fsMeBottomView collecButtonClick:(UIButton *)sender {
    
}

#pragma mark 前往设置界面
- (void)goSetting {
    [self pushViewControllerWithVC:[FSMoreViewController new]];
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
             
            
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
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
