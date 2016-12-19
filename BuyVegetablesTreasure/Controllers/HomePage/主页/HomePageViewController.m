//
//  HomePageViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HomePageViewController.h"
#import "SelectSiteViewController.h"
#import "ShopLoginViewController.h"
#import "GoodsCartViewController.h"
#import "SearchViewController.h"
#import "SelectCityViewController.h"
#import "GoodsDetailViewController.h"
#import "RockViewController.h"
#import "New&HotViewController.h"
#import "AdWebViewController.h"
#import "ClassificationViewController.h"
#import "SearchListCell.h"
#import "HomePageModel.h"
#import "MenuListModel.h"
#import "SearchModel.h"
#import "RightGoodsModel.h"
#import "GroupViewController.h"
#import "CurrentPointView.h"
#import "CookingProgramViewController.h"
#import "AmountViewController.h"

@interface HomePageViewController () {
    
    UILabel *emblem;
    UIButton *navBtn;
    UIImageView *imageView;
    UIImageView *cartAnimView;
    
    BMKGeoCodeSearch *geoCodeSearch;
    BMKLocationService *locService;
    CurrentPointView *_currentPointView;
    
    NSInteger sum;
    NSInteger _num;
    NSString *uidString;
    NSString *midString;
    NSString *storeIdString;
    NSString *currentCityString;
}
@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([Single sharedInstance].isLoadAdvertising) {
        [self requestHomePageData];
    }
    
    [self getUserId];
    [self requestGoodsData];
//    [self initAlertControllerWithText:@"请选择提货点" isGoods:NO];
    [self setNav];
    [self initShoppingCartIconView];
    [self getShoppingCartNum];
    [Single sharedInstance].isRefreshTitle = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self startLocation];
    [self getUserId];
    [self initCollection];
    [self setNav];
    [self initArray];
    [self initShoppingCartIconView];
    
    CLLocationCoordinate2D coor;
    [self getPoint:coor];
}

- (void)getUserId {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    midString = [Tools isBlankString:[defaults objectForKey:@"MID"]] ? @"5" : [defaults objectForKey:@"MID"];
    uidString = [Tools isBlankString:[defaults objectForKey:@"UID"]] ? @"0" : [defaults objectForKey:@"UID"];
    storeIdString = [defaults objectForKey:@"merchantsID"];
}

#pragma mark - 初始化
#pragma mark 初始化数组
- (void)initArray {
    
    _imageArray = [NSMutableArray array];
    _goodsArray = [NSMutableArray array];
    _adRlistArray = [NSMutableArray array];
    _adSListArray = [NSMutableArray array];
    _adxListArray = [NSMutableArray array];
    _adSTListArray = [NSMutableArray array];
}

