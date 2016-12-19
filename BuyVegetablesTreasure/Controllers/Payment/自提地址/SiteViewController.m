//
//  SiteViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SiteViewController.h"
#import "deliverySiteViewController.h"
#import "SelectDeliverySiteView.h"
#import "SelectStoreDeliveryView.h"

@interface SiteViewController ()

@property (nonatomic, copy) NSMutableArray *siteArray;
@property (nonatomic, copy) NSMutableArray *userAddressArray;
@property (nonatomic, copy) SelectDeliverySiteView *userSiteView;
@property (nonatomic, copy) SelectStoreDeliveryView *selectStoreDeliveryView;
@property (nonatomic, copy) UISegmentedControl *segmented;

@end

@implementation SiteViewController

- (void)viewWillAppear:(BOOL)animated {
    
    // 提货点
    if (_isDelivery) {
        
        _selectStoreDeliveryView.hidden = NO;
        [self requestDataFromNet];
    }
    
    // 送货地址
    if (_isDistribution) {
        
        _userSiteView.hidden = NO;
        [self requestUserAddressList];
    }
    
    _segmented.selectedSegmentIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _siteArray = [NSMutableArray array];
    _userAddressArray = [NSMutableArray array];

    // 设置导航条
    [self setNav];
    // 提货地址
    [self initSiteView];
}

#pragma mark - 初始化
#pragma mark 导航条
- (void)setNav {

    if (_isDistribution && _isDelivery) {
        
        _segmented = [[UISegmentedControl alloc] initWithItems:@[@"店铺自提",@"送货上门"]];
        _segmented.selectedSegmentIndex = 0;
        _segmented.tintColor = [UIColor colorWithHexString:@"0xff6600"];
        [_segmented addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = _segmented;
    }
    else {
        
        self.navigationItem.titleView = [Utillity customNavToTitle:_isDelivery ? @"店铺自提" : @"送货上门"];
        
        if (_isDistribution) {
            
            self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"收货-增加收货地址") WithTarget:self action:@selector(goAddSite)];
        }
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark 创建地址View
- (void)initSiteView {
    
    __weak typeof(self)weakSelf = self;
    
    if (_isDistribution) {
        
        _userSiteView = [[SelectDeliverySiteView alloc] initWithFrame:self.view.bounds];
        _userSiteView.hidden = YES;
        [self.view addSubview:_userSiteView];
        
        __weak typeof(_userAddressArray)weakArray = _userAddressArray;
        _userSiteView.addBtnClick = ^(BOOL isDel, NSInteger index){
            deliverySiteViewController *siteVC = [[deliverySiteViewController alloc] init];
            siteVC.isDeleteSite = isDel;
            
            if (isDel) siteVC.siteModel = weakArray[index];
            [weakSelf.navigationController pushViewController:siteVC animated:YES];
        };
        _userSiteView.userAddress = ^(SiteModel *siteArray) {
            weakSelf.userAddress(siteArray);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    
    if (_isDelivery) {
        
        _selectStoreDeliveryView = [[SelectStoreDeliveryView alloc] initWithFrame:self.view.bounds];
        _selectStoreDeliveryView.hidden = YES;
        [self.view addSubview:_selectStoreDeliveryView];
        
        _selectStoreDeliveryView.midSite = ^(Map *mapArray){
            weakSelf.midSite(mapArray);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
}

#pragma mark - 事件处理
#pragma mark 选择送货类型
- (void)valueChange:(UISegmentedControl *)segment {
    
    _userSiteView.hidden = !segment.selectedSegmentIndex;
    _selectStoreDeliveryView.hidden = segment.selectedSegmentIndex;
    
    if (segment.selectedSegmentIndex == 0) {
        [self requestDataFromNet];
    }
    else {
        [self requestUserAddressList];
    }
}

#pragma mark 前往添加地址界面
- (void)goAddSite {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[deliverySiteViewController new] animated:YES];
}

#pragma mark 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求
#pragma mark 请求提货点
- (void)requestDataFromNet {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float latitude = [defaults doubleForKey:@"positioningLatitude"];
    float longitude = [defaults doubleForKey:@"positioningLongitude"];
    NSString *midString = _isCollect ? _midStr : [defaults objectForKey:@"MID"];
    NSString *cityId = _isCollect ? @"0" : [Single sharedInstance].cityId;
    NSString *urlString = [NSString stringWithFormat:GETMSTORE,midString,latitude,longitude,cityId];

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            [_siteArray removeAllObjects];
            for (NSDictionary *dic in data[@"list"]) {
                
                Map *mapModel = [[Map alloc] init];
                [mapModel setValuesForKeysWithDictionary:dic];
                [_siteArray addObject:mapModel];
            }
            
            if (_siteArray.count == 0) {
                _selectStoreDeliveryView.hidden = YES;
            }
            else _selectStoreDeliveryView.hidden = NO;
            
            _selectStoreDeliveryView.siteArray = _siteArray;
            [_selectStoreDeliveryView refreshSite];
        }
        else {
            
            _selectStoreDeliveryView.hidden = NO;
            [Tools myHud:data[@"context"] inView:self.view];
        }
        
    } failure:nil];
}

#pragma mark 送货地址
- (void)requestUserAddressList {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetUserAddressList,uidString];
    
    NSLog(@"送货地址:%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [_userAddressArray removeAllObjects];
             for (NSDictionary *dic in data[@"AddressList"]) {
                 
                 SiteModel *model = [[SiteModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 [_userAddressArray addObject:model];
             }

             if (!_isDistribution) {
                 
                 if (_userAddressArray.count == 0) {
                     _userSiteView.hidden = YES;
                 }
                 else _userSiteView.hidden = NO;
             }

             _userSiteView.siteArray = _userAddressArray;
             [_userSiteView refreshSite];
         }
         else {
             
             _userSiteView.hidden = YES;
             [Tools myHud:data[@"context"] inView:self.view];
         }

     } failure:nil];
}



@end
