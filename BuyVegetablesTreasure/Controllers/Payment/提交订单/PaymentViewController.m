//
//  PaymentViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "PaymentViewController.h"
#import "SelectSiteViewController.h"
#import "MyCouponsViewController.h"
#import "SiteViewController.h"
#import "MyOrderViewController.h"
#import "deliverySiteViewController.h"

// Cell
#import "PaymentCell.h"
#import "CostTableViewCell.h"
#import "CouponCell.h"
#import "RemarksTableViewCell.h"
#import "UserInfoCell.h"
#import "LocationCell.h"
#import "ExpressageCell.h"
#import "HomeAddressCell.h"
#import "SelectDeliverySiteCell.h"
#import "ChooseCouponsCell.h"
#import "BuyerMessageCell.h"

// View
#import "Address.h"
#import "ShopCart.h"
#import "DeliveryTimeView.h"

// Model
#import "UserModel.h"
#import "SureOrder.h"
#import "CouponModel.h"
#import "Map.h"

// 支付宝导入文件
#import "AliOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "AppDelegate+alicallBack.h"

typedef NS_ENUM(NSInteger,CouponType) {
    GoodsCoupon  = 1,
    CategoryCoupon,
    MerchantsCoupon,
    AllCoupon
};


@interface PaymentViewController ()

// 配送时间
@property (nonatomic, strong) DeliveryTimeView *deliveryTimeView;

@property (nonatomic, copy) UILabel *couponLabel;
@property (nonatomic, copy) UIButton *assortingBtn;
@property (nonatomic, copy) UITableView *payTableView;

@property (nonatomic, copy) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSMutableArray *goodsArray;     // 商品
@property (nonatomic, copy) NSMutableArray *userInfoArray;  // 用户信息
@property (nonatomic, copy) NSMutableArray *couponArray;    // 优惠劵
@property (nonatomic, copy) NSMutableArray *userAddressArray;   // 保存用户地址

@property (nonatomic, copy) NSString *uidString;    // 用户ID
@property (nonatomic, copy) NSString *midString;    // 商家ID
@property (nonatomic, copy) NSString *nameString;   // 昵称
@property (nonatomic, copy) NSString *mobileString; // 手机号
@property (nonatomic, copy) NSString *remarkString; // 备注
@property (nonatomic, copy) NSString *couponsID;    // 优惠券ID
@property (nonatomic, copy) NSString *couponsPrice; // 优惠券金额
@property (nonatomic, copy) NSString *orderNoString;// 订单号
@property (nonatomic, copy) NSString *express_fee;
@property (nonatomic, copy) NSString *deliveryTime; // 配送时间
@property (nonatomic, copy) NSString *fullPrice;//满送价格
@property (nonatomic, assign) int numberOfCoupons;  // 优惠券数量
@property (nonatomic, assign) BOOL isShowAssorting;
@property (nonatomic, assign) BOOL isSelectCoupon;
@property (nonatomic, assign) BOOL isDelivery;
@property (nonatomic, assign) BOOL isDistribution;
@property (nonatomic, assign) BOOL isSelectTime;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsArray = [NSMutableArray array];
    _userInfoArray = [NSMutableArray array];
    _couponArray = [NSMutableArray array];
    _userAddressArray = [NSMutableArray array];
    
    [_couponArray removeAllObjects];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _uidString = [_userDefaults objectForKey:@"UID"];
    _midString = [_userDefaults objectForKey:@"MID"];
    
    // 添加推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDate:) name:@"GetDate" object:nil];
    
    [self updateMerchants];
    [self setNav];
    [self addNotificationCenter];
    [self initAffirmPayment];
    [self requestUserInfo];
    [self getStorePament];
}

- (void)getDate:(NSNotification *)obj {
    
    _deliveryTime = [obj object];
    [_payTableView reloadData];
}

#pragma mark 设置导航
- (void)setNav {
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"提交订单"];
    self.title = @"提交订单";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark - 推送
#pragma mark 添加推送
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoPush) name:@"zhifubao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoCancel) name:@"zhifubaoCancel" object:nil];
}