#pragma mark 初始化Collection
- (void)initCollection {

    _popularityView = [[PopularityView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _popularityView.popularityCollectionView.delegate = self;
    _popularityView.popularityCollectionView.dataSource = self;
    
    [_popularityView.popularityCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_popularityView.popularityCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AdCell"];
    [_popularityView.popularityCollectionView registerNib:[UINib nibWithNibName:@"SearchListCell" bundle:nil] forCellWithReuseIdentifier:@"SearchListCell"];
    [_popularityView.popularityCollectionView registerClass:[adx_HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"adx_HeadView"];
    [_popularityView.popularityCollectionView registerClass:[adTop_HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"adTop_HeadView"];
    [_popularityView.popularityCollectionView registerNib:[UINib nibWithNibName:@"PopularityFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PopularityFooterView"];
    [self.view addSubview:_popularityView];
    
    _popularityView.popularityCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShoppingCartNum];
        [self requestGoodsData];
        [self requestHomePageData];
    }];
}

#pragma mark 设置Nav
- (void)setNav {
    
    if (_currentPointView == nil) {
        
        _currentPointView = [[CurrentPointView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
        [_currentPointView addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _currentPointView;
        self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"地址放大") WithTarget:self action:@selector(searchClicked:)];
    }
    else {
        [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
    }
}

#pragma mark 初始化购物车图标
- (void)initShoppingCartIconView {
    
    [(UIButton *)[self.view viewWithTag:100001] removeFromSuperview];
    
    UIButton *shoppingCartIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartIconButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 75 - 64 - 25, 45, 45);
    [shoppingCartIconButton setImage:IMAGE(@"购物车背景") forState:UIControlStateNormal];
    shoppingCartIconButton.tag = 100001;
    //    [shoppingCartIconButton addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [shoppingCartIconButton addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:shoppingCartIconButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShoppingCart)];
    [shoppingCartIconButton addGestureRecognizer:tap];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(shoppingCartIconButton.frame.size.width / 2 - 7.5, 5, 15, 10)];
    [bgView setImage:IMAGE(@"数字圈")];
    [shoppingCartIconButton addSubview:bgView];
    
    emblem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    emblem.font = [UIFont systemFontOfSize:8];
    emblem.textColor = [UIColor blackColor];
    emblem.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:emblem];
    
    if (isPad) {
        
        CGRect frame = shoppingCartIconButton.frame;
        frame.origin.x = SCREEN_WIDTH - 75;
        frame.size.height = 55;
        frame.size.width = 55;
        shoppingCartIconButton.frame = frame;
        
        frame = bgView.frame;
        frame.origin.x = shoppingCartIconButton.frame.size.width/2-7.5;
        bgView.frame = frame;
        
        emblem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
        emblem.font = [UIFont systemFontOfSize:9];
        emblem.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:emblem];
    }
    
    [self getShoppingCartNum];
}

#pragma mark - 事件处理
#pragma mark 移动button
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
//    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;

    CGRect frame = button.frame;
    if (frame.origin.y < 60) frame.origin.y = 60;
    else if (frame.origin.y > ScreenHeight - 49 - 64 - 45) frame.origin.y = ScreenHeight - 64 - 49 - 45 - 20;
    
    button.frame = frame;
    button.center = CGPointMake(button.center.x, button.center.y + delta_y);
}

#pragma mark 点击宣传广告
- (void)adxHeadViewClick:(NSInteger)index {
    
    if (index >= 70) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        if (index == 71) {
            
            UIViewController *viewController = [Tools isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]] ? [ShopLoginViewController new] : [AmountViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (index == 70) {
            
            [self.navigationController pushViewController:[GroupViewController new] animated:YES];
        }
        else {
            
            New_HotViewController *newView = [[New_HotViewController alloc] init];
            newView.latest = index == 72 ? @"1" : @"0";
            newView.Navtitle = index == 72 ? @"新品" : @"促  销";
            newView.specialOffer = index == 72 ? @"0" : @"1";
            newView.isNewGoods = index == 72 ? YES : NO;
            [self.navigationController pushViewController:newView animated:YES];
        }
        
        [self setHidesBottomBarWhenPushed:NO];
    }
}

#pragma mark 点击商品广告
- (void)touchGoodsImage:(UIButton *)btn {
    [self touchAdvertising:_adSListArray[btn.tag - 666]];
}

