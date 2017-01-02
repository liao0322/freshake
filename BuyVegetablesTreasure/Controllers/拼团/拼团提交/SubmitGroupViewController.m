//
//  SubmitGroupViewController.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "SubmitGroupViewController.h"
#import "PayGroupOrderTableView.h"
#import "MyGroupViewController.h"
#import "UserModel.h"
#import "WXApi.h"
#import "MyGroupViewController.h"

@interface SubmitGroupViewController ()

@property (nonatomic, copy) PayGroupOrderTableView *payGroupOrderTableView;
@property (nonatomic, copy) UILabel *priceLabel;

@property (nonatomic, copy) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSString *orderNoString;
@property (nonatomic, copy) NSMutableArray *userInfoArray;
/// 可用积分
@property (nonatomic, assign) CGFloat availableIntegral;

@end

@implementation SubmitGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _userInfoArray = [NSMutableArray array];
    
    [self setNav];
    [self initPayGroupOrderTableView];
    [self payOrderView];
    [self requestUserInfo];
    [self addNotificationCenter];
    [self getIntegral];
}

#pragma mark - 通知
// 添加通知
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
        [Single sharedInstance].isRefreshTitle = NO;
        [self.navigationController pushViewController:[MyGroupViewController new] animated:YES];
    }
    else {
        
        [Tools myHud:@"支付失败"];
    }
}

// 付款成功
- (void)paySuccessful {
    
    [Tools myHud:@"付款成功" inView:self.view];
    [Single sharedInstance].isRefreshTitle = NO;
    [self.navigationController pushViewController:[MyGroupViewController new] animated:YES];
}

// 付款失败
- (void)payFailure {
    
    [Tools myHud:@"付款失败" inView:self.view];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化
- (void)initPayGroupOrderTableView {
    
    _payGroupOrderTableView = [[PayGroupOrderTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
    _payGroupOrderTableView.gourpModel = _groupModel;
    [self.view addSubview:_payGroupOrderTableView];
    
    WS(weakSelf);
    _payGroupOrderTableView.goAddress = ^(UIViewController *viewController) {
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    };
    
    [_payGroupOrderTableView setCurrentCoor:^(CLLocationCoordinate2D coor) {
        [weakSelf distanceWithCoor:coor];
    }];
    
    _payGroupOrderTableView.reloadPrice = ^(){
        
        CGFloat fee = [weakSelf.payGroupOrderTableView.express_fee floatValue];
        CGFloat price = fee + [_groupModel.ActivityPrice floatValue];
        
        if (weakSelf.availableIntegral / 100 > price) {
            weakSelf.payGroupOrderTableView.availableIntegral = price * 100;
        }
        else {
            weakSelf.payGroupOrderTableView.availableIntegral = weakSelf.availableIntegral;
        }

        weakSelf.priceLabel.text = [NSString stringWithFormat:@"应付金额: ¥%.2f",price - weakSelf.payGroupOrderTableView.integralSwitch.on * (weakSelf.payGroupOrderTableView.availableIntegral / 100)];
    };
    
    [self getStorePament];
}

#pragma mark 设置导航
- (void)setNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    
    self.title = @"拼团提交";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark 付款
- (void)payOrderView {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
    [bgView addSubview:line];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 5 * 3, CGRectGetHeight(bgView.frame))];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    _priceLabel.text = [NSString stringWithFormat:@"应付金额: ¥%.2f",[_groupModel.ActivityPrice floatValue]];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor orangeColor];
    [bgView addSubview:_priceLabel];
    
    UIButton *orderStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderStatusBtn.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame), 0, ScreenWidth / 5 * 2, CGRectGetHeight(bgView.frame));
    orderStatusBtn.backgroundColor = [UIColor colorDomina];
    orderStatusBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [orderStatusBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    [orderStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderStatusBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:orderStatusBtn];
}

