//
//  HomePageController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HomePageController.h"
#import "SelectSiteViewController.h"
// Model
#import "GoodsModel.h"
#import "AdvertisingModel.h"
// View
#import "CurrentPointView.h"
#import "HomePageView.h"
#import "GoodsCartView.h"

@interface HomePageController ()<BMKLocationServiceDelegate>

// 商品数组
@property (nonatomic, strong) NSMutableArray *goodsArray;
// 首页视图
@property (nonatomic, strong) HomePageView *homePageView;
// 当前提货点
@property (nonatomic, strong) CurrentPointView *currentPointView;
// 购物车
@property (nonatomic, strong) GoodsCartView *cartView;
// 百度定位
@property (nonatomic, strong) BMKLocationService *locService;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 购物车
    [self initCartView];
    // 设置Nav
    [self setNav];
    // 获取商品
    [self getGoods];
    // 获取广告
    [self getAdvertising];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    // 商品数组
    self.goodsArray = [NSMutableArray array];
    // 设置Nav
    [self setNav];
    // 初始化
    [self initHomePageView];
    // 开始定位
//    [self startLocation];
}

- (void)initHomePageView {
    
    self.homePageView = [HomePageView new];
    self.homePageView.hidden = YES;
    [self.view addSubview:self.homePageView];
    
    self.homePageView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    WS(weakSelf);
    [self.homePageView setLookAllGoods:^{
        
        weakSelf.tabBarController.selectedIndex = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"1"];
    }];
    
    [self.homePageView setGoViewController:^(UIViewController *viewController) {
        [weakSelf pushViewControlle:viewController backIsHiddenTabbar:NO];
    }];
    
    self.homePageView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getGoods];
        [self getAdvertising];
    }];
}

#pragma mark - NavigationItemView
// 设置Nav
- (void)setNav {
    
    if (_currentPointView == nil) {
        
        _currentPointView = [[CurrentPointView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
        [_currentPointView addTarget:self action:@selector(goPoint) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _currentPointView;
        self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"地址放大")
                                                                WithTarget:self
                                                                    action:@selector(goSearch)];
    }
    else {
        [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
    }
}

// 前往搜索
- (void)goSearch {
    [self pushViewControlle:[NSClassFromString(@"SearchViewController") new]
         backIsHiddenTabbar:NO];
}

// 前往提货点
- (void)goPoint {
    
    SelectSiteViewController *selectSiteVc = [[SelectSiteViewController alloc] init];
    [self pushViewControlle:selectSiteVc
         backIsHiddenTabbar:NO];
}

#pragma mark - 购物车
// 初始化购物车视图
- (void)initCartView {
    
    [self.cartView removeFromSuperview];
    self.cartView = [GoodsCartView new];
    self.cartView.tag = 1;
    [self.homePageView addSubview:self.cartView];
    [self getCartNum];
    
    self.cartView.sd_layout
    .rightSpaceToView(self.homePageView, 15)
    .bottomSpaceToView(self.homePageView, 55)
    .heightIs(45)
    .widthIs(45);
    
    WS(weakSelf);
    self.cartView.goViewController = ^(UIViewController *viewController) {
        
        if (isBlankString(GetUserId)) {
            viewController = [NSClassFromString(@"LoginViewController") new];
        }
        
        [weakSelf pushViewControlle:viewController backIsHiddenTabbar:NO];
    };
}

// 前往购物车
- (void)goCart {
    
    NSString *viewControllerString;
    if (isBlankString(kGetUserId)) {
        viewControllerString = @"ShopLoginViewController";
    }
    else viewControllerString = @"GoodsCartViewController";
    [self pushViewControlle:[NSClassFromString(viewControllerString) new]
         backIsHiddenTabbar:NO];
}

#pragma mark - 数据请求
// 获取购物车数量
- (void)getCartNum {
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM, UUID, kGetUserId, kGetMID];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        self.cartView.numberString = [data[@"sum"] stringValue];
        
    } failure:nil];
}