- (void)touchAdvertising:(HomePageModel *)model {
    
    UIViewController *viewController;
    
    if ([model.ObjectType integerValue] == 1) {
        
        GoodsDetailViewController *goodsDetailVc = [[GoodsDetailViewController alloc] init];
        NSString *productIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
        goodsDetailVc.ProductId = [productIdString integerValue];
        viewController = goodsDetailVc;
        
        if ([model.ObjectId integerValue] == 0) return;
    }
    else if ([model.ObjectType integerValue] == 2) {
        
        ClassificationViewController *categoriesView = [[ClassificationViewController alloc] init];
        NSString *categoryIdString = [model.ObjectId stringByReplacingOccurrencesOfString:@"," withString:@""];
        categoriesView.categoryId = [categoryIdString integerValue];
        categoriesView.isSingleGoods = YES;
        viewController = categoriesView;
    }
    else {
        
        AdWebViewController *ad = [[AdWebViewController alloc] init];
        ad.name = model.Name;
        ad.url = model.Url;
        viewController = ad;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 点击表尾
- (void)footerClick {

    self.tabBarController.selectedIndex = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"1"];
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 导航按钮事件
- (void)btnClick {
    
    self.hidesBottomBarWhenPushed = YES;
    SelectSiteViewController *selectSiteVc = [[SelectSiteViewController alloc] init];
    selectSiteVc.goodsCountString = emblem.text;
    [self.navigationController pushViewController:selectSiteVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 选择城市的提示
- (void)initAlertControllerWithText:(NSString *)textString isGoods:(BOOL)isGoods {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([Tools isBlankString:[defaults objectForKey:@"merchantsName"]] || isGoods == YES) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:textString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *positioningAction = [UIAlertAction actionWithTitle:@"确  定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[SelectSiteViewController new] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }];
        
        [alertController addAction:positioningAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100001];
    
    cartAnimView = [[UIImageView alloc] initWithFrame:rect];
    cartAnimView.image = image;
    [self.view addSubview:cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        
        cartAnimView.frame = CGRectMake(btn.frame.origin.x + 27.5, btn.frame.origin.y + 27.5, 0, 0);
        
    } completion:^(BOOL finished) {
        [cartAnimView removeFromSuperview];
    }];
}

#pragma mark 跳转购物车
- (void)goShoppingCart {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([Tools isBlankString:[userDefaults objectForKey:@"UID"]]) {
        [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
    }
    else {
        [self.navigationController pushViewController:[GoodsCartViewController new] animated:YES];
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark 跳转搜索
- (void)searchClicked:(UIButton *)btn {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 数据请求
#pragma mark 获取购物车数量
- (void)getShoppingCartNum {
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM, UUID, uidString, midString];
    NSLog(@"购物车 = %@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         sum = [data[@"sum"] integerValue];
         emblem.text = [NSString stringWithFormat:@"%zd",sum];
         
     } failure:nil];
}

#pragma mark 请求商品
- (void)requestGoodsData {

    NSString *urlString = [NSString stringWithFormat:HomePageGoodsList,midString,uidString];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
     {
         [_goodsArray removeAllObjects];
         
         NSArray *arr = data[@"ClassList"];
         for (NSDictionary *dict in arr) {
             
             RightGoodsModel *rmodel = [[RightGoodsModel alloc] init];
             [rmodel setValuesForKeysWithDictionary:dict];
             [_goodsArray addObject:rmodel];
         }
         
         [_popularityView.popularityCollectionView reloadData];
         
     } failure:nil];
    
    
    urlString = [NSString stringWithFormat:CLASSIFYURL,midString,uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
     {
         NSArray *arr = data[@"ClassList"];
         for (NSDictionary *dict in arr) {

             NSArray *array = dict[@"List"];
             NSMutableArray *goodsArray = [NSMutableArray array];
             for (NSDictionary *goodsList in array) {
                 
                 RightGoodsModel *rmodel = [[RightGoodsModel alloc] init];
                 [rmodel setValuesForKeysWithDictionary:goodsList];
                 [goodsArray addObject:rmodel];
             }
             
              if (goodsArray.count == 0) {
                  
                  [self initAlertControllerWithText:@"该提货点没有商品，请选择其他自提点" isGoods:YES];
              }
         }
         
     } failure:nil];
}

#pragma mark - 请求首页数据
- (void)requestHomePageData {
    
    NSString *urlString = [NSString stringWithFormat:HOMEPAGEURL,midString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         [_imageArray removeAllObjects];
         [_adxListArray removeAllObjects];
         [_adRlistArray removeAllObjects];
         [_adSListArray removeAllObjects];
         [_adSTListArray removeAllObjects];
         
         // 宣传广告
         for (NSDictionary *dict in data[@"AdXList"]) {
             
             HomePageModel *model = [[HomePageModel alloc] init];
             [model setValuesForKeysWithDictionary:dict];
             [_imageArray addObject:model.ImgUrl];
             [_adxListArray addObject:model];
         }
         
         // 热门广告
         for (NSDictionary *dict in data[@"AdRList"]) {
             
             HomePageModel *model = [[HomePageModel alloc] init];
             [model setValuesForKeysWithDictionary:dict];
             [_adRlistArray addObject:model];
         }
         
         // 商品广告
         for (NSDictionary *dict in data[@"AdSList"]) {
             
             HomePageModel *model = [[HomePageModel alloc] init];
             [model setValuesForKeysWithDictionary:dict];
             [_adSListArray addObject:model];
         }
         
         // 商品Top
         for (NSDictionary *dict in data[@"AdSTList"]) {
             
             HomePageModel *model = [[HomePageModel alloc] init];
             [model setValuesForKeysWithDictionary:dict];
             [_adSTListArray addObject:model];
         }
         
         [Single sharedInstance].isLoadAdvertising = NO;
         [_popularityView.popularityCollectionView reloadData];
         
     } failure:^(NSError *error) {
         [Tools myHud:@"加载失败！请重新加载" inView:[[UIApplication sharedApplication].delegate window]];
     }];
    
    [_popularityView.popularityCollectionView.mj_header endRefreshing];
}

#pragma mark 商品增加请求
- (void)addGoodsRequestWithGoodsId:(NSString *)productId
                        ProductNum:(NSString *)productNum
                          TotPrice:(NSInteger )totPrice
                             IsAdd:(BOOL)isAdd
                              type:(BOOL)type
                ForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *totPriceString = [NSString stringWithFormat:@"%zd",totPrice];
    NSString *urlString;

    if ([Tools isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]]) {
        return [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
    }
    else if ( isAdd == YES ) {
        
        NSString *t = type == NO ? @"0" : @"1";
        urlString = [NSString stringWithFormat:UpCart,UUID,midString,productId,uidString,productNum,t];
    }
    else {
        
        switch ([productNum integerValue]) {
                
            case 0:
                NSLog(@"删除");
                urlString = [NSString stringWithFormat:DelCartUrl,UUID,midString,productId,uidString];
                break;
                
            case 1:
                NSLog(@"添加到购物车");
                urlString = [NSString stringWithFormat:ADDCARTURL,productId,UUID,uidString,totPriceString,productNum,midString,storeIdString];
                break;
                
            default:
                NSLog(@"更新商品");
                NSString *t = (type == NO ? @"0" : @"1");
                urlString = [NSString stringWithFormat:UpCart,UUID,midString,productId,uidString,productNum,t];
                break;
        }
    }
    
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ( [[NSString stringWithFormat:@"%@",[data objectForKey:@"issuccess"]] isEqualToString:@"0"]) {
             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         else if ( [[NSString stringWithFormat:@"%@",[data objectForKey:@"issuccess"]] isEqualToString:@"1"]) {
             
             SearchModel *model = _goodsArray[indexPath.row];
             model.CartNum = [NSString stringWithFormat:@"%zd",[model.CartNum integerValue] + _num];
             [_goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
             
             SearchListCell *cell = (SearchListCell *)[_popularityView.popularityCollectionView cellForItemAtIndexPath:indexPath];
             cell.goddsNumLabel.text = model.CartNum;
             
             emblem.text = [NSString stringWithFormat:@"%zd",[emblem.text integerValue] + _num];
        }
         
     } failure:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) return _adSListArray.count > 0 ? 1 : 0;
    return section == 0 ? _adRlistArray.count : _goodsArray.count;
}

#pragma mark 创建Item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        if (_adRlistArray.count > indexPath.row) {
            
            HomePageModel *model = _adRlistArray[indexPath.row];
            UIImageView *ImageView = (UIImageView *)[self.view viewWithTag:indexPath.row + 1000];
            [ImageView removeFromSuperview];
            
            UIImageView *adRImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            adRImageView.tag = indexPath.row + 1000;
            [adRImageView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl] placeholderImage:[UIImage imageNamed:@"ErrorBackImage"]];
            adRImageView.userInteractionEnabled = YES;
            [cell addSubview:adRImageView];
        }

        return cell;
    }
    else if (indexPath.section == 1) {
    
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdCell" forIndexPath:indexPath];
        
        [(UIScrollView *)[self.view viewWithTag:998] removeFromSuperview];
        
        UIScrollView *adSSrcollView = [[UIScrollView alloc] initWithFrame:cell.bounds];
        adSSrcollView.tag = 998;
        adSSrcollView.contentSize = CGSizeMake((ScreenWidth - 15) / 3 * _adSListArray.count + 10, 0);
        adSSrcollView.showsHorizontalScrollIndicator = NO;
        
        [cell addSubview:adSSrcollView];
        
        for (int i = 0; i < _adSListArray.count; i++) {
            
            HomePageModel *model = _adSListArray[i];
            UIButton *adSButton = [UIButton buttonWithType:UIButtonTypeCustom];
            adSButton.tag = i + 666;
            adSButton.frame = CGRectMake((5 + (ScreenWidth - 15) / 3) * i, 0, (ScreenWidth - 40) / 3, ScreenWidth / 2);
            [adSButton addTarget:self action:@selector(touchGoodsImage:) forControlEvents:UIControlEventTouchUpInside];
            [adSSrcollView addSubview:adSButton];
            
            UIImage *img = IMAGE(@"列表页未成功图片");
            img = [img reSize:adSButton.size];
            
            UIImageView *adSImageView = [[UIImageView alloc] initWithFrame:adSButton.bounds];
            adSImageView.tag = i + 777;
            adSImageView.contentMode = UIViewContentModeScaleAspectFill;
            adSImageView.clipsToBounds = YES;
            [adSImageView sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]
                            placeholderImage:img];
            [adSButton addSubview:adSImageView];
        }
        
        return cell;
    }
    else {
        
        SearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchListCell" forIndexPath:indexPath];
        
        [cell setModel:_goodsArray[indexPath.row]];
        
        cell.imageClick = ^(NSInteger pruductId) {
            
            SearchModel *model = _goodsArray[indexPath.row];
            
            self.hidesBottomBarWhenPushed = YES;
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            goods.ProductId = [model.id integerValue];
            [self.navigationController pushViewController:goods animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        };
        
        __weak typeof(cell)weakCell = cell;
        cell.goodsNumBlock = ^(NSString *goodsNum,NSString *goodsID,BOOL isAdd,BOOL isEnough) {
            
            if ([goodsNum integerValue] < 0) {
                goodsNum = 0;
                return ;
            }
            
            if (isAdd == NO && isEnough == YES) {
                CGRect rect = [weakCell.goodsImage convertRect:weakCell.goodsImage.bounds toView:self.view];
                [self initImage:rect withImage:weakCell.goodsImage.image];
            }
            
            if ([Tools isBlankString:uidString]) {
                
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                return ;
            }
            else {
                
                NSLog(@"goodsNum ========= %@",goodsNum);
                
                BOOL a = YES;
                int num = 0;
                
                if (!isEnough) return [Tools myHud:@"库存不足！" inView:self.view];
                num = isAdd ? num - 1 :num + 1;
                
                if ([goodsNum integerValue] == 2 || isAdd == NO) a = NO;
                else if ([goodsNum integerValue] == 0) a = NO;
                
                _num = num;
                
                SearchModel *model = _goodsArray[indexPath.row];
                
                [self addGoodsRequestWithGoodsId:goodsID ProductNum:goodsNum TotPrice:[emblem.text integerValue] * [model.salePrice integerValue] IsAdd:a type:isAdd ForItemAtIndexPath:indexPath];
            }
        };
        
        return cell;
    }
}

