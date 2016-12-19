//
//  SelectSiteViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "SelectSiteViewController.h"

// Cell
#import "PointDeliveryCell.h"
#import "SiteLocationCell.h"

// Controller
#import "EditSiteViewController.h"
#import "ShopLoginViewController.h"
#import "BDMapViewController.h"
#import "SelectCityViewController.h"
#import "SelectLocationViewController.h"

#import "Address.h"
#import "Map.h"

@interface SelectSiteViewController ()
{
    NSMutableArray *_MapArray;
    NSInteger index;
    NSInteger count;
    NSInteger _section;
}

@end

@implementation SelectSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _MapArray = [NSMutableArray array];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"选择自提点"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCity"] style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"0xffb743"];
    
    CGRect frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];

    [self.tableView registerClass:[SiteLocationCell class] forCellReuseIdentifier:@"SiteLocationCell"];
    [self.tableView registerClass:[PointDeliveryCell class] forCellReuseIdentifier:@"PointDeliveryCell"];
    
    [self getShoppingCartNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self request];
}

- (void)selectCity {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[SelectCityViewController new] animated:YES];
}

- (void)back{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"topAdree"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _MapArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        SiteLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteLocationCell"];
        [cell updateName];
        return cell;
    }
    
    PointDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointDeliveryCell"];
    
    if (_MapArray.count > 0) {
        
        [cell setModel:_MapArray[indexPath.section - 1]];
    }
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 45;
    }
    
    id model = _MapArray[indexPath.section - 1];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[PointDeliveryCell class] contentViewWidth:ScreenWidth];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 1
    _section = indexPath.section;
    
    [Single sharedInstance].isLoadAdvertising = YES;
    
    if (indexPath.section == 0)
    {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[BDMapViewController new] animated:YES];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL firstSelect = [defaults boolForKey:@"firstSelect"];
        if (firstSelect == NO)
        {
            index = indexPath.section-1;
            
            if ([_goodsCountString integerValue] > 0) {
//                [Tools myAlert:@"由于各店面品类各有不同，为了确保您的订单有效，更改自提点会清空您的购物车，点击确定按钮更改" target:self];
                
                [Single sharedInstance].address = _MapArray[index];
                [Single sharedInstance].isShowSite = 1;
                
                Map *model = _MapArray[index];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:model.Fendianname forKey:@"merchantsName"];
                [defaults setObject:model.id forKey:@"merchantsID"];
                [defaults setObject:model.mid forKey:@"MID"];
                [defaults setObject:model.addr forKey:@"merchantsAddress"];
                [defaults setObject:model.picktime forKey:@"merchantsTime"];
                [defaults setObject:model.pickJuli forKey:@"distance"];
                [defaults setObject:model.Distance forKey:@"Distance"];
                [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
                [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
                
                [self delStoreGoods];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else {
                
                [Single sharedInstance].address = _MapArray[index];
                [Single sharedInstance].isShowSite = 1;
                
                Map *model = _MapArray[index];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:model.Fendianname forKey:@"merchantsName"];
                [defaults setObject:model.id forKey:@"merchantsID"];
                [defaults setObject:model.mid forKey:@"MID"];
                [defaults setObject:model.addr forKey:@"merchantsAddress"];
                [defaults setObject:model.picktime forKey:@"merchantsTime"];
                [defaults setObject:model.pickJuli forKey:@"distance"];
                [defaults setObject:model.Distance forKey:@"Distance"];
                [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
                [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
                [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];

                [self delStoreGoods];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
        else
        {
            if ([_goodsCountString integerValue] > 0) {
//                [Tools myAlert:@"由于各店面品类各有不同，为了确保您的订单有效，更改自提点会清空您的购物车，点击确定按钮更改" target:self];
                
                [Single sharedInstance].address = _MapArray[index];
                [Single sharedInstance].isShowSite = 1;
                
                Map *model = _MapArray[index];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:model.Fendianname forKey:@"merchantsName"];
                [defaults setObject:model.id forKey:@"merchantsID"];
                [defaults setObject:model.mid forKey:@"MID"];
                [defaults setObject:model.addr forKey:@"merchantsAddress"];
                [defaults setObject:model.picktime forKey:@"merchantsTime"];
                [defaults setObject:model.pickJuli forKey:@"distance"];
                [defaults setObject:model.Distance forKey:@"Distance"];
                [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
                [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
                
                [self delStoreGoods];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
            [Single sharedInstance].address = _MapArray[index];
            [Single sharedInstance].isShowSite = 1;
            
            Map *model = _MapArray[indexPath.section-1];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:model.Fendianname forKey:@"merchantsName"];
            [defaults setObject:model.id forKey:@"merchantsID"];
            [defaults setObject:model.mid forKey:@"MID"];
            [defaults setObject:model.addr forKey:@"merchantsAddress"];
            [defaults setObject:model.picktime forKey:@"merchantsTime"];
            [defaults setObject:nil forKey:@"topAdree"];
            [defaults setObject:model.pickJuli forKey:@"distance"];
            [defaults setObject:model.Distance forKey:@"Distance"];
            [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
            [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
            
            //是否第一次选择
            [defaults setBool:NO forKey:@"firstSelect"];
            
            [self delStoreGoods];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
#else 
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[SelectLocationViewController new] animated:YES];
    
#endif
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [Single sharedInstance].address = _MapArray[index];
        [Single sharedInstance].isShowSite = 1;
        
        Map *model = _MapArray[index];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.Fendianname forKey:@"merchantsName"];
        [defaults setObject:model.id forKey:@"merchantsID"];
        [defaults setObject:model.mid forKey:@"MID"];
        [defaults setObject:model.addr forKey:@"merchantsAddress"];
        [defaults setObject:model.picktime forKey:@"merchantsTime"];
        [defaults setObject:model.pickJuli forKey:@"distance"];
        [defaults setObject:model.Distance forKey:@"Distance"];
        [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
        [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
        
        [self delStoreGoods];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)PushAddAdress
{
    EditSiteViewController *addSiteVC = [[EditSiteViewController alloc] init];
    addSiteVC.isShowContent = YES;
    [self.navigationController pushViewController:addSiteVC animated:YES];
}

#pragma mark - 数据请求
- (void)request {
    
    [_MapArray removeAllObjects];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float latitude = [userDefaults doubleForKey:@"positioningLatitude"];
    float longitude = [userDefaults doubleForKey:@"positioningLongitude"];
    
    NSLog(@"latitude = %f\nlongitude = %f",latitude,longitude);
    
    NSString *urlString = [NSString stringWithFormat:MAPURL,latitude,longitude];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data count] == 2) {
             [Tools myHud:@"该位置暂无提货点" inView:self.view];
         }
         
         for (NSDictionary *dic in data[@"list"]) {
             
             Map *mapModel = [[Map alloc] init];
             [mapModel setValuesForKeysWithDictionary:dic];
             [_MapArray addObject:mapModel];
         }
         
         [self.tableView reloadData];
         
     } failure:nil];
}

#pragma mark 获取购物车数量
- (void)getShoppingCartNum {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         count = [data[@"count"] integerValue];
         
     } failure:nil];
}

#pragma mark 删除购物车商品
- (void)delStoreGoods{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:DelStoreCartUrl,UUID,mid,uid];
    NSLog(@"urlString = %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         NSLog(@"删除成功");
         
     } failure:nil];
    
    float latitude = [userDefaults doubleForKey:@"positioningLatitude"];    // 经度
    float longitude = [userDefaults doubleForKey:@"positioningLongitude"]; // 纬度
    NSString *uidString = [userDefaults objectForKey:@"UID"];       // 用户ID
    NSString *mobile = [userDefaults objectForKey:@"mobile"];       // 用户号码
    NSString *address = [userDefaults objectForKey:@"address"];     // 用户地址
    NSString *avatar = [userDefaults objectForKey:@"avatar"];       // 头像
    NSString *nick_name = [userDefaults objectForKey:@"nick_name"]; // 昵称
    NSString *user_name = [userDefaults objectForKey:@"user_name"]; // 会员名
    NSString *sex = [userDefaults objectForKey:@"sex"];             // 性别
    NSString *birthday = [userDefaults objectForKey:@"birthday"];               // 生日
    NSString *firstStart = [userDefaults objectForKey:@"firstStart"];           // 首次运行程序
    NSString *merchantsID = [userDefaults objectForKey:@"merchantsID"];         // 提货点ID
    NSString *merchantsName = [userDefaults objectForKey:@"merchantsName"];     // 提货点名字
    NSString *merchantsTime = [userDefaults objectForKey:@"merchantsTime"];     // 提货点时间
    NSString *distance = [userDefaults objectForKey:@"distance"];               // 距离
    NSString *merchantsAddress = [userDefaults objectForKey:@"merchantsAddress"];   // 提货点地址
    NSString *couponNum = [userDefaults objectForKey:@"CouponNum"];
    NSString *folderNum = [userDefaults objectForKey:@"FolderNum"];
    NSString *amount = [userDefaults objectForKey:@"amount"];
    NSString *exp = [userDefaults objectForKey:@"exp"];
    
    BOOL IsDistribution = [userDefaults boolForKey:@"IsDistribution"];      // 是否送货上门
    NSString *DistanceString = [userDefaults objectForKey:@"Distance"];     // 可送距离
    NSString *DistancePriceString = [userDefaults objectForKey:@"DistancePrice"];   // 配送价格
    NSString *group_id = [userDefaults objectForKey:@"group_id"];
    
    // 清除沙盒
    [Utillity deleteCache];
    
    // 重新赋值
    [userDefaults setObject:nil forKey:@"topAdree"];
    [userDefaults setObject:uidString forKey:@"UID"];
    [userDefaults setObject:mobile forKey:@"mobile"];
    [userDefaults setObject:folderNum forKey:@"FolderNum"];
    [userDefaults setObject:couponNum forKey:@"CouponNum"];
    [userDefaults setObject:address forKey:@"address"];
    [userDefaults setObject:amount forKey:@"amount"];
    [userDefaults setObject:avatar forKey:@"avatar"];
    [userDefaults setObject:exp forKey:@"exp"];
    [userDefaults setObject:nick_name forKey:@"nick_name"];
    [userDefaults setObject:user_name forKey:@"user_name"];
    [userDefaults setObject:sex forKey:@"sex"];
    [userDefaults setObject:birthday forKey:@"birthday"];
    
    [userDefaults setObject:firstStart forKey:@"firstStart"];
    [userDefaults setObject:merchantsID forKey:@"merchantsID"];
    [userDefaults setObject:merchantsName forKey:@"merchantsName"];
    [userDefaults setObject:merchantsAddress forKey:@"merchantsAddress"];
    [userDefaults setObject:merchantsTime forKey:@"merchantsTime"];
    [userDefaults setObject:distance forKey:@"distance"];
    
    [userDefaults setDouble:latitude forKey:@"positioningLatitude"];
    [userDefaults setDouble:longitude forKey:@"positioningLongitude"];
    
    [userDefaults setObject:DistanceString forKey:@"Distance"];
    [userDefaults setObject:DistancePriceString forKey:@"DistancePrice"];
    [userDefaults setObject:group_id forKey:@"group_id"];
    [userDefaults setBool:IsDistribution forKey:@"IsDistribution"];
    
    Map *mapModel =_MapArray[_section - 1];
    [userDefaults setObject:mapModel.Fendianname forKey:@"Fendianname"];
    [userDefaults setObject:mapModel.mid forKey:@"MID"];
    [userDefaults setObject:mapModel.xPoint forKey:@"xPoint"];
    [userDefaults setObject:mapModel.yPoint forKey:@"yPoint"];
    [userDefaults setObject:mapModel.fullPrice forKey:@"fullPrice"];
    
    [userDefaults synchronize];
}

@end
