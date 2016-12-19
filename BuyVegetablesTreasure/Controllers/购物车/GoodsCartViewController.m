//
//  GoodsCartViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsCartViewController.h"
#import "GoodsCartTableView.h"
#import "ShoppingCartView.h"
#import "ShopCart.h"
#import "SubmitOrderViewController.h"
#import "ShopLoginViewController.h"

@interface GoodsCartViewController ()<UIAlertViewDelegate>


@property (nonatomic, copy) GoodsCartTableView *goodsCartTableView;
@property (nonatomic, copy) ShoppingCartView *shoppingCartView;
@property (nonatomic, copy) UIView *bottomView;
@property (nonatomic, copy) UILabel *totalPriceLabel;
@property (nonatomic, copy) UIButton *selectBtn;

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSMutableArray *goodsCartArray;

@end

@implementation GoodsCartViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self getShopCart];
    [self isLogin];
    
    _selectBtn.selected = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _goodsCartArray = [NSMutableArray array];
    
    [self initShoppingCartView];
    [self initBottomView];

    [self initGoodsCartTableView];
    [self setNav];
    [self getShopCart];
    [self requestPoint];
}

// 判断是否登陆了
- (void)isLogin {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    if ([Tools isBlankString:uidString]) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        ShopLoginViewController *loginVC = [ShopLoginViewController new];
        loginVC.isCart = YES;
        
        [self.navigationController pushViewController:loginVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - 初始化
#pragma mark 无商品View
- (void)initShoppingCartView {
    
    _shoppingCartView = [[ShoppingCartView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_shoppingCartView];

    WS(weakSelf);
    _shoppingCartView.goHomePage = ^{
        
        if (weakSelf.isHiddenBackBtn) {
            
            weakSelf.tabBarController.selectedIndex = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@"1"];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }
        else {
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}

#pragma mark 商品tableView
- (void)initGoodsCartTableView {
    
    _goodsCartTableView = [GoodsCartTableView new];
    _goodsCartTableView.hidden = YES;
    [self.view addSubview:_goodsCartTableView];
    
    _goodsCartTableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(_bottomView, 0);
    
    WS(weakSelf);
    _goodsCartTableView.deleteCartGoods = ^(NSString *goodsId) {
        [Tools myAlert:@"是否删除该商品" target:weakSelf];
        _goodsId = goodsId;
    };
    
    _goodsCartTableView.upCartGoodsNumber = ^(NSInteger productNum,NSString *productId,BOOL type)
    {
        [weakSelf upCartGoods:productNum GoodsId:productId type:type];
    };
    
    _goodsCartTableView.bottomViewBlock = ^(){
        
        NSMutableArray *arr = [NSMutableArray array];
        float totalPrice = 0;
        for (int i = 0; i < _goodsCartArray.count; i++) {
            
            ShopCart *model = weakSelf.goodsCartArray[i];
            
            if (!model.isSelect) {
                
                [arr addObject:model];
                
                totalPrice += [model.salePrice floatValue] * [model.productNum integerValue];
            }
        }
        
        if (arr.count == _goodsCartArray.count) {
            
            weakSelf.selectBtn.selected = YES;

        }else{
            weakSelf.selectBtn.selected = NO;
        }
        
        weakSelf.totalPriceLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",totalPrice];
        
    };
}

#pragma mark 底部View
- (void)initBottomView {
    
    if (_bottomView == nil) {
        
        _bottomView = [UIView new];
        _bottomView.hidden = YES;
        [self.view addSubview:_bottomView];
        
        _bottomView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .yIs(ScreenHeight - 64 - 50)
        .heightIs(50);
        
        if (self.isHiddenBackBtn) {
            _bottomView.sd_layout.yIs(ScreenHeight - 64 - 50 - 44);
        }
        
        UIImage *img = IMAGE(@"没有选择");
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.selected = YES;
        [_selectBtn setImage:IMAGE(@"没有选择") forState:UIControlStateNormal];
        [_selectBtn setImage:IMAGE(@"购物车-选择") forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_selectBtn];
        
        _selectBtn.sd_layout
        .leftSpaceToView(_bottomView, 10)
        .topSpaceToView(_bottomView, 0)
        .heightIs(50)
        .widthIs(img.size.width);
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"全选";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = Color;
        [_bottomView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(_selectBtn, 10)
        .topSpaceToView(_bottomView, 0)
        .bottomSpaceToView(_bottomView, 0)
        .widthIs(30);
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.backgroundColor = Color;
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [submitBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:submitBtn];
        
        submitBtn.sd_layout
        .rightSpaceToView(_bottomView, 0)
        .topSpaceToView(_bottomView, 0)
        .bottomSpaceToView(_bottomView, 0)
        .widthIs(100);
        
        _totalPriceLabel = [UILabel new];
        _totalPriceLabel.text = @"总计：¥0";
        _totalPriceLabel.font = [UIFont systemFontOfSize:14];
        _totalPriceLabel.textColor = Color;
        _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_totalPriceLabel];
        
        _totalPriceLabel.sd_layout
        .leftSpaceToView(titleLabel, 5)
        .rightSpaceToView(submitBtn, 5)
        .topSpaceToView(_bottomView, 0)
        .bottomSpaceToView(_bottomView, 0);
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
        [_bottomView addSubview:line];
    }
    else {
        
        float totalPrice = 0.0;
        for (int i = 0; i < _goodsCartArray.count; i++) {
            
            ShopCart *model = _goodsCartArray[i];
            if (!model.isSelect) {
                
                totalPrice += [model.salePrice floatValue] * [model.productNum integerValue];
            }
        }
        
        _totalPriceLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",totalPrice];
    }
}

- (void)btnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    float totalPrice = 0.0;
    for (int i = 0; i < _goodsCartArray.count; i++) {
        
        ShopCart *model = _goodsCartArray[i];
        model.isSelect = !btn.selected;
        [_goodsCartArray replaceObjectAtIndex:i withObject:model];
        
        if (!model.isSelect) {
            
            totalPrice += [model.salePrice floatValue] * [model.productNum integerValue];
        }
    }
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",totalPrice];
    [_goodsCartTableView refreshTableView];
}

#pragma mark 设置导航
- (void)setNav {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"购物车"];
    
    if (!self.isHiddenBackBtn) {
        
        self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    }
}

#pragma mark - 事件处理
#pragma mark 返回按钮
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求
#pragma mark 获取购物车商品
- (void)getShopCart {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,uidString,midString];
    NSLog(@"===购物车请求===%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        [_goodsCartArray removeAllObjects];
        
        if ([data[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:data[@"point"] forKey:@"point"];
            [userDefaults setObject:data[@"TickCount"] forKey:@"TickCount"];
            
            for (NSDictionary *dic in data[@"list"]) {
                
                ShopCart *model = [[ShopCart alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_goodsCartArray addObject:model];
            }
            
            if (_goodsCartArray.count > 0) {
                _bottomView.hidden = NO;
                _goodsCartTableView.hidden = NO;
                _goodsCartTableView.goodsCartArray = _goodsCartArray;
                [_goodsCartTableView refreshTableView];
            }
            else {
                _bottomView.hidden = YES;
                _goodsCartTableView.hidden = YES;
            }
            
            [self initBottomView];
        }
        else {
            
            if (_goodsCartArray.count == 0) {
                _bottomView.hidden = YES;
                _goodsCartTableView.hidden = YES;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"===购物车请求===%@",error);
    }];
}

#pragma mark  删除购物车商品
- (void)deleteCartGoods:(NSString *)goodsID {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    
    NSString *urlString = [NSString stringWithFormat:DelCartUrl,UUID,midString,goodsID,uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         [self getShopCart];
         
     } failure:nil];
}

#pragma mark 更新购物车商品
- (void)upCartGoods:(NSInteger)productNum GoodsId:(NSString *)productId type:(BOOL)type {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *typeString = type ? @"0" : @"1";

    NSString *urlString = [NSString stringWithFormat:UpCart,UUID,midString,productId,uidString,[NSString stringWithFormat:@"%zd",productNum],typeString];
    NSLog(@"==更新购物车==%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            if (_goodsCartArray.count > 0) {
                
                ShopCart *model = _goodsCartArray[_goodsCartTableView.indexPath.row];
                model.productNum = [NSNumber numberWithInteger:_goodsCartTableView.goodsNumber];
                [_goodsCartArray replaceObjectAtIndex:_goodsCartTableView.indexPath.row withObject:model];
                
                [self initBottomView];
            }
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        _goodsCartTableView.goodsCartArray = _goodsCartArray;
        [_goodsCartTableView refreshTableView];
        
    } failure:^(NSError *error) {}];
    
    
}