#pragma mark 距离
- (void)distanceWithCoor:(CLLocationCoordinate2D)coor {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CLLocationCoordinate2D coor1;
    coor1.latitude = [[userDefaults objectForKey:@"xPoint"] floatValue];
    coor1.longitude = [[userDefaults objectForKey:@"yPoint"] floatValue];
    BMKMapPoint bdMap1 = BMKMapPointForCoordinate(coor1);
    BMKMapPoint bdMap2 = BMKMapPointForCoordinate(coor);
    
    CLLocationDirection distance = BMKMetersBetweenMapPoints(bdMap1, bdMap2);
    
    NSLog(@"xPoint == %f", coor1.latitude);
    NSLog(@"yPoint == %f", coor1.longitude);
    NSLog(@"x == %f", coor.latitude);
    NSLog(@"y == %f", coor.longitude);
    
    NSLog(@"===配送最大距离%.2f,===相距%.2f",[[userDefaults objectForKey:@"Distance"] floatValue],distance);
    
    if (distance > [[userDefaults objectForKey:@"Distance"] floatValue]) {
        [Tools myHud:@"您选择的收货地址超出配送范围，请重新选择" inView:self.view];
        
//        _affirmPayment.payBtn.enabled = NO;
//        _affirmPayment.payBtn.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        
//        _affirmPayment.payBtn.enabled = YES;
//        _affirmPayment.payBtn.backgroundColor = Color;
    }
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)back{
    
    [Single sharedInstance].userName = @"";
    [Single sharedInstance].userTel = @"";
    [Single sharedInstance].remark = @"";
    [Single sharedInstance].invoiceTitle = @"";
    [Single sharedInstance].invoiceContent = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求
#pragma mark 获取积分
- (void)getIntegral {
    
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetUSERINFO, uidString];
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data) {
        
        self.availableIntegral = [data[@"point"] floatValue];
        if (self.availableIntegral / 100 > [_groupModel.ActivityPrice floatValue]) {
            self.payGroupOrderTableView.availableIntegral = [_groupModel.ActivityPrice floatValue] * 100;
        }
        else self.payGroupOrderTableView.availableIntegral = self.availableIntegral;
        
    } failure:nil];
}

#pragma mark 提交订单
- (void)submitOrder {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *userNameString = [userDefaults objectForKey:@"nick_name"];
    NSString *openactivityid = @"0";
    NSString *userName = [Single sharedInstance].userName;
    NSString *userTel = [Single sharedInstance].userTel;
    NSString *remark = [Single sharedInstance].remark;
    NSString *usePoint = [NSString stringWithFormat:@"%.0f", self.payGroupOrderTableView.availableIntegral];

    if ([Tools isBlankString:userName]) {
        return [Tools myHud:@"请输入提货人" inView:self.view];
    }
    else if ([Tools isBlankString:userTel]) {
        return [Tools myHud:@"请输入电话号码" inView:self.view];
    }
    else if (![Tools isMobileNum:userTel]) {
        return [Tools myHud:@"电话号码输入有误，请重新输入" inView:self.view];
    }
    else if ([Tools isBlankString:_payGroupOrderTableView.express_fee]) {
        _payGroupOrderTableView.express_fee = @"0";
    }
    
    if (![Tools isBlankString:_groupModel.Id]) {
        openactivityid = _groupModel.Id;
    }
    
    NSString *urlString;
    
    if (_isUpdate) {
        
        NSDictionary *listDict = @{@"fendianId":_payGroupOrderTableView.fendianId,
                                   @"payment_id":[NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent],
                                   @"payment_fee":@"0",
                                   @"mobile":userTel,
                                   @"accept_name":userName,
                                   @"accept_address":_payGroupOrderTableView.accept_address,
                                   @"remark":remark,
                                   @"express_id":_payGroupOrderTableView.express_id,
                                   @"express_fee":_payGroupOrderTableView.express_fee,
                                   @"Id":openactivityid,
                                   @"InvoiceTitle":[Single sharedInstance].invoiceTitle,
                                   @"InvoiceContent":[Single sharedInstance].invoiceContent,
                                   @"usePoint":usePoint};

        urlString = [NSString stringWithFormat:UpdateActivityOrder,[Utillity DataTOjsonString:listDict]];
    }
    else {
        
        NSDictionary *listDict = @{@"fendianId":_payGroupOrderTableView.fendianId,
                                   @"mid":midString,
                                   @"userId":uidString,
                                   @"addUserId":uidString,
                                   @"userName":userNameString,
                                   @"payment_id":[NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent],
                                   @"payment_fee":@"0",
                                   @"mobile":userTel,
                                   @"accept_name":userName,
                                   @"accept_address":_payGroupOrderTableView.accept_address,
                                   @"remark":remark,
                                   @"ProductId":_groupModel.ProductId,
                                   @"express_id":_payGroupOrderTableView.express_id,
                                   @"express_fee":_payGroupOrderTableView.express_fee,
                                   @"ActivityId":_groupModel.Id,
                                   @"IsAdd":@"1",
                                   @"ActivityPrice":_groupModel.ActivityPrice,
                                   @"Openactivityid":@"0",
                                   @"InvoiceTitle":[Single sharedInstance].invoiceTitle,
                                   @"InvoiceContent":[Single sharedInstance].invoiceContent,
                                   @"usePoint":usePoint};
        
        urlString = [NSString stringWithFormat:AddActivityOrder,[Utillity DataTOjsonString:listDict]];
    }
    
    if ([Single sharedInstance].payMent == WeCartPay ) {
        
        if (![WXApi isWXAppSupportApi] || ![WXApi isWXAppInstalled]) {
            
            return [Utillity showAlertViewWithMessage:@"微信未安装或微信版本太低" viewController:self.navigationController];
        }
    }
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if (![data[@"issuccess"] boolValue]) {
            
            return [Tools myHud:data[@"context"] inView:self.view];
        }
        else if ([data[@"totalPrice"] floatValue] <= 0) {
            
            // 跳转到订单详情
            [self.navigationController pushViewController:[MyGroupViewController new] animated:YES];
        }
        else if ([data[@"issuccess"] boolValue]) {
            
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
                    [Tools WeCartPayWithNoncestr:data[@"nonce_str"] package:@"Sign=WXPay" partnerid:data[@"mch_id"] prepayid:data[@"prepay_id"] timestamp:data[@"time_stamp"]];
                    break;
                }
            }
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

