//
//  MyOrderViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/10/21.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "MyOrderViewController.h"
#import "Order.h"
#import "MyOrderModel.h"
#import "WXApi.h"
#import "OrderStateView.h"
//#import "GoodsCartViewController.h"
#import "FSNoDataView.h"
#import "FSShoppingCartViewController.h"
#import "SubmitOrderViewController.h"
#import "ShopCart.h"

@interface MyOrderViewController ()

@property (nonatomic, strong) NSString *uidString;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNoString;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *orderCountArray;
@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) OrderStateView *orderStateView;
@property (copy, nonatomic) NSMutableArray *commodityArray;
@property (assign, nonatomic) CGFloat totalPrice;

@end

@implementation MyOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    
//    [self getOrder];
//    [self getCount];
}

- (void)viewDidLoad {
    
    _dataSource = [NSMutableArray array];
    _orderCountArray = [NSMutableArray array];
    _uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    [self setNav];
//    [self initOrderStateView];
    [self initMyOrderView];
    
    // 支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoPush) name:@"zhifubao" object:nil];
}

#pragma mark 设置导航
- (void)setNav {
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"我的订单"];
    self.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark 订单状态
- (void)initOrderStateView {

    _orderStateView = [[OrderStateView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    _orderStateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderStateView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_orderStateView.frame) - 0.5, SYSTEM_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE4E4E4"];
    [_orderStateView addSubview:line];
    
}

#pragma mark 我的订单界面
- (void)initMyOrderView {
    
    _myOrderView = [[MyOrderView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:_myOrderView];
    _myOrderView.index = _Index;
    NSLog(@"$$$$$$$$$$$******%ld", _myOrderView.index);
    WS(weakSelf);
    
    _myOrderView.requestOrder = ^(NSString *urlString) {
        _urlString = urlString;
//        [weakSelf getCount];
        [weakSelf getOrder];
    };

    // 前往控制器
    _myOrderView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    // 去付款
    _myOrderView.goPay = ^(Order *model){
        
        if ([model.status isEqualToString:@"1"]) {
            
            _orderId = [NSString stringWithFormat:@"%zd",[model.Id integerValue]];
            [weakSelf initPayView];
        }
        else {
            [weakSelf requestDataFromNetBuyAgainWithOrderID:[model.Id stringValue]];
        }
    };
    // 取消订单
    _myOrderView.cancelOrder = ^(){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否取消订单？" delegate:weakSelf cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
        [alertView show];
    };
    
    _myOrderView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getCount];
        [self getOrder];
    }];
}

#pragma mark 返回
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 支付通知
- (void)zhifubaoPush {
    [self getOrder];
    [self getCount];
}

#pragma mark 创建支付View
- (void)initPayView {
    
    if (_bgView == nil) {
        
        _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
        [_bgView addTarget:self action:@selector(isShowPayView) forControlEvents:UIControlEventTouchUpInside];
        [[[UIApplication sharedApplication].delegate window] addSubview:_bgView];
        
        NSArray *payTextArray = @[@"余额支付",@"微信支付",@"支付宝支付"];
        NSArray *payImageArray = @[@"余额付款",@"微信支付图标",@"支付宝图标"];
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(10, ScreenHeight / 2 - (payTextArray.count * 50 / 2), ScreenWidth - 20, payTextArray.count * 50)];
        payView.backgroundColor = [UIColor whiteColor];
        payView.layer.borderColor = [UIColor colorWithHexString:@"0xDAD9D9"].CGColor;
        payView.layer.borderWidth = 0.5;
        payView.layer.cornerRadius = 5;
        payView.layer.masksToBounds = YES;
        [_bgView addSubview:payView];
        
        UIButton *btn;
        for (int i = 0; i < payTextArray.count; i++) {
            
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 50 * i, CGRectGetWidth(payView.frame), 50);
            btn.tag = 10 + i;
            [btn addTarget:self action:@selector(selectPayType:) forControlEvents:UIControlEventTouchUpInside];
            [payView addSubview:btn];
            
            UILabel *payTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 35, 0, 70, CGRectGetHeight(btn.frame))];
            payTextLabel.text = payTextArray[i];
            payTextLabel.font = [UIFont systemFontOfSize:13];
            [btn addSubview:payTextLabel];
            
            UIImageView *payImageView = [[UIImageView alloc] initWithFrame:CGRectMake(payTextLabel.frame.origin.x - 30, CGRectGetHeight(btn.frame) / 2 - 10, 20, 20)];
            payImageView.image = IMAGE(payImageArray[i]);
            [btn addSubview:payImageView];
            
            if (i < payTextArray.count - 1) {
                
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
                l.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
                [btn addSubview:l];
            }
        }
    }
    else {
        [self isShowPayView];
    }
}

#pragma mark 是否隐藏支付View 
- (void)isShowPayView {
    _bgView.hidden = !_bgView.hidden;
}