#pragma mark 支付成功
- (void)zhifubaoPush {
    [Single sharedInstance].isRefreshTitle = NO;
    [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
}

#pragma mark 支付取消
- (void)zhifubaoCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 控件初始化
- (void)initPayTableView {
    
    _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50-64) style:UITableViewStyleGrouped];
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    _payTableView.separatorStyle = NO;
    [self.view addSubview:_payTableView];
    
    NSArray *cellArray = @[@"LocationCell",@"ExpressageCell"];
    for (int i = 0; i < cellArray.count; i++) {
        [_payTableView registerNib:[UINib nibWithNibName:cellArray[i] bundle:nil] forCellReuseIdentifier:cellArray[i]];
    }
    
    NSArray *cellClassArray = @[@"BuyerMessageCell",
                                @"ChooseCouponsCell",
                                @"HomeAddressCell",
                                @"PaymentCell",
                                @"CostTableViewCell",
                                @"SelectDeliverySiteCell"];
    
    for (int i = 0; i < cellClassArray.count; i++) {
        [self.payTableView registerClass:[NSClassFromString(cellClassArray[i]) class] forCellReuseIdentifier:cellClassArray[i]];
    }
}

#pragma mark - 选择配送时间
- (void)initDeliveryTimeView {
    
    if (_deliveryTimeView == nil) {
        
        _deliveryTimeView = [DeliveryTimeView new];
        _deliveryTimeView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_deliveryTimeView];
        
        _deliveryTimeView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(ScreenHeight / 3)
        .yIs(ScreenHeight - 64);
        
        WS(weakSelf);
        [_deliveryTimeView setSelectTime:^(NSString *timeString) {
            
            if (![Tools isBlankString:timeString]) {
                
                weakSelf.deliveryTime = timeString;
                [weakSelf.payTableView reloadData];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.deliveryTimeView.sd_layout.yIs(ScreenHeight - 64);
            }];
        }];
    }
    else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (!_isSelectTime) {
                _deliveryTimeView.sd_layout.yIs(ScreenHeight - 64);
            }
            else _deliveryTimeView.sd_layout.yIs(ScreenHeight - (ScreenHeight / 3) - 64);
        }];
    }
}

#pragma mark 确定付款
- (void)initAffirmPayment {
    
    if (_affirmPayment == nil) {
        
        _affirmPayment  = [[AffirmPayment alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 -64, ScreenWidth, 50)];
        _affirmPayment.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_affirmPayment];
        
        if (_BuySoon == YES) {
            
            ShopCart *model = [[ShopCart alloc] init];
            model.productName = _goodsName;
            model.salePrice  = [NSString stringWithFormat:@"%.2f",self.goodsPrice];
            model.productNum = [NSNumber numberWithInteger:_goodsNum];
            model.productId = [NSString stringWithFormat:@"%zd",_goodsId];
//            [_goodsArray addObject:model];
            
            _price = [model.salePrice floatValue] * [model.productNum floatValue];
            _affirmPayment.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_price];
            
            [_goodsArray addObject:model];
            
            [_payTableView reloadData];
            [self requestDataFromNetOfMyCoupons];
        }
        else [self getGoods];
        
        __weak typeof(self)weakSelf = self;
        _affirmPayment.gopPayment = ^(NSString *urlString) {
            [weakSelf sureBtn];
        };
    }
    else {
        
        CGFloat sum = _price - [_couponsPrice floatValue] + [_express_fee floatValue];
        
        if (sum < 0) {
            sum = 0;
        }
        
        [Single sharedInstance].totalPrice = _price;
        _affirmPayment.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
        
    }
}

