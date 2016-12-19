//
//  HomePageView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/12/8.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

// Controller
#import "GoodsDetailViewController.h"
#import "ClassificationViewController.h"
#import "New&HotViewController.h"
#import "AdWebViewController.h"
// View
#import "HomePageView.h"
#import "BannerView.h"
#import "HomePageFootView.h"
// Cell
#import "GoodsAdvertisingCell.h"
#import "GoodsTopCell.h"
#import "HomePageGoodsCell.h"
#import "AdvertisingCell.h"

@interface HomePageView ()

/// 段头高度
@property (nonatomic, assign) CGFloat headHeight;
/// Banner高度
@property (nonatomic, assign) CGFloat bannerHeight;
/// Banner
@property (nonatomic, strong) BannerView *bannerView;
/// 是否刷新数据
@property (nonatomic, assign) BOOL isReloadData;

@end

@implementation HomePageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.headHeight = 45;
        self.bannerHeight = 90;
        self.isReloadData = YES;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];

        NSArray *cells = @[@"HomePageGoodsCell",
                           @"AdvertisingCell",
                           @"GoodsTopCell",
                           @"GoodsAdvertisingCell"];
        
        for (int i = 0; i < cells.count; i++) {
            
            [self.tableView registerClass:[NSClassFromString(cells[i]) class]
                   forCellReuseIdentifier:cells[i]];
        }
        
        // 底部按钮
        [self initFootView];
    }
    
    return self;
}

// 点击广告
- (void)clickAdvertising:(AdvertisingModel *)model {
    
    UIViewController *viewController;
    NSString *idString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];

    if ([model.ObjectType intValue] == 1) {
        
        GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] init];
        goodsDetailVC.ProductId = [idString integerValue];
        viewController = goodsDetailVC;
        
        if ([model.ObjectId integerValue] == 0) return;
    }
    else if ([model.ObjectType integerValue] == 2) {
        
        ClassificationViewController *categoriesVC = [[ClassificationViewController alloc] init];
        categoriesVC.categoryId = [idString integerValue];
        categoriesVC.isSingleGoods = YES;
        viewController = categoriesVC;
    }
    else {
        
        AdWebViewController *adWebVC = [[AdWebViewController alloc] init];
        adWebVC.name = model.Name;
        adWebVC.url = model.Url;
        viewController = adWebVC;
    }
    
    self.goViewController(viewController);
}

// 横批
- (void)initBannerView {
    
    if (self.bannerView == nil) {
        self.bannerView = [BannerView new];
    }
    
    WS(weakSelf);
    [self.bannerView setIconBtnClick:^(NSInteger index) {
        
        UIViewController *viewController;
        
        // 拼团
        if (index == 0) {
            viewController = [NSClassFromString(@"GroupViewController") new];
        }
        // 充值
        else if (index == 1) {
            
            if ([Tools isBlankString:kGetUserId]) {
                viewController = [NSClassFromString(@"ShopLoginViewController") new];
            }
            else {
                viewController = [NSClassFromString(@"AmountViewController") new];
            }
        }
        // 促销、新品
        else {
        
            New_HotViewController *newView = [[New_HotViewController alloc] init];
            newView.latest = index == 2 ? @"1" : @"0";
            newView.Navtitle = index == 2 ? @"新品" : @"促  销";
            newView.specialOffer = index == 2 ? @"0" : @"1";
            newView.isNewGoods = index == 2 ? YES : NO;
            viewController = newView;
        }
        
        weakSelf.goViewController(viewController);
    }];
    
    [self.bannerView setBannerClick:^(AdvertisingModel *model) {
        [weakSelf clickAdvertising:model];
    }];
    
    self.bannerView.frame = CGRectMake(0, 0, ScreenWidth, self.bannerHeight);
    self.bannerView.bannerArray = self.bannerArray;
    self.tableView.tableHeaderView = self.bannerView;
    [self.tableView reloadData];
}