#pragma mark 点击Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self touchAdvertising:_adRlistArray[indexPath.item]];
    }
}

#pragma mark 返回Item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return CGSizeMake(ScreenWidth - 20 ,ScreenWidth - ScreenWidth / 5 * 3);
    if (indexPath.section == 1) return CGSizeMake(ScreenWidth - 20 ,ScreenWidth / 2);
    return CGSizeMake(ScreenWidth / 2 - 15, ScreenWidth / 2 - 15 + 80);
}

#pragma mark 返回表头表尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        if (indexPath.section == 0) {
            
            _adx_HeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"adx_HeadView" forIndexPath:indexPath];
            [_adx_HeadView.bannerScrollView setImageURLStringsGroup:_imageArray];
            
            if (_adxListArray.count == 0) {
                _adx_HeadView.bannerScrollView.hidden = YES;
            }
            else {
                _adx_HeadView.bannerScrollView.hidden = NO;
            }
            
            __weak typeof(self)weakSelf = self;
            __weak typeof(_adxListArray)weakAdxListArray = _adxListArray;
            _adx_HeadView.picBlock = ^(NSInteger index) {
                
                if (index >= 70) [weakSelf adxHeadViewClick:index];
                else [weakSelf touchAdvertising:weakAdxListArray[index]];
            };
            
            return _adx_HeadView;
        }
        else {
            
            _adTop_HeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"adTop_HeadView" forIndexPath:indexPath];
            
            WS(weakSelf);
            [_adTop_HeadView setTopModel:^(HomePageModel *model) {
                
                [weakSelf touchAdvertising:model];
            }];
            
            if (_adSTListArray.count > 0) {
                
                [_adTop_HeadView setTopImageWithArray:_adSTListArray];
            }
            
            return _adTop_HeadView;
        }
    }
    else {
        
        _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PopularityFooterView" forIndexPath:indexPath];
        _footerView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footerClick)];
        [_footerView addGestureRecognizer:tap];
        
        return _footerView;
    }
}