#pragma mark 事件处理
#pragma mark 返回事件
- (void)back {
    [_userDefaults removeObjectForKey:@"userName"];
    [_userDefaults removeObjectForKey:@"userTel"];
    [Single sharedInstance].isDelivery = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 是否显示发票内容
- (void)isShowAssorting:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    _isShowAssorting = !_isShowAssorting;
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
    [_payTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark 使用优惠劵数量
- (BOOL)couponCountWithCouponType:(CouponType)couponType typeObjectId:(NSArray *)idArray couponPrice:(CGFloat)couponPrice
{
    BOOL isAddCoupon = NO;
    if (couponType == GoodsCoupon || couponType == CategoryCoupon) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < _goodsArray.count; i++) {
            
            ShopCart *model = _goodsArray[i];
            for (int a = 0; a < idArray.count; a++) {
                
                NSString *modelString = couponType == GoodsCoupon ? model.productId : model.categoryId;
                if ([modelString isEqualToString:idArray[a]]) {
                    [arr addObject:model];
                }
            }
        }
        
        float goodsPrice = 0.0;
        for (int i = 0; i < arr.count; i++) {
            ShopCart *model = arr[i];
            goodsPrice += [model.salePrice floatValue] * [model.productNum integerValue];
        }
        
        if (arr.count > 0) {
            isAddCoupon = [self calculateCouponMoneyWithPrice:goodsPrice couponPrice:couponPrice];
        }
    }
    else if (couponType == MerchantsCoupon) {
        
        for (int i = 0; i < idArray.count; i++) {
            if ([_midString isEqualToString:idArray[i]]) {
                isAddCoupon = [self calculateCouponMoneyWithPrice:_price couponPrice:couponPrice];
            }
        }
    }
    else isAddCoupon = [self calculateCouponMoneyWithPrice:_price couponPrice:couponPrice];
    
    NSLog(@"%zd",isAddCoupon);
    return isAddCoupon;
}

#pragma mark 计算优惠劵金额
- (BOOL)calculateCouponMoneyWithPrice:(CGFloat)price couponPrice:(CGFloat)couponPrice {
    
    if (price >= couponPrice) {
    
        NSLog(@"price = %f",price);
        NSLog(@"couponPrice = %f",price);
        
        return YES;
    }
    return NO;
}

