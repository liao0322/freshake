//
//  MySiteViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MySiteViewController.h"
#import "SelectDeliverySiteView.h"
#import "deliverySiteViewController.h"

@interface MySiteViewController ()
{
    UIImageView *imageView;
}

@property (nonatomic, copy) NSMutableArray *userAddressArray;
@property (nonatomic, copy) SelectDeliverySiteView *userSiteView;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoor;
@property (nonatomic, strong) Map *mapModel;
@property (nonatomic, assign) BOOL isDeleteSite;



@end

@implementation MySiteViewController

- (void)viewWillAppear:(BOOL)animated {
    [self requestUserAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"我的地址"];
    self.title = @"我的地址";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:[IMAGE(@"收货-增加收货地址") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] WithTarget:self action:@selector(goAddSite)];
    
    [self initUserSiteView];
}

- (void)initUserSiteView {
    
    _userAddressArray = [NSMutableArray array];
    _userSiteView = [[SelectDeliverySiteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _userSiteView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_userSiteView];
    
    [self requestUserAddressList];
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(_userAddressArray)weakArray = _userAddressArray;
    _userSiteView.addBtnClick = ^(BOOL isDel, NSInteger index){
        deliverySiteViewController *siteVC = [[deliverySiteViewController alloc] init];
        siteVC.isDeleteSite = isDel;
        
        if (isDel) siteVC.siteModel = weakArray[index];
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:siteVC animated:YES];
    };
    
    _userSiteView.deleteAddress = ^(NSString *idString) {
        [weakSelf deleteRequstWithId:idString];
    };
    
    _userSiteView.defaultAddress = ^(BOOL isDel,SiteModel *model) {
        _isDeleteSite = isDel;
        [weakSelf saveUserInfo:model];
    };
    
    _userSiteView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestUserAddressList];
        [_userSiteView.tableView.mj_header endRefreshing];
    }];
    
//    _userSiteView.defaultBtnClick = ^(BOOL isDefault, NSInteger index) {
//        deliverySiteViewController *siteVC = [[deliverySiteViewController alloc] init];
//        siteVC.isDefault = isDefault;
//        if (isDefault) siteVC.siteModel = weakArray[index];
//        [weakSelf.navigationController pushViewController:siteVC animated:YES];
//
//    };
   
    
    _userSiteView.userAddress = ^(SiteModel *siteModel) {};
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

#pragma mark 送货地址
- (void)requestUserAddressList {
    
    _userSiteView.hidden = NO;
    imageView.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetUserAddressList,uidString];
    NSLog(@"==我的地址==%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [_userAddressArray removeAllObjects];
             for (NSDictionary *dic in data[@"AddressList"]) {
                 
                 SiteModel *model = [[SiteModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 [_userAddressArray addObject:model];
                 
             }
             
             _userSiteView.siteArray = _userAddressArray;
             [_userSiteView refreshSite];
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
         if (_userAddressArray.count == 0)
         {
             _userSiteView.hidden = YES;
             imageView.hidden = NO;
             if (imageView == nil)
             {
                 imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50, SCREEN_HEIGHT/2-100, 100, 100)];
             }
             imageView.image = IMAGE(@"无数据");
             imageView.contentMode = UIViewContentModeCenter;
             [self.view addSubview:imageView];
             
         }
         
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
    
    
//    if ([Tools isBlankString:userName]) {
//        return [Tools myHud:@"请输入收货人名字" inView:self.view];
//    }
//    if ([Tools isBlankString:phoneString]) {
//        return [Tools myHud:@"请填写手机号码" inView:self.view];
//    }
//    else if (![Tools isMobileNum:phoneString]) {
//        return [Tools myHud:@"请输入正确号码" inView:self.view];
//    }
//    else if ([Tools isBlankString:cityStirng]) {
//        return [Tools myHud:@"请选择所在城市" inView:self.view];
//    }
//    else if ([Tools isBlankString:areaString]) {
//        return [Tools myHud:@"请选择地址" inView:self.view];
//    }
    
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
             [_userSiteView.tableView.mj_header beginRefreshing];
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
             [_userSiteView.tableView.mj_header beginRefreshing];
             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}


@end
