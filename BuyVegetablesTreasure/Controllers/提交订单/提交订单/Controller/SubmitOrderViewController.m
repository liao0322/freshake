//
//  SubmitOrderViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "MyOrderViewController.h"
#import "SubmitOrderView.h"
#import "CouponModel.h"
#import "ShopCart.h"
#import "Map.h"
#import "WXApi.h"
#import "SiteModel.h"

typedef NS_ENUM(NSInteger,CouponType) {
    
    /// 商品优惠券
    GoodsCoupon  = 1,
    /// 商品类型优惠券
    CategoryCoupon,
    /// 商家优惠券
    MerchantsCoupon,
    /// 通用优惠券
    AllCoupon
};

@interface SubmitOrderViewController ()

@property (nonatomic, strong) SubmitOrderView *submitOrderView;
/// 优惠券数量
@property (nonatomic, assign) NSInteger numberOfCoupons;
/// 优惠券
@property (nonatomic, strong) NSMutableArray *couponArray;
/// 商品总价
@property (nonatomic, assign) CGFloat totalPrice;
/// 积分
@property (nonatomic, assign) NSInteger integral;

@end

@implementation SubmitOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.couponArray = [NSMutableArray array];
    
    // 提交订单视图
    [self.view addSubview:self.submitOrderView];
    
    // 设置导航
    [self setNav];
    // 更新商家
    [self updateMerchants];
    // 用户购买信息
    [self getOrderHost];
    // 获取商家配送方式
    [self getStorePament];
    // 获取积分
    [self getIntegral];
    // 优惠券
    [self getCoupons];
    
    if (!self.buySoon) {
        
        // 购物车商品
        [self getGoods];
    }
    else {
        
        ShopCart *model = self.goodsArray[0];
        self.totalPrice = [model.salePrice floatValue] * [model.productNum intValue];
        
        self.submitOrderView.hidden = NO;
        self.submitOrderView.goodsArray = self.goodsArray;
        self.submitOrderView.totalPrice = self.totalPrice;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // 添加推送
    [self addNotificationCenter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 控件初始化
// 提交订单视图
- (SubmitOrderView *)submitOrderView {
    
    if (!_submitOrderView) {
        
        _submitOrderView = [[SubmitOrderView alloc] init];
        _submitOrderView.buySoon = self.buySoon;
        _submitOrderView.hidden = YES;
        [self.view addSubview:_submitOrderView];
        
        _submitOrderView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        .bottomEqualToView(self.view);
        
        WS(weakSelf);
        [_submitOrderView setPayInfo:^(NSDictionary *payInfoDic) {
            [weakSelf addNewOrder:payInfoDic];
        }];
        
        [_submitOrderView setGoViewController:^(UIViewController *goViewController) {
            [weakSelf pushViewControlle:goViewController backIsHiddenTabbar:YES];
        }];
    }
    
    return _submitOrderView;
}

- (void)setIsCollect:(BOOL)isCollect {
    self.submitOrderView.isCollect = isCollect;
}

- (void)setFendianId:(NSString *)fendianId {
    self.submitOrderView.fendianId = fendianId;
}

- (void)setMidString:(NSString *)midString {
    self.submitOrderView.midString = midString;
}

- (void)setFendianAddress:(NSString *)fendianAddress {
    self.submitOrderView.fendianAddress = fendianAddress;
}

- (void)setGoodsArray:(NSArray *)goodsArray {
    _goodsArray = goodsArray;
}

#pragma mark - 推送
// 添加推送
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payState:) name:@"PayState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"zhifubao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:@"zhifubaoCancel" object:nil];
}

