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
#import "XFMeCollectionViewCell.h"
#import "XFMeModel.h"
#import <MJExtension.h>
#import "FSMyQRCodeViewController.h"
#import "FSMyShareViewController.h"

#import "XFFloatButton.h"
#import "FSBindingPhoneView.h"
#import "IQKeyboardManager.h"
#import "XFKVCPersistence.h"

@interface XFMeViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *uidString;
@property (copy, nonatomic) NSString *pointString;
@property (copy, nonatomic) NSString *moneyString;

@property (nonatomic) MeModel *model;
@property (nonatomic) MyOrderModel *orderModel;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) NSMutableArray *itemsArray;

@property (nonatomic) XFFloatButton *floatButton;

@end

@implementation XFMeViewController

static CGFloat const EstimatedCellHeight = 200.0f;

static NSString * const CVCellID = @"CVCellID";

static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (SCREEN_WIDTH - (cols - 1) * margin) / cols

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    if (![Tools isBlankString:self.uidString]) {
        
        [self requestPoint];
        [self requestOrderCount];
    } else {
        self.model = nil;
        self.orderModel = nil;
        [self.tableView reloadData];
    }
    
    // 绑定手机 icon 是否显示
    NSString *mobile = [XFKVCPersistence get:@"mobile"];
    NSString *uid = [XFKVCPersistence get:@"UID"];
    if (uid) { // 已登录
        if (mobile && mobile.length != 0 && uid) {
            [self.floatButton removeFromSuperview];
            self.floatButton = nil;
        } else { // 无手机号
            [self.view addSubview:self.floatButton];
        }
    } else {
        [self.floatButton removeFromSuperview];
        self.floatButton = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( self.navigationController.childViewControllers.count > 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNotifications];
}

- (void)setupViews {
    [super setupViews];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedCellHeight;
    self.tableView.tableFooterView = self.collectionView;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogined) name:@"UserIsLogined" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIsLogout) name:@"UserIsLogout" object:nil];
}

- (void)registerViews {
    [super registerViews];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XFMeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CVCellID];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
                [self presentToLoginVC];
            }
        };
        cell.waitForPayBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 1;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                [self presentToLoginVC];
            }
        };
        cell.waitForPickUpBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 2;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                [self presentToLoginVC];
            }
        };
        cell.pickedBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 3;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                [self presentToLoginVC];
            }
        };
        cell.waitForCommentBlock = ^{
            if (![Tools isBlankString:self.uidString]) {
                FSMyOrderListViewController *myOrderListVC  = [FSMyOrderListViewController new];
                myOrderListVC.selectedIndex = 4;
                [self.navigationController pushViewController:myOrderListVC animated:YES];
            }
            else {
                [self presentToLoginVC];
            }
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
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BOOL isShare = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShare"] boolValue];
    if (!isShare) {
        return self.itemsArray.count - 1;
    }
    return self.itemsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFMeModel *model = self.itemsArray[indexPath.row];
    XFMeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CVCellID forIndexPath:indexPath];
    cell.titleLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XFMeModel *model = self.itemsArray[indexPath.row];
    
    BOOL isLogined = ![Tools isBlankString:self.uidString];
    
    if ([model.title isEqualToString:@"礼品卡"]) {
        isLogined ? [self.navigationController pushViewController:[FSGiftCardViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"我的拼团"]) {
        isLogined ? [self.navigationController pushViewController:[MyGroupViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"我的优惠券"]) {
        isLogined ? [self.navigationController pushViewController:[FSMyCouponsViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"我的收藏"]) {
        isLogined ? [self.navigationController pushViewController:[MyCollectViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"地址管理"]) {
        isLogined ? [self.navigationController pushViewController:[MySiteViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"帮助中心"]) {
        [self.navigationController pushViewController:[HelpViewController new] animated:YES];
    } else if ([model.title isEqualToString:@"客服热线"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001725757"] options:@{} completionHandler:^(BOOL success) {
        }];
    } else if ([model.title isEqualToString:@"我的分享"]) {
        isLogined ? [self.navigationController pushViewController:[FSMyShareViewController new] animated:YES] : [self presentToLoginVC];
    } else if ([model.title isEqualToString:@"我的二维码"]) {
        isLogined ? [self.navigationController pushViewController:[FSMyQRCodeViewController new] animated:YES] : [self presentToLoginVC];
    }
}

#pragma mark - Custom

- (void)floatButtonDidClicked:(XFFloatButton *)floatButton {
    //[[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:50];
    //[self.view addSubview:self.bindingPhoneView];
    [FSBindingPhoneView show];
}

- (void)presentToLoginVC {
    FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
    FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)toSettings {
    [self.navigationController pushViewController:[MoreViewController new] animated:YES];
}

- (void)userIsLogined {
    NSString *mobile = [XFKVCPersistence get:@"mobile"];
    if (mobile && mobile.length != 0) {
        [self.floatButton removeFromSuperview];
        self.floatButton = nil;
    } else { // 无手机号
        [self.view addSubview:self.floatButton];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view will begin dragging");
    if (self.floatButton && ![self.floatButton isHidden]) {
        [self.floatButton hidden];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scroll view did end decelerating");
    if (self.floatButton) {
        [self.floatButton show];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (self.floatButton) {
            [self.floatButton show];
        }
    }
    
    NSLog(@"scroll view did end dragging will decelerate");
}



#pragma mark - LazyLoad

- (NSString *)uidString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 200) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.tableView.backgroundColor;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        _flowLayout.minimumInteritemSpacing = margin;
        _flowLayout.minimumLineSpacing = margin;
    }
    return _flowLayout;
}

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray arrayWithArray:[XFMeModel mj_objectArrayWithFilename:@"MeItems.plist"]];
    }
    return _itemsArray;
}

- (XFFloatButton *)floatButton {
    if (!_floatButton) {
        _floatButton = [XFFloatButton floatButton];
        [_floatButton addTarget:self action:@selector(floatButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _floatButton;
}

@end