#pragma mark 返回表尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (_adxListArray.count > 0) {
            return CGSizeMake(0, ScreenWidth / 2 + 90);
        }
        else {
            return CGSizeMake(0, 90);
        }
    }
    else if (section == 1) {

        return CGSizeMake(0, - 10);
    }
    else if (section == 2) {
        
        if (_adSTListArray.count > 0) {
            
            return CGSizeMake(0, 50 + (ScreenWidth - ScreenWidth / 5 * 3 + 10));
        }
        else {
            
            return CGSizeMake(0, 50);
        }
    }

    return CGSizeMake(0, 0);
}

#pragma mark 返回表头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 2) return CGSizeMake(0, 40);
    return CGSizeMake(0, 0);
}


#pragma mark - 百度地图
#pragma mark 开始定位
- (void)startLocation {
    
    locService = [[BMKLocationService alloc] init];
    locService.delegate = self;
    [locService startUserLocationService];
}

#pragma mark 获取定位坐标
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    
    [userDefaults setDouble:userLocation.location.coordinate.latitude forKey:@"positioningLatitude"];
    [userDefaults setDouble:userLocation.location.coordinate.longitude forKey:@"positioningLongitude"];

    [self getPoint:coor];
    [locService stopUserLocationService];
}

#pragma mark - 获取提货点
- (void)getPoint:(CLLocationCoordinate2D)coor {

    NSString *urlString = [NSString stringWithFormat:MAPURL,coor.latitude,coor.longitude];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString
                                param:nil
                         requestStyle:Get
                        setSerializer:Json
                        isShowLoading:YES success:^(id data)
     {
         Map *model = [[Map alloc] init];
         [model setValuesForKeysWithDictionary:data[@"list"][0]];
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:model.Fendianname forKey:@"merchantsName"];
         [defaults setObject:model.Fendianname forKey:@"Fendianname"];
         [defaults setObject:model.id forKey:@"merchantsID"];
         [defaults setObject:model.mid forKey:@"MID"];
         [defaults setObject:model.addr forKey:@"merchantsAddress"];
         [defaults setObject:model.picktime forKey:@"merchantsTime"];
         [defaults setObject:model.pickJuli forKey:@"distance"];
         [defaults setObject:model.Distance forKey:@"Distance"];
         [defaults setObject:model.DistancePrice forKey:@"DistancePrice"];
         [defaults setBool:[model.IsDistribution boolValue] forKey:@"IsDistribution"];
         [defaults setObject:model.xPoint forKey:@"xPoint"];
         [defaults setObject:model.yPoint forKey:@"yPoint"];
         [defaults setObject:model.fullPrice forKey:@"fullPrice"];
         
         NSLog(@"%@",model.Distance);
         
         [self getUserId];
         [self setNav];
         [self requestHomePageData];
         [self requestGoodsData];
         [self getShoppingCartNum];
         
     } failure:nil];
}

#pragma mark 逆地理编码类
- (void)initBMKReverseGeoCodeOptionWith:(CLLocationCoordinate2D)coor {
    
    // 初始化检索对象
    geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    geoCodeSearch.delegate = self;
    geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    geoCodeSearch.delegate = self;
    
    // 初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = coor;
    [geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 接收反向地理编码结果
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                            result:(BMKReverseGeoCodeResult *)result
                         errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:result.address forKey:@"CurrentSite"];
        
        NSArray *cityArray = [result.address componentsSeparatedByString:@"省"];
        
        if (cityArray.count > 1) {
            
            NSArray *cityArray2 = [cityArray[1] componentsSeparatedByString:@"市"];
            
            currentCityString = [NSString stringWithFormat:@"%@市",cityArray2[0]];
            [userDefaults setObject:currentCityString forKey:@"CurrentCity"];
        }
        else return;
    }
    else {
        
        NSLog(@"抱歉，未找到结果");
    }
}




@end
