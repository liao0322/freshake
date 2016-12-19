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

// View
#import "Utillity.h"
#import "Address.h"
#import "ShopCart.h"

// Model
#import "UserModel.h"
#import "SureOrder.h"
#import "CouponModel.h"

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

@property (nonatomic, copy) UILabel *couponLabel;
@property (nonatomic, copy) UIButton *assortingBtn;
@property (nonatomic, copy) UITableView *payTableView;

@property (nonatomic, copy) NSUserDefaults *userDefaults;
@property (nonatomic, copy) NSMutableArray *goodsArray;     // 商品
@property (nonatomic, copy) NSMutableArray *userInfoArray;  // 用户信息
@property (nonatomic, copy) NSMutableArray *couponArray;    // 优惠劵

@property (nonatomic, copy) NSString *uidString;    // 用户ID
@property (nonatomic, copy) NSString *midString;    // 商家ID
@property (nonatomic, copy) NSString *nameString;   // 昵称
@property (nonatomic, copy) NSString *mobileString; // 手机号
@property (nonatomic, copy) NSString *remarkString; // 备注
@property (nonatomic, copy) NSString *couponsID;    // 优惠券ID
@property (nonatomic, copy) NSString *couponsPrice; // 优惠券金额
@property (nonatomic, copy) NSString *orderNoString;// 订单号
@property (nonatomic, assign) int numberOfCoupons;  // 优惠券数量
@property (nonatomic, assign) BOOL isShowAssorting;
@end

@implementation PaymentViewController

- (void)viewWillAppear:(BOOL)animated{
    [self requestUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _goodsArray = [NSMutableArray array];
    _userInfoArray = [NSMutableArray array];
    _couponArray = [NSMutableArray array];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _uidString = [_userDefaults objectForKey:@"UID"];
    _midString = [_userDefaults objectForKey:@"MID"];
    
    self.navigationItem.titleView = [Utillity customNavToTitle:@"提交订单"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoPush) name:@"zhifubao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoCancel) name:@"zhifubaoCancel" object:nil];
    
    [self initPayTableView];
    [self initAffirmPayment];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 推送方法
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
    
    [_payTableView registerClass:[PaymentCell class] forCellReuseIdentifier:@"PaymentCell"];
    [_payTableView registerClass:[CostTableViewCell class] forCellReuseIdentifier:@"CostTableViewCell"];
}

#pragma mark 确定付款
- (void)initAffirmPayment {
    
    _affirmPayment  = [[AffirmPayment alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 -64, ScreenWidth, 50)];
    _affirmPayment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_affirmPayment];
    
    if (_BuySoon == YES) {
        
        ShopCart *model = [[ShopCart alloc] init];
        model.productName = _goodsName;
        model.salePrice  = [NSString stringWithFormat:@"%.2f",self.goodsPrice];
        model.productNum = [NSNumber numberWithInteger:_goodsNum];
        model.productId = [NSString stringWithFormat:@"%zd",_goodsId];
        [_goodsArray addObject:model];
        
        _price = [model.salePrice floatValue] * [model.productNum floatValue];
        _affirmPayment.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_price-[_couponsPrice floatValue]];
        
        [_payTableView reloadData];
        [self requestDataFromNetOfMyCoupons];
    }
    else [self getGoods];
    
    __weak typeof(self)weakSelf = self;
    _affirmPayment.gopPayment = ^(NSString *urlString) {
        [weakSelf sureBtn];
    };
}

#pragma mark 事件处理
#pragma mark 返回事件
- (void)back {
    [_userDefaults removeObjectForKey:@"userName"];
    [_userDefaults removeObjectForKey:@"userTel"];
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
- (BOOL)couponCountWithCouponType:(CouponType)couponType typeObjectId:(NSArray *)idArray couponPrice:(CGFloat)couponPrice {
    
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
        
        CGFloat goodsPrice;
        for (int i = 0; i < arr.count; i++) {
            ShopCart *model = arr[i];
            goodsPrice += [model.salePrice floatValue] * [model.productNum integerValue];
        }
        
        isAddCoupon = [self calculateCouponMoneyWithPrice:goodsPrice couponPrice:couponPrice];
    }
    else if (couponType == MerchantsCoupon) {
        
        for (int i = 0; i < idArray.count; i++) {
            if ([_midString isEqualToString:idArray[i]]) {
                isAddCoupon = [self calculateCouponMoneyWithPrice:_price couponPrice:couponPrice];
            }
        }
    }
    else isAddCoupon = [self calculateCouponMoneyWithPrice:_price couponPrice:couponPrice];
    return isAddCoupon;
}