#pragma mark 前往支付商品
- (void)goPay {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < _goodsCartArray.count; i++) {
        
        ShopCart *model = _goodsCartArray[i];
        
        if (!model.isSelect) {
            
            [arr addObject:model];
        }
    }
    
    if (arr.count == 0) {
        return [Tools myHud:@"请选择商品" inView:self.view];
    }
    
    // 保存商品列表
    NSMutableArray *listArray = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        ShopCart *model = arr[i];
        NSDictionary *dic = @{@"Id":[NSString stringWithFormat:@"%zd",[model.ID integerValue]],
                              @"num":[NSString stringWithFormat:@"%zd",[model.productNum integerValue]]};
        
        [listArray addObject:dic];
    }
    
    NSDictionary *listDict = @{@"List":listArray};
    NSString *jsonString = [Utillity DataTOjsonString:listDict];
    NSString *urlString = [NSString stringWithFormat:SUMBITORDER,jsonString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"%20" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"%0A" withString:@""];
    SLog(@"=====选好了=====%@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:POST setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            self.hidesBottomBarWhenPushed = YES;
            SubmitOrderViewController *paymentVC = [[SubmitOrderViewController alloc] init];
            paymentVC.goodsArray = arr;
            [self.navigationController pushViewController:paymentVC animated:YES];
            
            if (self.isHiddenBackBtn) {
                
                self.hidesBottomBarWhenPushed = NO;
            }
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self deleteCartGoods:_goodsId];
    }
}

#pragma mark 获取积分等
-(void)requestPoint
{
    NSString *urlString = [NSString stringWithFormat:GetUSERINFO,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    NSLog(@"==获取积分、余额、优惠券==%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
     {
         if ([[data objectForKey:@"issuccess"] boolValue]) {
             
             _goodsCartTableView.point = data[@"point"];
             _goodsCartTableView.tick = data[@"TickNum"];
             [_goodsCartTableView refreshTableView];
         }
         
     } failure:nil];

}
@end
