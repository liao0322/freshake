//
//  FSMyCouponsViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMyCouponsViewController.h"
#import "FSMyCouponView.h"
#import "FSMyCouponsCell.h"


@interface FSMyCouponsViewController ()

@property (nonatomic, strong) FSMyCouponView *myCouponView;
@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation FSMyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"我的优惠券"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self
                                                                        action:@selector(back)];
    [self initMyCouponView];
    
    if (!_isSelectCoupon) {
        [self getCouponsData];
    }
    else {
        self.myCouponView.dataSource = self.couponArray;
    }
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initMyCouponView {
    
    self.myCouponView = [[FSMyCouponView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.myCouponView.isSelectCoupon = self.isSelectCoupon;
    [self.view addSubview:self.myCouponView];
    
   
    
    WS(weakSelf);
    [self.myCouponView setSelectCoupon:^(NSString *priceString, NSString *idString, BOOL isSelect) {
        weakSelf.selectCoupon(priceString, idString, isSelect);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.myCouponView setSelectGoodsCoupon:^(NSString *priceString, NSString *idString, BOOL isSelect, NSInteger index) {
        weakSelf.selectGoodsCoupon(priceString, idString, isSelect, index);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.myCouponView setGoViewController:^(UIViewController *viewController) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
    
    if (!self.isSelectCoupon) {
        self.myCouponView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getCouponsData];
        }];
    }
}

- (void)getCouponsData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:@"%@&IsExpired=-1&IsUseful=-1", [NSString stringWithFormat:GetMyTickList,1,1000,uidString]];
    NSLog(@"*****我的优惠券*****%@", urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data) {
        
        NSMutableArray *arr = [NSMutableArray array];
        if ([data[@"issuccess"] boolValue]) {
            for (NSDictionary *dict in data[@"List"]) {
                CouponModel *model = [[CouponModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [arr addObject:model];
            }
            
            self.myCouponView.dataSource = arr;
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        if (arr.count == 0) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, SCREEN_HEIGHT/2 - 100, 100, 100)];
            imageView.image = IMAGE(@"无数据");
            imageView.contentMode = UIViewContentModeCenter;
            [self.view addSubview:imageView];
        }
        
        [self.myCouponView.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.myCouponView.tableView.mj_header endRefreshing];
        
    }];
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