#pragma mark 计算优惠劵金额
- (BOOL)calculateCouponMoneyWithPrice:(CGFloat)price couponPrice:(CGFloat)couponPrice {
    
    if (price >= couponPrice) return YES;
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
    
    NSArray *arr = isExist ? @[@"请输入支付密码"] : @[@"请输入登陆密码",@"请输入支付密码",@"请再次输入支付密码"];
    for (int i = 0; i < arr.count; i++)
    {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = arr[i];
            textField.secureTextEntry = YES;
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

#pragma mark - 数据请求
#pragma mark 获取购物车商品
- (void)getGoods {
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,_uidString,_midString];
    NSLog(@"获取购物车商品 = %@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES HUDAddedToView:self.view success:^(id data)
    {
        NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
        
        if ([issuccess isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in data[@"list"]){
                
                ShopCart *model = [[ShopCart alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_goodsArray addObject:model];
                
                _price = 0.0;
                for (int i = 0; i < _goodsArray.count; i++) {
                    ShopCart *model = _goodsArray[i];
                    _price = [model.salePrice floatValue] * [model.productNum floatValue] + _price;
                }
            }
            
            _affirmPayment.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_price];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        [_payTableView reloadData];
        [self requestDataFromNetOfMyCoupons];
        
    } failure:nil];
}

#pragma mark 请求用户信息
- (void)requestUserInfo {
    
    NSString *urlString = [NSString stringWithFormat:GetOrderHost,_uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES HUDAddedToView:self.view success:^(id data)
    {
        NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
        
        if ([issuccess isEqualToString:@"1"]) {
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.tel = data[@"tel"];
            userModel.username = data[@"username"];
            [_userInfoArray addObject:userModel];
        }
        
        [_payTableView reloadData];
        
    } failure:nil];
}

#pragma mark 点击确定付款
- (void)sureBtn {
    
    [self.view endEditing:YES];
    if ([_goodsStoreID isEqualToString:@"0"]) return [Tools myHud:@"自提点已取消，请选择自提点" inView:self.view];
        
    ExpressageCell *cell = [_payTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _nameString = cell.nameText.text;
    _mobileString = cell.mobile.text;
    _remarkString = [Tools isBlankString:cell.remarkText.text] ? @"" : cell.remarkText.text;

    if ([Tools isBlankString:_nameString]) return [Tools myHud:@"请输入提货人名字" inView:self.view];
    if ([Tools isBlankString:_mobileString]) return [Tools myHud:@"请输入提货人电话" inView:self.view];
    if (![Tools isMobileNum:_mobileString]) return [Tools myHud:@"请输入正确的手机号" inView:self.view];
    
    NSString *mid;              // 商家ID
    NSString *awardId;          // 优惠券ID
    NSString *fendianId;        // 取货ID
    NSString *accept_address;   // 取货地址
    NSString *price = [NSString stringWithFormat:@"%f",_price];         // 价格
    NSString *userName = [_userDefaults objectForKey:@"user_name"];     // 会员名称
    NSString *AwardPrice = [Tools isBlankString:_couponsPrice] ? @"" : _couponsPrice;           // 优惠券价格
    NSString *payment_id = [NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent];  // 支付方式

    NSMutableArray *goodsList = [NSMutableArray array]; // 商品列表

    if ([_isCollect isEqualToString:@"1"] || [_isCollect isEqualToString:@"2"])  {
        mid =_midStr;
        fendianId = _goodsStoreID;
        accept_address =_Gaddress;
    }
    else {
        mid = _midString;
        fendianId = [_userDefaults objectForKey:@"merchantsID"];
        accept_address = [_userDefaults objectForKey:@"merchantsAddress"];
    }

    if ([Tools isBlankString:_couponsID] || [_couponsID isEqualToString:@"-1"]) awardId = @"";
    else awardId = _couponsID;

    for (int i = 0; i < _goodsArray.count; i++) {
        
        ShopCart *model = _goodsArray[i];
        NSDictionary *dic = _BuySoon ? @{@"id":model.productId, @"num":model.productNum} : @{@"id":[Utillity string:model.ID]};
        [goodsList addObject:dic];
    }

    NSString *InvoiceTitle = [Utillity string:[(UITextField *)[_payTableView viewWithTag:40] text]];      // 抬头
    NSString *InvoiceContent = [Utillity string:[(UITextField *)[_payTableView viewWithTag:41] text]];    // 抬头内容
    if (([Tools isBlankString:InvoiceTitle] || [Tools isBlankString:InvoiceContent]) && _isShowAssorting == YES) {
        return [Tools myHud:@"请输入发票抬头和内容" inView:self.view];
    }
    
    if (_goodsArray.count != 0) {
        
        // 订单信息
        NSDictionary *listDict = @{@"fendianId":fendianId, @"mid":mid, @"userId":_uidString, @"userName":userName, @"payment_id":payment_id, @"payment_fee":@"0", @"mobile":_mobileString, @"accept_name":_nameString, @"accept_address":accept_address, @"remark":_remarkString, @"order_amount":price, @"point":@"0", @"AwardId":awardId, @"AwardPrice":AwardPrice, @"list":goodsList, @"InvoiceTitle":InvoiceTitle, @"InvoiceContent":InvoiceContent};
        
        NSString *jsonString = [Utillity DataTOjsonString:listDict];
        
        // ADDORDERNUMBER   立即购买生成订单
        // ORDERNUMBER      购物车生成订单
        NSString *urlString = [NSString stringWithFormat:_BuySoon ? ADDORDERNUMBER : ORDERNUMBER, jsonString];
        NSLog(@"%@",urlString);
        
        if ([Single sharedInstance].payMent == WeCartPay && [WXApi isWXAppInstalled] == NO) {
            return [Utillity showAlertViewWithMessage:@"未安装微信客户端,请选择其它支付方式!" viewController:self.navigationController];
        }
        
        [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO HUDAddedToView:self.view success:^(id data)
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
                        [Tools alipayPayRequestWithTradeNO:data[@"order_no"] ProductName:@"老妈买菜" ProductDescription:@"老妈买菜" Amount:data[@"totalPrice"] notify_url:ALIPAYURL];
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
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES HUDAddedToView:self.view success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) [self zhifubaoPush];
        else [Utillity showAlertViewWithMessage:data[@"context"] viewController:self.navigationController];

    } failure:nil];
}

#pragma mark 设置支付密码
- (void)setPayPassword:(NSString *)password loginPassword:(NSString *)loginPassword{
    
    NSString *phone = [_userDefaults objectForKey:@"mobile"];
    NSString *urlString = [NSString stringWithFormat:SetPayPwd,phone,loginPassword,@"1",password];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES HUDAddedToView:self.view success:^(id data)
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
    
    NSString *urlString = [NSString stringWithFormat:IsPayPwd,_uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES HUDAddedToView:self.view success:^(id data)
     {
         [self setPayAlertControllerWithIsExist:[data[@"issuccess"] boolValue]];
         
     } failure:nil];
}

#pragma mark 获取优惠劵
- (void)requestDataFromNetOfMyCoupons {
    
    [_couponArray removeAllObjects];
    
    NSString *midString = [_isCollect isEqualToString:@"1"] ? _midStr : _midString;
    NSString *urlString = [NSString stringWithFormat:@"%@&Sid=%@",[NSString stringWithFormat:GetMyTickList,1,1000,_uidString],midString];
    
    NSLog(@"==我的优惠券===%@",urlString);
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Data isShowLoading:YES HUDAddedToView:self.view success:^(id data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"issuccess"] boolValue]) {
            
            _numberOfCoupons = 0;
            for (NSDictionary *dict in dic[@"List"]) {
                
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 3;
    else if (section == 2) return _isShowAssorting ? 1 : 0;
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
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

                return cell;
            }
        }
        
        if (indexPath.row == 1) {
            
            ExpressageCell *cell = [_payTableView dequeueReusableCellWithIdentifier:@"ExpressageCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([Tools isBlankString:[_userDefaults objectForKey:@"userName"]]) {
                
                if (_userInfoArray.count > 0) {
                    UserModel *model = _userInfoArray[0];
                    [cell setData:model];
                }
                else {
                    
                    cell.nameText.text = [_userDefaults objectForKey:@"nick_name"];
                    cell.mobile.text = [_userDefaults objectForKey:@"mobile"];
                }
            }
            else {
                cell.nameText.text = [_userDefaults objectForKey:@"userName"];
                cell.mobile.text = [_userDefaults objectForKey:@"userTel"];
            }
            
            _nameString = cell.nameText.text;
            _mobileString = cell.mobile.text;
            _remarkString = cell.remarkText.text;
            
            return cell;
        }
        else {
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = @"请选择优惠券";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"0xfe9a04"];
            
            if (_couponLabel == nil) {
                _couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 200 - 30 * isPad, 2,160, 44)];
                _couponLabel.font = [UIFont systemFontOfSize:15];
                _couponLabel.alpha = 0.5;
                _couponLabel.textColor = [UIColor colorWithHexString:@"0xfe9a04"];
                _couponLabel.textAlignment = NSTextAlignmentRight;
            }
            
            if ([_couponsPrice floatValue] < 0) {
                _couponLabel.text = [NSString stringWithFormat:@"您有%d张优惠券可用",_numberOfCoupons];
                if (_numberOfCoupons == 0) _couponLabel.text = @"没有可用的优惠券";
            }

            [cell addSubview:_couponLabel];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SYSTEM_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
            [cell addSubview:line];
            
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
            
            for (int i = 0; i < 2; i++)
            {
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
    else  {
        
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

#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            if ([_goodsStoreID isEqualToString:@"0"]) return 50;
            return 171;
        }
        else if (indexPath.row == 1) return 135;
        else return 50;
    }
    else if (indexPath.section == 1) return 60 + 50 * 3;
    else if (indexPath.section == 2) {
        
        if (_isShowAssorting == YES) return 110;
        else return 0;
    }
    else return 60 * _goodsArray.count + 135;
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
#if 0
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0)
        {
            if ([_isCollect isEqualToString:@"1"])//收藏进入更改自提点
            {
                SiteViewController *_SVC=[[SiteViewController alloc]init];
                _SVC.isCollect=@"1";
                _SVC.CmidStr=_midStr;
                _SVC.siteBlock=^(Map *address)
                {
                    _fendianName=address.Fendianname;
                    _goodsStoreID=address.id;
                    _Gaddress=address.addr;
                    _midStr=address.mid;
                    _pickTime=address.picktime;
                    _pickJuli=address.pickJuli;
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                    LocationCell *cell = (LocationCell *)[_payTableView cellForRowAtIndexPath:path];
                    cell.merchantsLabel.text = _fendianName;
                    cell.timeLabel.text = [NSString stringWithFormat:@"自提时间:  %@",_pickTime];
                    cell.merchantsAddresLabel.text = [NSString stringWithFormat:@"地址:%@",_Gaddress];
                    cell.distance.text = [NSString stringWithFormat:@"%.2f km",[_pickJuli floatValue] / 1000];
                
                    [_payTableView reloadData];
                };
                [self.navigationController pushViewController:_SVC animated:YES];
            }else    //非收藏进入更改自提点
            {
                SiteViewController *_SVC=[[SiteViewController alloc]init];
                _SVC.isCollect=@"2";
                _isCollect = @"2";
                _SVC.CmidStr=_midStr;
                _SVC.siteBlock=^(Map *address)
                {
                    _fendianName=address.Fendianname;
                    _goodsStoreID=address.id;
                    _Gaddress=address.addr;
                    _midStr=address.mid;
                    _pickTime=address.picktime;
                    _pickJuli=address.pickJuli;
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                    LocationCell *cell = (LocationCell *)[_payTableView cellForRowAtIndexPath:path];
                    cell.merchantsLabel.text = _fendianName;
                    cell.timeLabel.text = [NSString stringWithFormat:@"自提时间:  %@",_pickTime];
                    cell.merchantsAddresLabel.text = [NSString stringWithFormat:@"地址:%@",_Gaddress];
                    cell.distance.text = [NSString stringWithFormat:@"%.2f km",[_pickJuli floatValue] / 1000];
                    
                    [_payTableView reloadData];
                };
                [self.navigationController pushViewController:_SVC animated:YES];
            }
        }
        else if (indexPath.row == 2) {
            
            if(_numberOfCoupons > 0) {
                
                MyCouponsViewController *couponVC = [[MyCouponsViewController alloc] init];
                couponVC.couponArray = _couponArray;
                couponVC.isSelectCoupon = YES;
                couponVC.selectCoupon = ^(NSString *priceString) {
                    
                    float totalPrice = _price - [priceString floatValue];
                    _couponsPrice = priceString;
                    
                    if ([priceString floatValue] > 0) {
                        _couponLabel.text = [NSString stringWithFormat:@"已优惠￥%@元  更换",_couponsPrice];
                    }
                    else {
                        _couponLabel.text = [NSString stringWithFormat:@"已选择商品折扣卷  更换"];
                    }
                    
                    _affirmPayment.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice > 0 ? totalPrice : 0];
                    [_payTableView reloadData];
                };
                [self.navigationController pushViewController:couponVC animated:YES];
            }
            else return [Tools myHud:@"没有可用优惠券" inView:[[UIApplication sharedApplication].delegate window]];
        }
    }
#endif
    
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[deliverySiteViewController new] animated:YES];
    }
    
}

#pragma mark 设置段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2) {
        
        _assortingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _assortingBtn.frame = CGRectMake(0, 0, ScreenWidth, 39);
        _assortingBtn.selected = _isShowAssorting;
        
        _assortingBtn.backgroundColor = [UIColor whiteColor];
        [_assortingBtn addTarget:self action:@selector(isShowAssorting:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = _isShowAssorting ? IMAGE(@"选中") : IMAGE(@"发票图标");
        imageView.frame = CGRectMake(20, 12.5, 15, 15);
        imageView.tag = 1100;
        [_assortingBtn addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, ScreenWidth, 39)];
        label.text = @"发票";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"0x63C643"];
        [_assortingBtn addSubview:label];
        
        for (int i = 0; i < 2; i++) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39*i, SYSTEM_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
            [_assortingBtn addSubview:line];
        }
        
        return _assortingBtn;
    }
    
    return nil;
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) return 40;
    return 0.01;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end