// 获取商品
- (void)getGoods {
    
    NSString *urlString = [NSString stringWithFormat:HomePageGoodsList,kGetMID, kGetUserId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        [self.goodsArray removeAllObjects];
        
        for (NSDictionary *dict in data[@"ClassList"]) {
            
            GoodsModel *model = [[GoodsModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.imgUrl]
                                                            options:SDWebImageRetryFailed
                                                           progress:nil
                                                          completed:^(UIImage *image,
                                                                      NSError *error,
                                                                      SDImageCacheType cacheType,
                                                                      BOOL finished,
                                                                      NSURL *imageURL)
            {
                model.img = image;
            }];
            
            [self.goodsArray addObject:model];
        }
        
        [self.homePageView setGoodsArray:self.goodsArray];
        [self.homePageView.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.homePageView.tableView.mj_header endRefreshing];
    }];
}

// 获取广告
- (void)getAdvertising {
    
    NSString *urlString = [NSString stringWithFormat:HOMEPAGEURL,kGetMID];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        [Single sharedInstance].isUpdateGoods = YES;
        
        AdvertisingModel *advertisingModel = [[AdvertisingModel alloc] init];
        [advertisingModel setValuesForKeysWithDictionary:data];
        
        // Banner广告
        NSMutableArray *bannerArray = [NSMutableArray array];
        for (NSDictionary *dict in advertisingModel.AdXList) {
            
            AdvertisingModel *model = [[AdvertisingModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [bannerArray addObject:model];
        }
        
        // 商品广告
        NSMutableArray *goodsAdvertisingArray = [NSMutableArray array];
        for (NSDictionary *dict in advertisingModel.AdSList) {
            
            AdvertisingModel *model = [[AdvertisingModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [goodsAdvertisingArray addObject:model];
        }
        
        // 热门广告
        NSMutableArray *advertisingArray = [NSMutableArray array];
        for (NSDictionary *dict in advertisingModel.AdRList) {
            
            AdvertisingModel *model = [[AdvertisingModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            SDWebImageManager *manage = [SDWebImageManager sharedManager];
            [manage downloadImageWithURL:[NSURL URLWithString:model.ImgUrl]
                                 options:SDWebImageRetryFailed
                                progress:nil
                               completed:^(UIImage *image,
                                           NSError *error,
                                           SDImageCacheType cacheType,
                                           BOOL finished, NSURL *imageURL)
             {
                 model.img = image;
             }];
            
            [advertisingArray addObject:model];
        }
        
        // 商品Top
        NSMutableArray *topArray = [NSMutableArray array];
        for (NSDictionary *dict in advertisingModel.AdSTList) {
            
            AdvertisingModel *model = [[AdvertisingModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            SDWebImageManager *manage = [SDWebImageManager sharedManager];
            [manage downloadImageWithURL:[NSURL URLWithString:model.ImgUrl]
                                 options:SDWebImageRetryFailed
                                progress:nil
                               completed:^(UIImage *image,
                                           NSError *error,
                                           SDImageCacheType cacheType,
                                           BOOL finished, NSURL *imageURL)
             {
                 model.img = image;
             }];
            
            [topArray addObject:model];
        }
        
        self.homePageView.hidden = NO;
        self.homePageView.topArray = topArray;
        self.homePageView.bannerArray = bannerArray;
        self.homePageView.advertisingArray = advertisingArray;
        self.homePageView.goodsAdvertisingArray = goodsAdvertisingArray;
        
    } failure:nil];
}

// 获取提货点
- (void)getPoint:(CLLocationCoordinate2D)coor {

    NSString *urlString = [NSString stringWithFormat:MAPURL, coor.latitude, coor.longitude];
    [self requestJsonWithUrlString:urlString isLoading:NO success:^(id data) {
        
        Map *model = [[Map alloc] init];
        [model setValuesForKeysWithDictionary:data[@"list"][0]];
        [[Single sharedInstance] setPointModel:model];
        
        [self setNav];
        [self getGoods];
        [self getAdvertising];
        
    } failure:nil];
}

#pragma mark - 定位
- (void)startLocation {
    
    self.locService = [[BMKLocationService alloc] init];
    self.locService.delegate = self;
    [self.locService startUserLocationService];
}

// 获取定位坐标
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
    [userDefaults setDouble:userLocation.location.coordinate.latitude forKey:@"positioningLatitude"];
    [userDefaults setDouble:userLocation.location.coordinate.longitude forKey:@"positioningLongitude"];
    
    [self getPoint:coor];
    [self.locService stopUserLocationService];
}

@end
