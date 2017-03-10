//
//  ChooseAddressViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/25.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

// Controller
#import "ChooseAddressViewController.h"
#import "deliverySiteViewController.h"
// View
#import "SelectDeliverySiteView.h"
#import "SelectStoreDeliveryView.h"
// Model
#import "Map.h"
#import "SiteModel.h"

@interface ChooseAddressViewController ()

@property (nonatomic, strong) UISegmentedControl *segmented;
// 提货点
@property (nonatomic, strong) NSMutableArray *pointArray;
// 配送地址
@property (nonatomic, strong) NSMutableArray *distributionArray;
// 用户地址
@property (nonatomic, strong) SelectDeliverySiteView *userSiteView;
// 提货点地址
@property (nonatomic, strong) SelectStoreDeliveryView *selectStoreDeliveryView;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoor;

@property (nonatomic, strong) Map *mapModel;

@end

@implementation ChooseAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    
    if (_segmented == nil) {
        
        // 刷新提货点
        if (_deliveryStatus) [self getMStore];
        // 刷新取货地址
        else [self getUserAddressList];
    }
    else {
        
        // 刷新提货点
        if (_segmented.selectedSegmentIndex == 1) [self getMStore];
        // 刷新取货地址
        else [self getUserAddressList];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pointArray = [NSMutableArray array];
    self.distributionArray = [NSMutableArray array];
    
    [self setNav];
    [self initPointDeliveryView];
    [self initManageAddressView];
}

// 提货点
- (void)initPointDeliveryView {
    
    self.selectStoreDeliveryView = [[SelectStoreDeliveryView alloc] initWithFrame:self.view.bounds];
    self.selectStoreDeliveryView.hidden = YES;
    [self.view addSubview:self.selectStoreDeliveryView];
    
    WS(weakSelf);
    self.selectStoreDeliveryView.midSite = ^(Map *mapArray){
        weakSelf.addressBlock(mapArray, YES);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

// 配送地址
- (void)initManageAddressView {
    
    self.userSiteView = [[SelectDeliverySiteView alloc] initWithFrame:self.view.bounds];
    self.userSiteView.hidden = YES;
    [self.view addSubview:self.userSiteView];
    
    WS(weakSelf);
    // 添加地址
    __weak typeof(self.distributionArray)weakArray = self.distributionArray;
    self.userSiteView.addBtnClick = ^(BOOL isDel, NSInteger index){
        
        deliverySiteViewController *siteVC = [[deliverySiteViewController alloc] init];
        siteVC.isDeleteSite = isDel;
        
        if (isDel) siteVC.siteModel = weakArray[index];
        [weakSelf.navigationController pushViewController:siteVC animated:YES];
    };
    
    // 删除地址
    _userSiteView.deleteAddress = ^(NSString *idString) {
        
        [weakSelf deleteRequstWithId:idString];
    };
    
    // 默认地址
    _userSiteView.defaultAddress = ^(BOOL isDel,SiteModel *model) {
        _isDeleteSite = isDel;
        [weakSelf saveUserInfo:model];
    };
    
    self.userSiteView.userAddress = ^(SiteModel *siteArray) {
        weakSelf.addressBlock(siteArray, NO);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

// 设置导航条
- (void)setNav {
    
    // 返回
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    // 开启了配送和自提
    if (_deliveryStatus == 0 && _distributionStatus) {
        
        _segmented = [[UISegmentedControl alloc] initWithItems:@[@"送货上门", @"店铺自提"]];
        _segmented.selectedSegmentIndex = 0;
        _segmented.tintColor = [UIColor colorDomina];
        [_segmented addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = _segmented;
    }
    else {
        
        self.navigationItem.titleView = [Utillity customNavToTitle:_distributionStatus ? @"送货上门" : @"店铺自提"];

        if (_distributionStatus) {
            
            self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:[IMAGE(@"addAddress") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] WithTarget:self action:@selector(goAddress)];
        }
    }
}

#pragma mark - 事件处理
// 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 前往添加地址界面
- (void)goAddress {
    [self pushViewControlle:[NSClassFromString(@"deliverySiteViewController") new] backIsHiddenTabbar:YES];
}

// 选择送货类型
- (void)valueChange:(UISegmentedControl *)segment {
    
    if (segment.selectedSegmentIndex == 0) {
        
        [self getUserAddressList];
        self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:[IMAGE(@"addAddress") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] WithTarget:self action:@selector(goAddress)];
    }
    else {
        
        [self getMStore];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - 数据请求
// 获取自提商家
- (void)getMStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float latitude = [defaults doubleForKey:@"positioningLatitude"];
    float longitude = [defaults doubleForKey:@"positioningLongitude"];
    // 商家ID
    NSString *midString = _isCollect ? _midStr : [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GETMSTORE,midString,latitude,longitude,@"0"];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            [self.pointArray removeAllObjects];
            
            for (NSDictionary *dic in data[@"list"]) {
                
                Map *mapModel = [[Map alloc] init];
                [mapModel setValuesForKeysWithDictionary:dic];
                [self.pointArray addObject:mapModel];
            }
            
            self.userSiteView.hidden = YES;
            self.selectStoreDeliveryView.hidden = NO;
            self.selectStoreDeliveryView.siteArray = self.pointArray;
            [self.selectStoreDeliveryView refreshSite];
        }
        else [Tools myHud:data[@"context"]];
    
    } failure:nil];
}

// 获取送货地址
- (void)getUserAddressList {

    NSString *urlString = [NSString stringWithFormat:GetUserAddressList, GetUserId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            [self.distributionArray removeAllObjects];
            
            for (NSDictionary *dic in data[@"AddressList"]) {
                
                SiteModel *model = [[SiteModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.distributionArray addObject:model];
            }
            
            self.userSiteView.hidden = NO;
            self.selectStoreDeliveryView.hidden = YES;
            self.userSiteView.siteArray = self.distributionArray;
            [self.userSiteView refreshSite];
        }
        else [Tools myHud:data[@"context"]];
    
    } failure:nil];
}

#pragma mark 保存用户信息
- (void)saveUserInfo:(SiteModel *)model {
    NSLog(@"%@", model);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *userName = model.userName;
    NSString *idString = _isDeleteSite ? model.id : @"0";
    NSString *phoneString = model.Phone;
    NSString *cityStirng = model.City;
    NSString *areaString = model.Area;
    NSString *addressString = model.Address;
    NSString *sexString = model.sex;
    
    
    if ([model.Area isEqualToString:areaString]) {
        
        _currentCoor.latitude = [model.X doubleValue];
        _currentCoor.longitude = [model.Y doubleValue];
    }
    else {
        
        _currentCoor.latitude = [_mapModel.xPoint doubleValue];
        _currentCoor.longitude = [_mapModel.yPoint doubleValue];
    }
    
    NSString *urlString = [NSString stringWithFormat:EditAddress,uidString,userName,sexString,idString,cityStirng,areaString,addressString,phoneString,_currentCoor.latitude, _currentCoor.longitude, [Single sharedInstance].cityId, 1];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             
             //             [_userSiteView.tableView.mj_header beginRefreshing];
             [self getUserAddressList];
             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}


#pragma mark 删除地址
- (void)deleteRequstWithId:(NSString *)idString {
    
    NSString *urlString = [NSString stringWithFormat:DeleteAdress,idString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             //             [self.navigationController popViewControllerAnimated:YES];
//             [_userSiteView.tableView.mj_header beginRefreshing];
             [self getUserAddressList];

             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}

@end