// 支付状态
- (void)payState:(NSNotification *)notification {
    
    BOOL state = [[notification object] boolValue];
    
    if (state) {
        
        [Tools myHud:@"支付成功"];
    }
    else {
        
        [Tools myHud:@"支付失败"];
    }
    
    [Single sharedInstance].isRefreshTitle = NO;
    [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
}

// 付款成功
- (void)paySuccessful {

    [Tools myHud:@"付款成功" inView:self.view];
    [Single sharedInstance].isRefreshTitle = NO;
    // 前往我的订单
    [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
}

// 付款失败
- (void)payFailure {
    
    [Tools myHud:@"付款失败" inView:self.view];
    [Single sharedInstance].isRefreshTitle = NO;
    // 前往我的订单
    [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
}

#pragma mark - 导航条
// 设置导航
- (void)setNav {
    self.title = @"提交订单";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

// 返回
- (void)back {
    
    [Single sharedInstance].isDelivery = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 优惠券
// 获取优惠劵
- (void)getCoupons {
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    midString = _isCollect ? self.midString : midString;
    NSString *urlString = [NSString stringWithFormat:@"%@&Sid=%@",[NSString stringWithFormat:GetMyTickList, 1, 1000, GetUserId], midString];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        NSLog(@"%@",data[@"TickName"]);
        
        if ([data[@"issuccess"] boolValue]) {
            
            // 重置优惠券数量
            [self.couponArray removeAllObjects];
            self.numberOfCoupons = 0;
            for (NSDictionary *dic in data[@"List"]) {
                
                // 判断优惠券是否过期、有效
                if (![dic[@"hasLingQu"] boolValue] && [dic[@"IsExpileDate"] boolValue]) {
                    
                    CouponModel *model = [[CouponModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    
                    
                    if ([model.TickName isEqualToString:@"发布测试券"]) {
                        
                        
                    }
                    
                    if ([model.IsExpileDate intValue] != 2) {
                        
                        // 是否添加优惠券
                        BOOL isAddCoupon = NO;
                        // 各类ID
                        NSArray *idArray = [model.typeObjectId componentsSeparatedByString:@","];
                        
                        // 判断是否商品优惠券
                        if ([model.typeId intValue] == 1) {
                            
                            isAddCoupon = [self couponCountWithCouponType:GoodsCoupon
                                                             typeObjectId:idArray
                                                              couponPrice:[model.consumeMoney intValue]];
                        }
                        else {
                            
                            isAddCoupon = [self couponCountWithCouponType:[model.type integerValue]
                                                             typeObjectId:idArray
                                                              couponPrice:[model.consumeMoney intValue]];
                        }
                        
                        // 条件满足添加到模型
                        if (isAddCoupon) {
                            
                            self.numberOfCoupons++;
                            [self.couponArray addObject:model];
                        }
                    }
                }
            }
            
            self.submitOrderView.couponArray = self.couponArray;
            self.submitOrderView.numberOfCoupons = self.numberOfCoupons;
        }
        
    } failure:nil];
}

/**
 *  使用优惠劵数量
 *
 *  @param couponType  优惠券类型
 *  @param idArray     商品ID
 *  @param couponPrice 优惠券优惠需要达到的金额
 *
 *  @return 是否可以使用该优惠券
 */
- (BOOL)couponCountWithCouponType:(CouponType)couponType
                     typeObjectId:(NSArray *)idArray
                      couponPrice:(CGFloat)couponPrice
{
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    
    BOOL isAddCoupon = NO;
    // 判断是否商品和分类
    if (couponType == GoodsCoupon || couponType == CategoryCoupon) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < _goodsArray.count; i++) {
            
            ShopCart *model = _goodsArray[i];
            
            for (int a = 0; a < idArray.count; a++) {
                
                NSString *modelString = couponType == GoodsCoupon ? model.productId : model.categoryId;
                if ([modelString intValue] == [idArray[a] intValue]) {
                    [arr addObject:model];
                }
            }
        }
        
        // 商品价格
        float goodsPrice = 0.0;
        // 计算商品总价
        for (int i = 0; i < arr.count; i++) {
            
            ShopCart *model = arr[i];
            goodsPrice += [model.salePrice floatValue] * [model.productNum integerValue];
        }
        
        if (arr.count > 0) {
            
            if (goodsPrice >= couponPrice) {
                return YES;
            }
        }
    }
    // 判断商家优惠券
    else if (couponType == MerchantsCoupon) {
        
        for (int i = 0; i < idArray.count; i++) {
            
            if ([midString isEqualToString:idArray[i]]) {
                
                if (self.totalPrice >= couponPrice) {
                    return YES;
                }
            }
        }
    }
    // 通用优惠券
    else if (self.totalPrice >= couponPrice) {
        
        return YES;
    }
    
    return isAddCoupon;
}

#pragma mark - 数据请求
// 获取自提商家
- (void)getMStore {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float latitude = [defaults doubleForKey:@"positioningLatitude"];
    float longitude = [defaults doubleForKey:@"positioningLongitude"];
    // 商家ID
    NSString *midString = self.isCollect ? self.midString : [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GETMSTORE,midString,latitude,longitude,@"0"];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {

            if ([data[@"list"] count] > 0) {
                
                Map *mapModel = [[Map alloc] init];
                [mapModel setValuesForKeysWithDictionary:data[@"list"][0]];
                self.submitOrderView.model = mapModel;
            }
        }
        else [Tools myHud:data[@"context"]];
        
    } failure:nil];
}

// 获取积分
- (void)getIntegral {
    
    NSString *urlString = [NSString stringWithFormat:GetUSERINFO, GetUserId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        self.integral = [data[@"point"] integerValue];
        self.submitOrderView.integral = self.integral;
        
    } failure:nil];
}

// 更新商家
- (void)updateMerchants {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float lat = [userDefaults doubleForKey:@"positioningLatitude"];
    float lon = [userDefaults doubleForKey:@"positioningLongitude"];
    
    NSString *urlString = [NSString stringWithFormat:MAPURL, lat, lon];
    [self requestJsonWithUrlString:urlString isLoading:NO success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"list"]) {
                
                Map *model = [[Map alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
            
            NSString *fendianname = [userDefaults objectForKey:@"Fendianname"];
            for (Map *mapModel in arr) {
                
                if ([fendianname isEqualToString:mapModel.Fendianname]) {
                    
                    // 判断是否有免运费
                    if (!isBlankString(mapModel.fullPrice)) {
                        
                        if (self.totalPrice >= [mapModel.fullPrice floatValue]) {
                            [Single sharedInstance].freight = 0;
                            return;
                        }
                        else [Single sharedInstance].freight = [mapModel.DistancePrice floatValue];
                    }
                    else  [Single sharedInstance].freight = [mapModel.DistancePrice floatValue];
                }
            }
        }
        
    } failure:nil];
}