#pragma mark 选择支付方式
- (void)selectPayType:(UIButton *)btn {

    _bgView.hidden = !_bgView.hidden;
    
    if (btn.tag == 10) [Single sharedInstance].payMent = AmountPlay;
    else [Single sharedInstance].payMent = btn.tag == 11 ? WeCartPay : AliPay;
    
    [self updatePaymentWithPayment:[NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent]];
}

#pragma mark 获取订单
- (void)getOrder {
    
    if ([Tools isBlankString:_urlString]) {
        _urlString = [NSString stringWithFormat:ORDER,1,1000,_uidString];
    }
    
    NSLog(@"********#######%@",_urlString);
    
    [HttpRequest sendGetOrPostRequest:_urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        [_dataSource removeAllObjects];
        
        if ([data[@"pageCount"] integerValue] > 0) {
            
            for (NSDictionary *dic in data[@"List"]) {
                
                Order *model = [[Order alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataSource addObject:model];
            }
        }
        
        if (_dataSource.count == 0) {
            _myOrderView.tableView.backgroundView = self.noDataView;
        } else {
            _myOrderView.tableView.backgroundView = nil;
        }
        
        _myOrderView.dataSource = _dataSource;
        [_myOrderView refreshTableView];
        [_myOrderView.tableView.mj_header endRefreshing];
        
    } failure:nil];
}

#pragma mark 订单状态总条数
- (void)getCount {
    
    [_orderCountArray removeAllObjects];
    
    NSString *urlString = [NSString stringWithFormat:GetOrderSum,_uidString];
    NSLog(@"获取角标数量 = %@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        MyOrderModel *model = [[MyOrderModel alloc] init];
        [model setDic:data];
        [_orderCountArray addObject:model];
        
        [_orderStateView setCountLabelWithModel:_orderCountArray[0]];
        
    } failure:nil];
}

#pragma mark 请求是否存在支付密码
- (void)requestIsPayPwd {
    
    NSString *urlString = [NSString stringWithFormat:IsPayPwd,_uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         [self setPayAlertControllerWithIsExist:[data[@"issuccess"] boolValue]];
         
     } failure:nil];
}

#pragma mark 输入支付密码
- (void)setPayAlertControllerWithIsExist:(BOOL)isExist {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:isExist ? @"余额支付" : @"设置支付密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *arr = isExist ? @[@"请输入支付密码"] : @[@"请输入登陆密码",@"请输入支付密码",@"请再次输入支付密码"];
    
    for (int i = 0; i < arr.count; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = arr[i];
            textField.secureTextEntry = YES;
            
            NSLog(@"%@", NSStringFromCGRect(textField.frame));

        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSMutableArray *passwordArary = [NSMutableArray array];
        for (UITextField *textField in alertController.textFields) {
            [passwordArary addObject:textField.text];
        }
        
        if (isExist) [self requstAmountPayWithPassword:[passwordArary[0] md5String]];
        else {
            
            if ([passwordArary[1] length] < 6) {
                return [Utillity showAlertViewWithMessage:@"密码不得小于6位" viewController:self.navigationController];
            }
            else if ([passwordArary[1] isEqualToString:passwordArary[2]]) {
                [self setPayPassword:[passwordArary[1] md5String] loginPassword:[passwordArary[0] md5String]];
            }
            else {
                [Utillity showAlertViewWithMessage:@"两次密码不一致，请重新操作" viewController:self.navigationController];
            }
        }
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 使用余额支付
- (void)requstAmountPayWithPassword:(NSString *)password {
    
    NSString *url = [NSString stringWithFormat:AmountPay,_orderNoString,password];
    [HttpRequest sendGetOrPostRequest:url param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) [self zhifubaoPush];
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

#pragma mark 设置支付密码
- (void)setPayPassword:(NSString *)password loginPassword:(NSString *)loginPassword{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [defaults objectForKey:@"mobile"];
    NSString *url = [NSString stringWithFormat:SetPayPwd,phone,loginPassword,@"1",password];
    [HttpRequest sendGetOrPostRequest:url param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if (![data[@"issuccess"] boolValue]) {
             [Utillity showAlertViewWithMessage:data[@"context"] viewController:self.navigationController];
         }
         else {
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"设置支付密码成功，请重新输入支付密码完成购物" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [self setPayAlertControllerWithIsExist:YES];
                                        }];
             [alertController addAction:okAction];
             [self.navigationController presentViewController:alertController animated:YES completion:nil];
         }
         
     } failure:nil];
}

#pragma mark 取消订单
- (void)cancelOrder {
    
    NSString *urlString = [NSString stringWithFormat:CANCELORDER,_myOrderView.orderId,_uidString];
    NSLog(@"%@",urlString);
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
    {
        [Tools myHud:data[@"context"] inView:self.view];
        
        [self getOrder];
        [self getCount];
        
    } failure:^(NSError *error) {}];
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
        
    }
    return _commodityArray;
}
#pragma mark - Custom

