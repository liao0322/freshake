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

@end

@implementation MySiteViewController

- (void)viewWillAppear:(BOOL)animated {
    [self requestUserAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [Utillity customNavToTitle:@"我的地址"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"收货-增加收货地址") WithTarget:self action:@selector(goAddSite)];
    
    [self initUserSiteView];
}

- (void)initUserSiteView {
    
    _userAddressArray = [NSMutableArray array];
    _userSiteView = [[SelectDeliverySiteView alloc] initWithFrame:self.view.bounds];
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

@end
