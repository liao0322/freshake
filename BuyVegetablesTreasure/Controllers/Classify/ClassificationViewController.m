//
//  ClassificationViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ClassificationViewController.h"
#import "CurrentPointView.h"
#import "SelectSiteViewController.h"
#import "CommodityTypeView.h"
#import "CommodityTableView.h"

@interface ClassificationViewController ()

@property (nonatomic, copy) CurrentPointView *currentPointView;
@property (nonatomic, copy) CommodityTypeView *commodityTypeView;
@property (nonatomic, copy) CommodityTableView *commodityTableView;

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) UILabel *microLabel;
//@property (nonatomic, copy) UIImageView *cartAnimView;
@property (nonatomic, copy) NSMutableArray *commodityArray;

@end

@implementation ClassificationViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self setNav];
    [self getProduct];
    [self initShoppingCartIconView];
    [self getShoppingCartNum];

}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    _commodityArray = [NSMutableArray array];
    
    [self setNav];
    [self initCommodityTypeView];
    [self initCommodityTableView];
    [self initShoppingCartIconView];
}

#pragma mark - 控件初始化
#pragma mark 设置Nav
- (void)setNav {
    
    if (_isSingleGoods) {
        
        self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
        self.navigationItem.title = _categoryName;
    }
    else {
        
        if (_currentPointView == nil) {
            
            _currentPointView = [[CurrentPointView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
            [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
            [_currentPointView addTarget:self action:@selector(goAddressSelect) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.titleView = _currentPointView;
            self.navigationItem.rightBarButtonItem = [UIFactory createImageBBI:IMAGE(@"地址放大") WithTarget:self action:@selector(goSearch)];
        }
        else {
            [_currentPointView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"]];
        }
    }
}

#pragma mark 初始化购物车图标
- (void)initShoppingCartIconView {
    
    [(UIButton *)[self.view viewWithTag:100001] removeFromSuperview];
    
    UIButton *shoppingCartIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartIconButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 75 - 64 - 25, 45, 45);
    [shoppingCartIconButton setImage:IMAGE(@"购物车背景") forState:UIControlStateNormal];
    shoppingCartIconButton.tag = 100001;
    [shoppingCartIconButton addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:shoppingCartIconButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShoppingCart)];
    [shoppingCartIconButton addGestureRecognizer:tap];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(shoppingCartIconButton.frame.size.width / 2 - 7.5, 5, 15, 10)];
    [bgView setImage:IMAGE(@"数字圈")];
    [shoppingCartIconButton addSubview:bgView];
    
    _microLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    _microLabel.font = [UIFont systemFontOfSize:8];
    _microLabel.textColor = [UIColor blackColor];
    _microLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_microLabel];
    
    if (isPad) {
        
        CGRect frame = shoppingCartIconButton.frame;
        frame.origin.x = SCREEN_WIDTH - 75;
        frame.size.height = 55;
        frame.size.width = 55;
        shoppingCartIconButton.frame = frame;
        
        frame = bgView.frame;
        frame.origin.x = shoppingCartIconButton.frame.size.width/2-7.5;
        bgView.frame = frame;
        
        _microLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
        _microLabel.font = [UIFont systemFontOfSize:9];
        _microLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_microLabel];
    }
    
    [self getShoppingCartNum];
}

#pragma mark 初始化商品类型
- (void)initCommodityTypeView {

    int width = isPad ? 200 : 100;
    _commodityTypeView = [[CommodityTypeView alloc] initWithFrame:CGRectMake(0, 0, width, ScreenHeight - 64 - 49 * !_isSingleGoods)];
    _commodityTypeView.backgroundColor = [UIColor colorWithHexString:@"0xFEE2D9"];
    _commodityTypeView.hidden = YES;
    [self.view addSubview:_commodityTypeView];
    
    WS(weakSelf);
    _commodityTypeView.moveTableView = ^(NSInteger index) {
        [weakSelf moveTableViewLocation:index];
    };
}

#pragma mark 商品TableView
- (void)initCommodityTableView {
    
    _commodityTableView = [[CommodityTableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commodityTypeView.frame), 0, ScreenWidth - CGRectGetMaxX(_commodityTypeView.frame), ScreenHeight - 64 - 49* !_isSingleGoods)];
    _commodityTableView.hidden = YES;
    [self.view addSubview:_commodityTableView];
    
    WS(weakSelf);
    _commodityTableView.moveType = ^(NSInteger index) {
        [weakSelf moveCommodityType:index];
    };
    
    _commodityTableView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    _commodityTableView.updateGoods = ^(NSString *urlString, NSIndexPath *indexPath) {
        [weakSelf updateCartCount:urlString indexPath:indexPath];
    };
    
    _commodityTableView.addCartAnimation = ^(CGRect frame, UIImage *image) {
        frame.origin.x += CGRectGetMaxX(_commodityTypeView.frame);
        [weakSelf initImage:frame withImage:image];
    };
    
    _commodityTableView.commodityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_commodityArray removeAllObjects];
        [self getProduct];
        [self getShoppingCartNum];
    }];
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 跳转页面
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    if (!_isSingleGoods) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark 选择提货点
- (void)goAddressSelect {
    
    SelectSiteViewController *selectSiteVc = [[SelectSiteViewController alloc] init];
    selectSiteVc.goodsCountString = _microLabel.text;
    [self goViewController:selectSiteVc];
}