- (void)getCommodityData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,uidString,midString];
    NSLog(@"===购物车请求===%@",urlString);
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        [self.commodityArray removeAllObjects];
        
        if ([dataDict[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataDict[@"point"] forKey:@"point"];
            [userDefaults setObject:dataDict[@"TickCount"] forKey:@"TickCount"];
            
            for (NSDictionary *dic in dataDict[@"list"]) {
                
                ShopCart *model = [ShopCart modelWithDict:dic];
                model.isSelect = YES;
                [self.commodityArray addObject:model];
            }
            
            if (self.commodityArray.count) {
                
//                self.footerView.hidden = NO;
//                self.bottomView.hidden = NO;
//                self.emptyView.hidden = YES;
//                [self.tableView reloadData];
//                
                self.totalPrice = [self getTotalPrice];
                
//                [self.bottomView.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", fabs(self.totalPrice)]];
//                [self.bottomView.totalPriceLabel sizeToFit];
//                
//                self.bottomView.selectAllButton.selected = YES;
                
            } else {
//                self.footerView.hidden = YES;
//                self.bottomView.hidden = YES;
//                self.emptyView.hidden = NO;
            }
            
//            [self.refreshControl endRefreshing];
            
        }
        else {
//            if (!self.commodityArray.count) {
//                self.footerView.hidden = YES;
//                self.bottomView.hidden = YES;
//                self.emptyView.hidden = NO;
//                
//                
//            }
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
//        [self.refreshControl endRefreshing];
        [self showInfoWidthError:error];
    }];
    
}


#pragma mark 再次购买
- (void)requestDataFromNetBuyAgainWithOrderID:(NSString *)orderID {
    [self getCommodityData];
    NSString *urlString = [NSString stringWithFormat:ADDCOPYORDERCART,orderID,UUID,_uidString,[[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"]];
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            [self orderJieSuan];
//            NSMutableArray *arr = [NSMutableArray array];
//            for (int i = 0; i < self.dataSource.count; i++) {
//                
//                ShopCart *model = self.dataSource[i];
//                
//                [arr addObject:model];
//                
//                SubmitOrderViewController *paymentVC = [[SubmitOrderViewController alloc] init];
//                paymentVC.goodsArray = arr;
//                [self.navigationController pushViewController:paymentVC animated:YES];
//             
//            }
            
            

            
            // 跳转购物车
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:[FSShoppingCartViewController new] animated:YES];
        }
        else {
            [Tools myHud:data[@"context"] inView:self.view];
        }
        
    } failure:nil];
}

- (void)orderJieSuan {
    NSLog(@"下单");
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.commodityArray.count; i++) {
        
        ShopCart *model = self.commodityArray[i];
        
        if (model.isSelect) {
            
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
             
             // 提交订单页
             SubmitOrderViewController *paymentVC = [[SubmitOrderViewController alloc] init];
             paymentVC.goodsArray = arr;
             NSLog(@"%@", paymentVC.goodsArray);
             [self.navigationController pushViewController:paymentVC animated:YES];
             
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
         [self showInfoWidthError:error];
     }];
    

}

- (CGFloat)getTotalPrice {
    CGFloat totalPrice = 0.0f;
    
    for (ShopCart *model in self.commodityArray) {
        if (!model.isSelect) {
            continue;
        }
        if (model.isSelect) {
            CGFloat price = [model.productNum integerValue] * [model.salePrice floatValue];
            totalPrice += price;
        }
    }
    return totalPrice;
}

#pragma mark 更新支付方式
- (void)updatePaymentWithPayment:(NSString *)paymentId {

    NSString *url = [NSString stringWithFormat:UpdatePayment_id,_orderId,paymentId];
    [HttpRequest sendGetOrPostRequest:url param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            switch ([Single sharedInstance].payMent) {
                case AmountPlay: {
                    
                    _orderNoString = data[@"order_no"];
                    [self requestIsPayPwd];
                    break;
                }
                case AliPay: {
                    [Tools alipayPayRequestWithTradeNO:data[@"order_no"] ProductName:@"鲜摇派" ProductDescription:@"鲜摇派" Amount:data[@"totalPrice"] notify_url:ALIPAYURL];
                    break;
                }
                case WeCartPay: {
                    
                    if (![WXApi isWXAppInstalled]) {
                        return [Utillity showAlertViewWithMessage:@"未安装微信客户端" viewController:self.navigationController];
                    }
                    
                    [Tools WeCartPayWithNoncestr:data[@"nonce_str"] package:@"Sign=WXPay" partnerid:WECARTPARTERID prepayid:data[@"prepay_id"] timestamp:data[@"time_stamp"]];
                    break;
                }
            }
        }
     
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self cancelOrder];
    }
}

@end