#pragma mark 弹出绑定框
- (void)isShowCouponsCell:(UIButton *)btn {
    [_payTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 限制发票字数
- (void)textFieldEditChanged:(UITextField *)textField {
    
    if ([Utillity IsChinese:textField.text]) {
        if (textField.text.length > 30) {
            textField.text = [textField.text substringToIndex:30];
            [Tools myHud:@"不得超过30个字" inView:[[UIApplication sharedApplication].delegate window]];
        }
    }
}

#pragma mark 输入支付密码
- (void)setPayAlertControllerWithIsExist:(BOOL)isExist {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:isExist ? @"余额支付" : @"设置支付密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSArray *arr = isExist ? @[@"请输入支付密码"] : @[@"请输入登录密码",@"请输入支付密码",@"请再次输入支付密码"];
    for (int i = 0; i < arr.count; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = arr[i];
            textField.secureTextEntry = YES;
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        [self zhifubaoCancel];
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

#pragma mark 距离
- (void)distanceWithCoor:(CLLocationCoordinate2D)coor {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    CLLocationCoordinate2D coor1;
    coor1.latitude = [[userDefaults objectForKey:@"xPoint"] floatValue];
    coor1.longitude = [[userDefaults objectForKey:@"yPoint"] floatValue];
    
    BMKMapPoint bdMap1 = BMKMapPointForCoordinate(coor1);
    BMKMapPoint bdMap2 = BMKMapPointForCoordinate(coor);
    
    CLLocationDirection distance = BMKMetersBetweenMapPoints(bdMap1, bdMap2);
    NSLog(@"===配送最大距离%.2f,===相距%.2f",[[userDefaults objectForKey:@"Distance"] floatValue],distance);
    
    if (distance >= [[userDefaults objectForKey:@"Distance"] floatValue]) {
        [Tools myHud:@"您选择的收货地址超出配送范围，请重新选择" inView:self.view];
        
        _affirmPayment.payBtn.enabled = NO;
        _affirmPayment.payBtn.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        
        _affirmPayment.payBtn.enabled = YES;
        _affirmPayment.payBtn.backgroundColor = Color;
    }
}

#pragma mark - 数据请求
#pragma mark 获取购物车商品
- (void)getGoods {
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,_uidString,_midString];
    NSLog(@"获取购物车商品 = %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
        
        if ([issuccess isEqualToString:@"1"]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in data[@"list"]){
                
                ShopCart *model = [[ShopCart alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
            
            for (int i = 0; i < _cartGoods.count; i++) {
                
                ShopCart *cartModel = _cartGoods[i];
                for (int a = 0; a < arr.count; a++) {
                    
                    ShopCart *model = arr[a];
                    if ([cartModel.productId integerValue] == [model.productId integerValue]) {
                        [_goodsArray addObject:model];
                        break;
                    }
                }
            }
    
            _price = 0.0;
            for (int i = 0; i < _goodsArray.count; i++) {
                ShopCart *model = _goodsArray[i];
                _price = [model.salePrice floatValue] * [model.productNum floatValue] + _price;
            }
            
            [self initAffirmPayment];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        [_payTableView reloadData];
        [self requestDataFromNetOfMyCoupons];
        
    } failure:nil];
}

#pragma mark 请求用户信息
- (void)requestUserInfo {
    
    NSString *urlString = [NSString stringWithFormat:GetOrderHost,_uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
        
        if ([issuccess isEqualToString:@"1"]) {
            
            [_userDefaults setObject:data[@"tel"] forKey:@"userTel"];
            [_userDefaults setObject:data[@"username"] forKey:@"userName"];
        }
        
        [_payTableView reloadData];
        
    } failure:nil];
}

#pragma mark 点击确定付款
- (void)sureBtn {
    
    [self.view endEditing:YES];
    
    if ([_goodsStoreID isEqualToString:@"0"]) {
        return [Tools myHud:@"自提点已取消，请选择自提点" inView:self.view];
    }

    if (!_isDelivery && _isDistribution && _userAddressArray.count == 0) {
        return [Tools myHud:@"请选择送货地址" inView:self.view];
    }
    
    if (_userAddressArray.count > 0) {
        
        SiteModel *model = _userAddressArray[0];
        _nameString = model.userName;
        _mobileString = model.Phone;
    }
    else {

        _nameString = [_userDefaults objectForKey:@"userName"];
        _mobileString = [_userDefaults objectForKey:@"userTel"];
        
        if ([Tools isBlankString:_nameString]) return [Tools myHud:@"请输入提货人名字" inView:self.view];
        if ([Tools isBlankString:_mobileString]) return [Tools myHud:@"请输入提货人电话" inView:self.view];
        if (![Tools isMobileNum:_mobileString]) return [Tools myHud:@"请输入正确的手机号" inView:self.view];
    }
    
    _remarkString = [_userDefaults objectForKey:@"userRemark"];
    
    NSString *mid;              // 商家ID
    NSString *fendianId;        // 取货ID
    NSString *accept_address;   // 取货地址

    // 优惠券ID
    NSString *awardId = [Tools isBlankString:_couponsID] ? @"" : _couponsID;
    // 价格
    NSString *price = [NSString stringWithFormat:@"%f",_price];
    // 会员名称
    NSString *userName = [_userDefaults objectForKey:@"user_name"];
    // 配送方式
    NSString *express_id = _userAddressArray.count > 0 ? @"1" : @"0";
    // 优惠券价格
    NSString *AwardPrice = [Tools isBlankString:_couponsPrice] ? @"" : _couponsPrice;
    // 支付方式
    NSString *payment_id = [NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent];
    // 商品列表
    NSMutableArray *goodsList = [NSMutableArray array];

    if (_isCollect)  {
        mid = _midStr;
        fendianId = _goodsStoreID;
        accept_address =_Gaddress;
    }
    else {
        mid = _midString;
        fendianId = [_userDefaults objectForKey:@"merchantsID"];
        accept_address = [_userDefaults objectForKey:@"merchantsAddress"];
    }
    
    if (_userAddressArray.count > 0) {
        
        SiteModel *model = _userAddressArray[0];
        accept_address = [NSString stringWithFormat:@"%@%@%@",model.City,model.Area,model.Address];
    }

    if ([Tools isBlankString:_express_fee]) {
        _express_fee = @"0";
    }
    
    for (int i = 0; i < _goodsArray.count; i++) {
        
        ShopCart *model = _goodsArray[i];
        NSDictionary *dic = _BuySoon ? @{@"id":model.productId, @"num":model.productNum} : @{@"id":[Utillity string:model.ID]};
        [goodsList addObject:dic];
    }

    // 抬头
    NSString *InvoiceTitle = [Utillity string:[(UITextField *)[_payTableView viewWithTag:40] text]];
    // 抬头内容
    NSString *InvoiceContent = [Utillity string:[(UITextField *)[_payTableView viewWithTag:41] text]];
    if (([Tools isBlankString:InvoiceTitle] || [Tools isBlankString:InvoiceContent]) && _isShowAssorting == YES) {
        return [Tools myHud:@"请输入发票抬头和内容" inView:self.view];
    }
    
    if (_goodsArray.count != 0) {
        
        if ([Tools isBlankString:_remarkString]) {
            _remarkString = @"";
        }
        
        if (_userAddressArray.count == 0) {
            _deliveryTime = @"";
        }
        
        // 订单信息
        NSDictionary *listDict = @{@"fendianId":fendianId,
                                   @"mid":mid,
                                   @"userId":_uidString,
                                   @"userName":userName,
                                   @"payment_id":payment_id,
                                   @"payment_fee":@"0",
                                   @"mobile":_mobileString,
                                   @"accept_name":_nameString,
                                   @"accept_address":accept_address,
                                   @"remark":_remarkString,
                                   @"order_amount":price,
                                   @"point":@"0",
                                   @"AwardId":awardId,
                                   @"AwardPrice":AwardPrice,
                                   @"list":goodsList,
                                   @"InvoiceTitle":InvoiceTitle,
                                   @"InvoiceContent":InvoiceContent,
                                   @"express_fee":_express_fee,
                                   @"express_id":express_id,
                                   @"DeliveryTime":_deliveryTime};
        
        NSString *jsonString = [Utillity DataTOjsonString:listDict];
        
        // ADDORDERNUMBER   立即购买生成订单
        // ORDERNUMBER      购物车生成订单
        NSString *urlString = [NSString stringWithFormat:_BuySoon ? ADDORDERNUMBER : ORDERNUMBER, jsonString];
        NSLog(@"%@",urlString);
        
        if ([Single sharedInstance].payMent == WeCartPay ) {
            
            if (![WXApi isWXAppSupportApi] && ![WXApi isWXAppInstalled]) {
                
                return [Utillity showAlertViewWithMessage:@"微信未安装或微信版本太低" viewController:self.navigationController];
            }
        }
        
        [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
        {
            NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
            
            if ([issuccess isEqualToString:@"0"]) {
                return [Tools myHud:data[@"context"] inView:self.view];
            }
            else if ([data[@"totalPrice"] floatValue] <= 0) {
                [self.navigationController pushViewController:[MyOrderViewController new] animated:YES];
            }
            else if ([issuccess isEqualToString:@"1"]) {
                
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
            
        } failure:nil];
    }
}

#pragma mark 使用余额支付
- (void)requstAmountPayWithPassword:(NSString *)password {

    NSString *urlString = [NSString stringWithFormat:AmountPay,_orderNoString,password];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) [self zhifubaoPush];
        else [Utillity showAlertViewWithMessage:data[@"context"] viewController:self.navigationController];

    } failure:nil];
}

#pragma mark 设置支付密码
- (void)setPayPassword:(NSString *)password
         loginPassword:(NSString *)loginPassword
{
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

#pragma mark 更新商家
- (void)updateMerchants {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float latitude = [userDefaults doubleForKey:@"positioningLatitude"];
    float longitude = [userDefaults doubleForKey:@"positioningLongitude"];
    
    NSString *urlString = [NSString stringWithFormat:MAPURL,latitude,longitude];
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in data[@"list"]) {
            
            Map *mapModel = [[Map alloc] init];
            [mapModel setValuesForKeysWithDictionary:dic];
            [arr addObject:mapModel];
        }
        
        NSString *fendianname = [userDefaults objectForKey:@"Fendianname"];
        for (Map *mapModel in arr) {
            
            if ([fendianname isEqualToString:mapModel.Fendianname]) {
                [userDefaults setObject:mapModel.DistancePrice forKey:@"DistancePrice"];
            }
        }
        
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

#pragma mark 获取优惠劵
- (void)requestDataFromNetOfMyCoupons {
    
    [_couponArray removeAllObjects];
    
    NSString *midString = _isCollect ? _midStr : _midString;
    NSString *urlString = [NSString stringWithFormat:@"%@&Sid=%@",[NSString stringWithFormat:GetMyTickList,1,1000,_uidString],midString];
    NSLog(@"==我的优惠券===%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            _numberOfCoupons = 0;
            for (NSDictionary *dict in data[@"List"]) {
                
                if (![dict[@"hasLingQu"] boolValue] && [dict[@"IsExpileDate"] boolValue]) {
                    
                    CouponModel *model = [[CouponModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    BOOL isAddCoupon;
                    if ([model.typeId integerValue] == 1) {
    
                        isAddCoupon = [self couponCountWithCouponType:GoodsCoupon typeObjectId:[model.typeObjectId componentsSeparatedByString:@","] couponPrice:[model.consumeMoney integerValue]];
                    }
                    else {

                        isAddCoupon = [self couponCountWithCouponType:[model.type integerValue] typeObjectId:[model.typeObjectId componentsSeparatedByString:@","] couponPrice:[model.consumeMoney integerValue]];
                    }
                    
                    if (isAddCoupon) {
                        [_couponArray addObject:model];
                    }
                    
                    _numberOfCoupons += isAddCoupon;
                }
            }
            
            if (_numberOfCoupons == 0) _couponLabel.text = @"没有可用的优惠券";
            else _couponLabel.text = [NSString stringWithFormat:@"您有%d张优惠券可用",_numberOfCoupons];
        }
        
    } failure:nil];
}

#pragma mark 获取商家提货方式
- (void)getStorePament {
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:GetStorePament,midString];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Json success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            
            // 是否自提 1.是  0否
            if ([data[@"IsDelivery"] boolValue]) {
                
                _isDelivery = [data[@"IsDelivery"] boolValue];
            }
            
            // 是否送货上门 1.是  0否
            if ([data[@"IsDistribution"] boolValue]) {
                
                _isDistribution = [data[@"IsDistribution"] boolValue];
                
                _fullPrice = [NSString stringWithFormat:@"%@",data[@"fullPrice"]];
            }
            
            
            
            [self initPayTableView];
            [self initDeliveryTimeView];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 && _userAddressArray.count == 0 && (!_isDistribution || _isDelivery)) {
        return 3;
    }
    else if (section == 0 && _isDistribution) {
        return 4;
    }
    else if (section == 2) {
        return _isShowAssorting ? 1 : 0;
    }
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 3) {
            
            BuyerMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerMessageCell"];
            return cell;
        }
        
        if (indexPath.row == 0) {
            
            // 商家信息
            if ((_isDistribution && !_isDelivery) || _userAddressArray.count > 0) {
                
                if (_userAddressArray.count > 0) {
                    
                    HomeAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeAddressCell"];
                    [cell setData:_userAddressArray[0]];
                    cell.selectionStyle = NO;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                else {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                        
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
                        line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
                        [cell addSubview:line];
                    }
                    
                    cell.selectionStyle = UITableViewCellStyleDefault;
                    cell.textLabel.text = @"请选择收货地址";
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    return cell;
                }
            }
            else {
                
                if ([_goodsStoreID isEqualToString:@"0"]) {
                    
                    UITableViewCell *cell = [[UITableViewCell alloc]init];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"请选择自提点";
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"0xfe9a04"];
                    return cell;
                }
                else {
                    
                    LocationCell *cell = [_payTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setStoreInfo];
                    
                    if (_fendianName) {
                        
                        cell.merchantsLabel.text = _fendianName;
                        cell.timeLabel.text = [NSString stringWithFormat:@"自提时间:  %@",_pickTime];
                        cell.merchantsAddresLabel.text = [NSString stringWithFormat:@"地址:%@",_Gaddress];
                        cell.distance.text = [NSString stringWithFormat:@"%.2f km",[_pickJuli floatValue] / 1000];
                    }
                    
                    return cell;
                }
            }
            
        }
        // 用户信息
        if (indexPath.row == 1 && (!_isDistribution || _isDelivery) && _userAddressArray.count == 0) {
            
            ExpressageCell *cell = [_payTableView dequeueReusableCellWithIdentifier:@"ExpressageCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.editTextField = ^{};
            cell.nameText.text = [_userDefaults objectForKey:@"userName"];
            cell.mobile.text = [_userDefaults objectForKey:@"userTel"];
            
            return cell;
        }
        // 优惠券
        else {
            
            BOOL isDelivery = YES;
            
            if (_userAddressArray.count == 0 && (!_isDistribution || _isDelivery)) {
                isDelivery = NO;
            }
            
            // 优惠券
            ChooseCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCouponsCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleString = @"请选择优惠券";
            cell.couponsNumber = _numberOfCoupons;
            _couponLabel = cell.couponsNumberLabel;
            
            NSLog(@"%zd",indexPath.row);
            if (indexPath.row == 2 && _userAddressArray.count > 0) {

                if (_couponLabel == nil) {
                    
                    cell.couponsNumber = _numberOfCoupons;
                    _couponLabel = cell.couponsNumberLabel;
                }
            }
            else if (_userAddressArray.count != 0){
                
                // 配送时间
                cell.titleString = @"请选择配送时间";
                cell.couponsNumberLabel.text = _deliveryTime;
            }
            
            return cell;

        }
    }
    else if (indexPath.section == 1){
        
        PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = NO;
            
            for (int i = 0; i < 2; i++) {
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + 50 * i, ScreenWidth - 20, 40)];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.tag = i + 40;
                textField.placeholder = i == 0 ? @"发票抬头" : @"发票内容";
                [cell addSubview:textField];
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 115 * i-5, SYSTEM_WIDTH, 1)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
                [cell addSubview:line];
                
                [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
            }
        }
        
        return cell;
    }
    else {
        
        CostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setArray:_goodsArray];
        
        if ([_couponsPrice floatValue] > 0) {
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_couponsPrice floatValue]];
        }
        else cell.priceLabel.text = @"￥0.00";
        return cell;
    }
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isDelivery && !_isDistribution) {
        return [Tools myHud:@"商家暂未开启配送和自提功能" inView:self.view];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            SiteViewController *siteVC = [[SiteViewController alloc]init];
            siteVC.midStr = _isCollect ? _midStr : [_userDefaults objectForKey:@"merchantsID"];
            siteVC.isCollect = _isCollect;
            siteVC.isDelivery = _isDelivery;
            siteVC.isDistribution = _isDistribution;
            [self.navigationController pushViewController:siteVC animated:YES];
            
            siteVC.midSite = ^(Map *mapArray) {
                
                [_userAddressArray removeAllObjects];
                
                _fendianName = mapArray.Fendianname;
                _pickTime = mapArray.picktime;
                _pickJuli = mapArray.pickJuli;
                _goodsStoreID = mapArray.id;
                _Gaddress = mapArray.addr;
                _midStr = mapArray.mid;
                
                _express_fee = @"0.00";
                //                _affirmPayment.payBtn.enabled = YES;
                //                _affirmPayment.payBtn.backgroundColor = [UIColor clearColor];
                [self initAffirmPayment];
                
                [Single sharedInstance].isDelivery = NO;
                
                [_userAddressArray removeAllObjects];
                [_payTableView reloadData];
            };
            
            siteVC.userAddress = ^(SiteModel *userAddressArray) {
                
                [_userAddressArray removeAllObjects];
                
                _express_fee = [_userDefaults objectForKey:@"DistancePrice"];
                if ([_fullPrice floatValue] < _price) {
                    _express_fee = @"0.00";
                }
                
                [self initAffirmPayment];
                
                CLLocationCoordinate2D coor;
                coor.latitude = [userAddressArray.X floatValue];
                coor.longitude = [userAddressArray.Y floatValue];
                [self distanceWithCoor:coor];
                
                [Single sharedInstance].isDelivery = YES;
                
                [_userAddressArray addObject:userAddressArray];
                [_payTableView reloadData];
            };
        }
        // 优惠券
        else if (indexPath.row == 2) {
            
            if (_numberOfCoupons > 0) {
                
                MyCouponsViewController *couponVC = [[MyCouponsViewController alloc] init];
                couponVC.couponArray = _couponArray;
                couponVC.isSelectCoupon = YES;
                couponVC.selectCoupon = ^(NSString *priceString, NSString *idString, BOOL isSelect) {
                    
                    _isSelectCoupon = isSelect;
                    
                    if ([priceString floatValue] > 0) {
                        _couponLabel.text = [NSString stringWithFormat:@"已优惠￥%@元  更换",priceString];
                    }
                    
                    _couponsPrice = priceString;
                    _couponsID = idString;
                    
                    [self initAffirmPayment];
                    [_payTableView reloadData];
                };
                
                couponVC.selectGoodsCoupon = ^(NSString *priceString, NSString *idString, BOOL isSelect, NSInteger index) {
                    
                    CouponModel *couponModel = _couponArray[index];
                    
                    _isSelectCoupon = isSelect;
                    _couponsID = idString;
                    _couponLabel.text = [NSString stringWithFormat:@"已选择%@ 更换",couponModel.TickName];
                    
                    NSArray *idArray = [couponModel.typeObjectId componentsSeparatedByString:@","];
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    for (int i = 0; i < _goodsArray.count; i++) {
                        
                        ShopCart *model = _goodsArray[i];
                        for (int a = 0; a < idArray.count; a++) {
                            
                            NSString *modelString = model.productId;
                            if ([modelString isEqualToString:idArray[a]]) {
                                [arr addObject:model];
                            }
                        }
                    }
                    
                    ShopCart *model = arr[0];
                    _couponsPrice = [NSString stringWithFormat:@"%f",[model.salePrice floatValue] * [priceString integerValue]];
                    
                    [self initAffirmPayment];
                    [_payTableView reloadData];
                };
                
                [self.navigationController pushViewController:couponVC animated:YES];
            }
            else return [Tools myHud:@"没有可用优惠券" inView:[[UIApplication sharedApplication].delegate window]];
        }
        // 选择时间
        else if (indexPath.row == 1 && _userAddressArray.count > 0) {
            
            _isSelectTime = !_isSelectTime;
            [self initDeliveryTimeView];
        }
    }
}