#pragma mark 搜索商品
- (void)goSearch {
    [self goViewController:[NSClassFromString(@"SearchViewController") new]];
}

#pragma mark 前往购物车
- (void)goShoppingCart {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([Tools isBlankString:[userDefaults objectForKey:@"UID"]]) {
        // 前往登录
        [self goViewController:[NSClassFromString(@"ShopLoginViewController") new]];
    }
    else {
        // 前往购物车
        [self goViewController:[NSClassFromString(@"GoodsCartViewController") new]];
    }
}

#pragma mark 移动购物车button
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_y = location.y - previousLocation.y;
    
    CGRect frame = button.frame;
    if (frame.origin.y < 60) frame.origin.y = 60;
    else if (frame.origin.y > ScreenHeight - 49 - 64 - 45) frame.origin.y = ScreenHeight - 64 - 49 - 45 - 20;
    
    button.frame = frame;
    button.center = CGPointMake(button.center.x, button.center.y + delta_y);
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100001];
    
    __block UIImageView *cartAnimView = [[UIImageView alloc] initWithFrame:rect];
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
        
        if (isPad) {
            cartAnimView.frame = CGRectMake(btn.frame.origin.x + 27.5, btn.frame.origin.y + 27.5, 0, 0);
        }
        else {
            cartAnimView.frame = CGRectMake(btn.frame.origin.x + 27.5, btn.frame.origin.y + 27.5, 0, 0);
        }
        
    } completion:^(BOOL finished) {
        [cartAnimView removeFromSuperview];
    }];
}

#pragma mark 移动TableView位置
- (void)moveTableViewLocation:(NSInteger)index {
    [_commodityTableView moveSection:index];
}

#pragma mark 移动商品类型
- (void)moveCommodityType:(NSInteger)index {
    [_commodityTypeView moveType:index];
}

#pragma mark - 数据请求
#pragma mark 请求购物车数量
- (void)getShoppingCartNum {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    uidString = [Tools isBlankString:uidString] ? @"0" : uidString;
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    NSLog(@"=====购物车数量=====%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
    {
        _microLabel.text = [NSString stringWithFormat:@"%d",[[data objectForKey:@"sum"] intValue]];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 获取商品
- (void)getProduct {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];

    NSString *urlString = [NSString stringWithFormat:CLASSIFYURL,midString,uidString];
    
    if (_isSingleGoods) {
        urlString = [NSString stringWithFormat:PUSHCLASSIFYURL,midString,_categoryId,uidString];
    }
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
    {
        [_commodityArray removeAllObjects];
       
        NSArray *arr = data[@"ClassList"];
        for (NSDictionary *dict in arr) {
            
            LeftClassModel *model = [[LeftClassModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            NSArray *array = dict[@"List"];
            for (NSDictionary *goodsList in array) {
                
                RightGoodsModel *rmodel = [[RightGoodsModel alloc] init];
                [rmodel setValuesForKeysWithDictionary:goodsList];
                [model.listArray addObject:rmodel];
            }
            
            if (_isSingleGoods) {
                
                _categoryName = model.CategoryName;
                [self setNav];
            }
            
            [_commodityArray addObject:model];
        }

        _commodityTypeView.hidden = NO;
        _commodityTableView.hidden = NO;
        _commodityTableView.commodityArray = _commodityArray;
        [_commodityTypeView createCommodityType:_commodityArray];
        [_commodityTableView refreshTableView];
        [_commodityTableView.commodityTableView.mj_header endRefreshing];
        
        if (_commodityArray.count == 0 && !_isSingleGoods) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该提货点没有商品，请选择其他提货点" preferredStyle:UIAlertControllerStyleAlert];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
            {
                [self goAddressSelect];
            }];;
            [alertController addAction:alertAction];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"分类请求错误%@",error);

        [_commodityTableView.commodityTableView.mj_header endRefreshing];
        [Tools myHud:@"加载失败！请重新加载" inView:[[UIApplication sharedApplication].delegate window]];
    }];
}

- (void)updateCartCount:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {

    NSLog(@"=====更新商品=====%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            LeftClassModel *model = _commodityArray[indexPath.section];
            RightGoodsModel *rightGoodsModel = model.listArray[indexPath.row];
            rightGoodsModel.CartNum = [NSString stringWithFormat:@"%zd",[rightGoodsModel.CartNum integerValue] + _commodityTableView.goodsNumber];
            [model.listArray replaceObjectAtIndex:indexPath.row withObject:rightGoodsModel];
            [_commodityArray replaceObjectAtIndex:indexPath.section withObject:model];
            
            _microLabel.text = [NSString stringWithFormat:@"%zd",[_microLabel.text integerValue] + _commodityTableView.goodsNumber];
            
            _commodityTableView.commodityArray = _commodityArray;
            [_commodityTableView refreshTableView];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:^(NSError *error) {
        
    }];
}

@end
