//
//  XFMeViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/2/10.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "XFMeViewController.h"
#import "XFMeHeaderTVCell.h"
#import "XFMeMyOrderTVCell.h"
#import "XFMeBottomTVCell.h"
#import "XFNotLoginedHeaderTVCell.h"
#import "MeModel.h"
#import "MoreViewController.h"
#import "FSLoginViewController.h"
#import "FSNavigationController.h"
#import "MyOrderModel.h"
#import "XFMeVerticalButton.h"
#import "PointRecordViewController.h"
#import "AmountViewController.h"
#import "FSGiftCardViewController.h"
#import "FSMyCouponsViewController.h"
#import "PersonalDataViewController.h"
#import "FSMyOrderListViewController.h"
#import "MyGroupViewController.h"
#import "FSMyCouponsViewController.h"
#import "MyCollectViewController.h"
#import "MySiteViewController.h"
#import "HelpViewController.h"

@interface XFMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *uidString;

@property (copy, nonatomic) NSString *pointString;

@property (copy, nonatomic) NSString *moneyString;

@property (nonatomic) MeModel *model;
@property (nonatomic) MyOrderModel *orderModel;

@end

@implementation XFMeViewController

static CGFloat const EstimatedCellHeight = 200.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if (![Tools isBlankString:self.uidString]) {
        
        [self requestPoint];
        [self requestOrderCount];
    } else {
        self.model = nil;
        self.orderModel = nil;
        [self.tableView reloadData];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ( self.navigationController.childViewControllers.count > 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedCellHeight;
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogined) name:@"UserIsLogined" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogout) name:@"UserIsLogout" object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (SCREEN_HEIGHT == 480) {
        self.tableView.contentSize = CGSizeMake(0, SCREEN_HEIGHT + 100);
    } else if (SCREEN_HEIGHT == 568) {
        self.tableView.contentSize = CGSizeMake(0, SCREEN_HEIGHT + 70);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
        if ([Tools isBlankString:self.uidString]) { // 未登录
            XFNotLoginedHeaderTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFNotLoginedHeaderTVCell class]) owner:nil options:nil] lastObject];
            cell.loginBlock = ^{
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            };
            
            return cell;
        } else { //
            XFMeHeaderTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFMeHeaderTVCell class]) owner:nil options:nil] lastObject];
            if (self.model) {
                cell.pointLabel.text = self.model.point;
                cell.balanceLabel.text = [NSString stringWithFormat:@"￥%@", self.model.amount];
                cell.couponsLabel.text = self.model.TickNum;
            }
            
            cell.avatarButtonBlock = ^{
                [self.navigationController pushViewController:[PersonalDataViewController new] animated:YES];

            };
            
            cell.pointTapBlock = ^{
                PointRecordViewController *pointVC = [[PointRecordViewController alloc] init];
                pointVC.point = self.pointString;
                [self.navigationController pushViewController:pointVC animated:YES];
            };
            cell.balanceTapBlock = ^{
                [self.navigationController pushViewController:[AmountViewController new] animated:YES];
            };
            cell.couponsTapBlock = ^{
                [self.navigationController pushViewController:[FSMyCouponsViewController new] animated:YES];
            };
            
            return cell;

        }
        
    } else if (section == 1) {
        XFMeMyOrderTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFMeMyOrderTVCell class]) owner:nil options:nil] lastObject];
        
        if ([self.orderModel.NoPaymentCount integerValue] == 0) {
            cell.waitForPayButton.countLabel.hidden = YES;
        } else {
            cell.waitForPayButton.countLabel.text = [NSString stringWithFormat:@"%zd", [self.orderModel.NoPaymentCount integerValue]];
        }
        
        if ([self.orderModel.NoPickupCount integerValue] == 0) {
            cell.waitForPickUpButton.countLabel.hidden = YES;
        } else {
            cell.waitForPickUpButton.countLabel.text = [NSString stringWithFormat:@"%zd", [self.orderModel.NoPickupCount integerValue]];
        }
        
        if ([self.orderModel.CompleteCount integerValue] == 0) {
            cell.pickedButton.countLabel.hidden = YES;
        } else {
            cell.pickedButton.countLabel.text = [NSString stringWithFormat:@"%zd", [self.orderModel.CompleteCount integerValue]];
        }
        
        if ([self.orderModel.EvaluateCount integerValue] == 0) {
            cell.waitForCommentButton.countLabel.hidden = YES;
        } else {
            cell.waitForCommentButton.countLabel.text = [NSString stringWithFormat:@"%zd", [self.orderModel.EvaluateCount integerValue]];
        }
        
        cell.viewAllOrdersBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 0;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        cell.waitForPayBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 1;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        cell.waitForPickUpBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 2;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        cell.pickedBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 3;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        cell.waitForCommentBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 4;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        
        
        
        return cell;
        
    } else if (section == 2) {
        XFMeBottomTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFMeBottomTVCell class]) owner:nil options:nil] lastObject];
        
        cell.giftCardBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                [self.navigationController pushViewController:[FSGiftCardViewController new] animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }

        };
        
        cell.myGroupBuyBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                [self.navigationController pushViewController:[MyGroupViewController new] animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        
        cell.myCouponsBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                [self.navigationController pushViewController:[FSMyCouponsViewController new] animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        
        cell.myFavouriteBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                [self.navigationController pushViewController:[MyCollectViewController new] animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        
        cell.myAddressBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                [self.navigationController pushViewController:[MySiteViewController new] animated:YES];
            }
            else {
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:navController animated:YES completion:nil];
            }
        };
        
        cell.helpCenterBlock = ^{
            [self.navigationController pushViewController:[HelpViewController new] animated:YES];
        };
        
        cell.customerServiceBlock = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001725757"] options:@{} completionHandler:^(BOOL success) {
                
            }];
        };
        
        return cell;
    }
    
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        return SCREEN_WIDTH * (200 / 375.0f);
    } else if (section == 2) {
        return 285.0f;
        
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

#pragma mark - Custom

- (IBAction)toSettings {
    [self.navigationController pushViewController:[MoreViewController new] animated:YES];
}

- (void)userIsLogined {
    [self.tableView reloadData];
}

- (void)userIsLogout {
    [self.tableView reloadData];
}

- (void)requestOrderCount {
    NSString *urlString = [NSString stringWithFormat:GetOrderSum,self.uidString];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        MyOrderModel *model = [[MyOrderModel alloc] init];
        [model setDic:dict];
        self.orderModel = model;
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];

    
}

- (void)requestPoint {
    NSString *urlString = [NSString stringWithFormat:GetUSERINFO,self.uidString];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        if (![[dict objectForKey:@"issuccess"] boolValue]) {
            [SVProgressHUD showInfoWithStatus:dict[@"context"]];
            return;
        }
        
        MeModel *model = [MeModel new];
        
        model.point = [NSString stringWithFormat:@"%@",dict[@"point"]];
        model.TickNum = [NSString stringWithFormat:@"%@",dict[@"TickNum"]];
        model.amount = [NSString stringWithFormat:@"%@",dict[@"amount"]];
        model.group_id = [NSString stringWithFormat:@"%@",dict[@"group_id"]];
        self.model = model;
        
        self.pointString = model.point;
        self.moneyString = model.amount;
        
        // 积分
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"point"] forKey:@"point"];
        // 金额
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"amount"] forKey:@"amount"];
        // 优惠券数量
        [[NSUserDefaults standardUserDefaults] setObject:dict[@"group_id"] forKey:@"group_id"];
        
        [self.tableView reloadData];

    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}



#pragma mark - LazyLoad

- (NSString *)uidString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
}

@end