// 底部按钮
- (void)initFootView {
    
    HomePageFootView *footView = [HomePageFootView new];
    footView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [footView setLookAllGoods:^{
        self.lookAllGoods();
    }];
    self.tableView.tableFooterView = footView;
    [self.tableView reloadData];
}

// 商品
- (void)setGoodsArray:(NSArray *)goodsArray {
    
    _goodsArray = goodsArray;
    [self.tableView reloadData];
}

// 广告
- (void)setAdvertisingArray:(NSArray *)advertisingArray {
    
    _advertisingArray = advertisingArray;
    [self.tableView reloadData];
}

// 商品广告
- (void)setGoodsAdvertisingArray:(NSArray *)goodsAdvertisingArray {
    
    _goodsAdvertisingArray = goodsAdvertisingArray;
    [self.tableView reloadData];
}

// 横批
- (void)setBannerArray:(NSArray *)bannerArray {
    
    if (bannerArray.count > 0) {
        self.bannerHeight = ScreenWidth / 2 + 90;
    }
    else {
        self.bannerHeight = 90;
    }
    
    _bannerArray = bannerArray;
    [self initBannerView];
}

// Top广告
- (void)setTopArray:(NSArray *)topArray {
    
    _topArray = topArray;
    
    if (topArray.count > 0) {
        self.headHeight = 45 + (ScreenWidth - (HomePageSpacing * 2)) / 2;
    }
    else {
        self.headHeight = 45;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // 广告
    if (section == 0) {
        return self.advertisingArray.count;
    }
    // 商品
    else if (section == 3) {
        return self.goodsArray.count / 2 + self.goodsArray.count % 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 广告
    if (indexPath.section == 0) {
        
        AdvertisingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvertisingCell"];
        
        if (cell.model == nil) {
            cell.model = self.advertisingArray[indexPath.row];
        }
        
        return cell;
    }
    // 商品广告
    else if (indexPath.section == 1) {
     
        GoodsAdvertisingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsAdvertisingCell"];
        
        if ([Single sharedInstance].isUpdateGoods && cell.dataSource == nil) {
            [cell setDataSource:self.goodsAdvertisingArray];
        }
        
        [cell setImgClick:^(AdvertisingModel *model) {
            [self clickAdvertising:model];
        }];
        return cell;
    }
    // Top广告
    else if (indexPath.section == 2) {
        
        GoodsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsTopCell"];

        if (self.topArray.count > 0 && cell.model == nil) {
            cell.model = self.topArray[0];
        }
        
        [cell setImgClick:^(AdvertisingModel *model) {
            [self clickAdvertising:model];
        }];
        return cell;
    }
    // 商品
    else if (indexPath.section == 3) {
        
        NSInteger currentIndex = indexPath.row * 2;
        
        HomePageGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageGoodsCell"];
        
        if (cell.goodsArray == nil) {
            
            if (indexPath.row * 2 + 1 >= self.goodsArray.count) {
                cell.goodsArray = @[self.goodsArray[currentIndex]];
            }
            else {
                cell.goodsArray = @[self.goodsArray[currentIndex], self.goodsArray[currentIndex + 1]];
            }
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 广告
    if (indexPath.section == 0) {
        return (ScreenWidth - HomePageSpacing * 2) / 5 * 2 + HomePageSpacing;
    }
    // 商品广告
    else if (indexPath.section == 1) {
        
        if (self.goodsAdvertisingArray.count > 0) {
            return (ScreenWidth - HomePageSpacing * 4) / 2;
        }
        
        return 0;
    }
    // Top广告
    else if (indexPath.section == 2) {
        return self.headHeight;
    }
    // 商品
    else if (indexPath.section == 3) {
        return (ScreenWidth - HomePageSpacing * 3) / 2 + 75 + HomePageSpacing;
    }
    
    return 0;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        return 0.01;
    }
    else if (section == 0 && self.advertisingArray.count == 0) {
        return 0.01;
    }
    else if (section == 1 && self.goodsAdvertisingArray.count == 0) {
        return 0.01;
    }
    
    return HomePageSpacing;
}

// 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self clickAdvertising:self.advertisingArray[indexPath.row]];
    }
}

@end