#pragma mark 输入支付密码
- (void)setPayAlertControllerWithIsExist:(BOOL)isExist {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:isExist ? @"余额支付" : @"设置支付密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *arr = isExist ? @[@"请输入支付密码"] : @[@"请输入登录密码",@"请输入支付密码",@"请再次输入支付密码"];
    for (int i = 0; i < arr.count; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.height = 44;
            textField.placeholder = arr[i];
            textField.secureTextEntry = YES;
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
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

    NSString *urlString = [NSString stringWithFormat:AmountPay,_orderNoString,password];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             [self.navigationController pushViewController:[MyGroupViewController new] animated:YES];
         }
         else [Utillity showAlertViewWithMessage:data[@"context"] viewController:self.navigationController];
         
     } failure:nil];
}

#pragma mark 设置支付密码
- (void)setPayPassword:(NSString *)password loginPassword:(NSString *)loginPassword{
    
    NSString *phone = [_userDefaults objectForKey:@"mobile"];
    NSString *isMobLogin = [NSString stringWithFormat:@"%zd",[_userDefaults boolForKey:@"isMobLogin"]];
    NSString *urlString = [NSString stringWithFormat:SetPayPwd,phone,loginPassword,isMobLogin,password];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
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

#pragma mark 请求是否存在支付密码
- (void)requestIsPayPwd {
    
    NSString *urlString = [NSString stringWithFormat:IsPayPwd,[_userDefaults objectForKey:@"UID"]];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         [self setPayAlertControllerWithIsExist:[data[@"issuccess"] boolValue]];
         
     } failure:nil];
}

#pragma mark 请求用户信息
- (void)requestUserInfo {
    
    NSString *urlString = [NSString stringWithFormat:GetOrderHost,[_userDefaults objectForKey:@"UID"]];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             UserModel *userModel = [[UserModel alloc] init];
             userModel.tel = data[@"tel"];
             userModel.username = data[@"username"];
             [_userInfoArray addObject:userModel];
             
             [Single sharedInstance].userName = data[@"username"];
             [Single sharedInstance].userTel = data[@"tel"];
         }
         
         _payGroupOrderTableView.dataArray = _userInfoArray;
         [_payGroupOrderTableView refreshTableView];
         
     } failure:nil];
}

#pragma mark 获取商家提货方式
- (void)getStorePament {
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GetStorePament,midString];
    NSLog(@"获取商家提货方式==%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             // 是否自提 1.是  0否
             if ([data[@"IsDelivery"] boolValue]) {
                 
                 _payGroupOrderTableView.isDelivery = [data[@"IsDelivery"] boolValue];
             }
             
             // 是否送货上门 1.是  0否
             if ([data[@"IsDistribution"] boolValue]) {
                 
                 _payGroupOrderTableView.isDistribution = [data[@"IsDistribution"] boolValue];
                 _payGroupOrderTableView.fullPrice = [NSString stringWithFormat:@"%@",data[@"fullPrice"]];
             }
             
             [_payGroupOrderTableView refreshTableView];
         }
         
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
     }];
}

@end