// 获取用户地址
- (void)getUserAddress {
    
    NSString *urlString = [NSString stringWithFormat:@"%@&isdefault=%@",[NSString stringWithFormat:GetUserAddressList,GetUserId],@"1"];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            if ([data[@"AddressList"] count] > 0) {

                SiteModel *model = [[SiteModel alloc] init];
                [model setValuesForKeysWithDictionary:data[@"AddressList"][0]];
                self.submitOrderView.model = model;
            }
        }
        
    } failure:nil];
}

// 获取商家配送方式
- (void)getStorePament {
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GetStorePament,midString];
    [self requestJsonWithUrlString:urlString isLoading:NO success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
        
            _submitOrderView.deliveryStatus = [data[@"IsDelivery"] boolValue];
            _submitOrderView.distributionStatus = [data[@"IsDistribution"] boolValue];
            [Single sharedInstance].isdeliverTime = [data[@"IsdeliverTime"] boolValue];
            
            // 自提点
            if (_submitOrderView.deliveryStatus) [self getMStore];
            // 获取用户地址
            else [self getUserAddress];
        }
        
    } failure:nil];
}

// 用户信息
- (void)getOrderHost {
    
    NSString *urlString = [NSString stringWithFormat:GetOrderHost,GetUserId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            [Single sharedInstance].userName = data[@"username"];
            [Single sharedInstance].userTel  = data[@"tel"];
        }
        
    } failure:nil];
}

// 获取购物车商品
- (void)getGoods {
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS, UUID, GetUserId, midString];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            _submitOrderView.hidden = NO;
            
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *goodsArray = [NSMutableArray array];
            for (NSDictionary *dic in data[@"list"]){
                
                ShopCart *goodsModel = [[ShopCart alloc] init];
                [goodsModel setValuesForKeysWithDictionary:dic];
                [arr addObject:goodsModel];
            }
            
            for (int i = 0; i < _goodsArray.count; i++) {
                
                ShopCart *goodsModel = _goodsArray[i];
                for (int a = 0; a < arr.count; a++) {
                    
                    ShopCart *model = arr[a];
                    if ([goodsModel.productId integerValue] == [model.productId integerValue]) {
                        [goodsArray addObject:model];
                        break;
                    }
                }
            }
            
            self.totalPrice = 0;
            for (int i = 0; i < goodsArray.count; i++) {
                
                ShopCart *model = goodsArray[i];
                self.totalPrice += [model.salePrice floatValue] * [model.productNum integerValue];
            }
            
            _goodsArray = goodsArray;
            _submitOrderView.goodsArray = goodsArray;
            _submitOrderView.totalPrice = self.totalPrice;
            
            // 获取优惠券
            [self getCoupons];
            [self updateMerchants];
        }
        
    } failure:nil];
}

// 添加新的订单
- (void)addNewOrder:(NSDictionary *)payInfoDic {
    
    if ([Single sharedInstance].payMent == WeCartPay) {
        
        if (![WXApi isWXAppSupportApi] && ![WXApi isWXAppInstalled]) {
            
            return [Tools myHud:@"微信未安装或微信版本太低" inView:self.view];
        }
    }
    
    NSString *jsonString = [Utillity DataTOjsonString:payInfoDic];

    /**
     *  ADDORDERNUMBER - 立即购买生成订单
     *  ORDERNUMBER - 购物车生成订单
     */
    NSString *urlString = [NSString stringWithFormat: _buySoon ? ADDORDERNUMBER : ORDERNUMBER, jsonString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"%0A" withString:@""];
    
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if (![data[@"issuccess"] boolValue]) {
            
            return [Tools myHud:data[@"context"] inView:self.view];
        }
        else if ([data[@"totalPrice"] floatValue] <= 0) {
            
            // 跳转到订单详情
             [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
        }
        else if ([data[@"issuccess"] boolValue]) {
            
            switch ([Single sharedInstance].payMent) {
                    
                case AmountPlay: {
                    
                    self.orderNoString = data[@"order_no"];
                    [self isPayPwd];
                    break;
                }
                    
                case AliPay: {
                    
                       [Tools alipayPayRequestWithTradeNO:data[@"order_no"]
                                              ProductName:@"鲜摇派"
                                       ProductDescription:@"鲜摇派"
                                                   Amount:data[@"totalPrice"]
                                               notify_url:ALIPAYURL];
                    break;
                }
                    
                case WeCartPay: {
                    
                        [Tools WeCartPayWithNoncestr:data[@"nonce_str"]
                                             package:@"Sign=WXPay"
                                           partnerid:data[@"mch_id"]
                                            prepayid:data[@"prepay_id"]
                                           timestamp:data[@"time_stamp"]];
                    break;
                }
            }
        }
        
    } failure:nil];
}

@end