#pragma mark 设置段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2) {
        
        _assortingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _assortingBtn.frame = CGRectMake(0, 0, ScreenWidth, 50);
        _assortingBtn.selected = _isShowAssorting;
        
        _assortingBtn.backgroundColor = [UIColor whiteColor];
        [_assortingBtn addTarget:self action:@selector(isShowAssorting:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = _isShowAssorting ? IMAGE(@"发票选中") : IMAGE(@"发票图标");
        imageView.frame = CGRectMake(17.5, 17.5, 15, 15);
        imageView.tag = 1100;
        [_assortingBtn addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, ScreenWidth, 50)];
        label.text = @"发票";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = Color;
        [_assortingBtn addSubview:label];
        
        for (int i = 0; i < 2; i++) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * i, SYSTEM_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
            [_assortingBtn addSubview:line];
        }
        
        return _assortingBtn;
    }
    
    return nil;
}

#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if ((!_isDistribution || _isDelivery) && _userAddressArray.count == 0) {
            
            if (indexPath.row == 0) {
                if ([_goodsStoreID isEqualToString:@"0"]) return 50;
                return 171;
            }
            else if (indexPath.row == 1) return 135;
            else return 45;
        }
        else {
            
            if (indexPath.row == 0) {
                
                if (_userAddressArray.count > 0) {
                    return 100;
                }
                else {
                    return 50;
                }
            }
            else return 45;
        }
    }
    else if (indexPath.section == 1) return 50 + 50 * 3;
    else if (indexPath.section == 2) {
        
        if (_isShowAssorting == YES) return 110;
        else return 0;
    }
    else return 50 * _goodsArray.count + 150;
}

#pragma mark 设置段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) return 50;
    return 0.01;
}

#pragma mark 设置段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
