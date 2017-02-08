//
//  SubmitOrderView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/19.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

// Controller
#import "SiteViewController.h"
#import "MyCouponsViewController.h"
#import "ChooseAddressViewController.h"
// View
#import "SubmitOrderView.h"
#import "OrderTotalView.h"
#import "DeliveryTimeView.h"
// Cell
#import "CostCell.h"
#import "PaymentTypeCell.h"
#import "CustomerInfoCell.h"
#import "PointDeliveryCell.h"
#import "PickupInfoCell.h"
#import "TimeOrCouponCell.h"
#import "RemarkCell.h"
// Model
#import "CouponModel.h"

@interface SubmitOrderView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/// 是否需要发票
@property (nonatomic, assign) BOOL isInvoice;
/// 是否选择了地址
@property (nonatomic, assign) BOOL isChooseAddress;
/// 是否配送
@property (nonatomic, assign) BOOL isDistribution;
/// 是否选择时间
@property (nonatomic, assign) BOOL isSelectTime;
/// 支付Id
@property (nonatomic, assign) NSInteger payId;
/// 优惠券
@property (nonatomic, strong) NSString *couponString;
/// 优惠券ID
@property (nonatomic, strong) NSString *couponIdString;
/// 优惠价格
@property (nonatomic, assign) CGFloat couponPrice;
/// 配送时间
@property (nonatomic, strong) NSString *deliveryTime;
/// 订单价格
@property (nonatomic, strong) OrderTotalView *orderTotalView;
/// 配送时间
@property (nonatomic, strong) DeliveryTimeView *deliveryTimeView;
/// 积分按钮
@property (nonatomic, strong) UISwitch *integralSwitch;
/// 可用积分
@property (nonatomic, assign) CGFloat availableIntegral;
/// 是否选择优惠券
@property (nonatomic, assign) BOOL isSelectCoupon;

@end

@implementation SubmitOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.payId = 2;
        self.deliveryTime = @"";
        self.couponIdString = @"";
        self.couponString = @"没有可用的优惠券";
        [self initIntegralSwitch];
        [self initOrderTotalView];
        [self initTableView];
        //[self initDeliveryTimeView];
    }
    
    return self;
}

#pragma mark - 控件初始化
// 初始化tableView
- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[CostCell class] forCellReuseIdentifier:@"CostCell"];
    [_tableView registerClass:[PaymentTypeCell class] forCellReuseIdentifier:@"PaymentTypeCell"];
    [_tableView registerClass:[PointDeliveryCell class] forCellReuseIdentifier:@"PointDeliveryCell"];
    [_tableView registerClass:[CustomerInfoCell class] forCellReuseIdentifier:@"CustomerInfoCell"];
    [_tableView registerClass:[PickupInfoCell class] forCellReuseIdentifier:@"PickupInfoCell"];
    [_tableView registerClass:[TimeOrCouponCell class] forCellReuseIdentifier:@"TimeOrCouponCell"];
    [_tableView registerClass:[RemarkCell class] forCellReuseIdentifier:@"RemarkCell"];
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self addSubview:_tableView];
    
    _tableView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomSpaceToView(self.orderTotalView, 0);
}

- (void)initIntegralSwitch {
    
    self.integralSwitch = [UISwitch new];
    [self.integralSwitch addTarget:self
                            action:@selector(switchChange:)
                  forControlEvents:UIControlEventValueChanged];
}

// 初始化订单总价View
- (void)initOrderTotalView {
    
    self.orderTotalView = [OrderTotalView new];
    [self addSubview:self.orderTotalView];
    
    WS(weakSelf);
    [self.orderTotalView setPayInfo:^{
        
        // 判断是否选择地址
        if (!weakSelf.isChooseAddress) {
            return [Tools myHud:@"请选择收（取）货地址"];
        }
        else {
            
            if (weakSelf.isInvoice) {
                
                if (isBlankString([Single sharedInstance].invoiceTitle)) {
                    return [Tools myHud:@"请输入发票抬头"];
                }
                else if (isBlankString([Single sharedInstance].invoiceContent)) {
                    return [Tools myHud:@"请输入发票内容"];
                }
            }
            
            // 判断是否提货点
            if (!weakSelf.isDistribution) {
                
                if (isBlankString([Single sharedInstance].userName)) {
                    return [Tools myHud:@"请填写提货人"];
                }
                else if (isBlankString([Single sharedInstance].userTel)) {
                    return [Tools myHud:@"请填写联系方式"];
                }
                else if (![Tools isMobileNum:[Single sharedInstance].userTel]) {
                    return [Tools myHud:@"请输入正确的手机号"];
                }
            }
            else if ([Single sharedInstance].isdeliverTime) {
                
                if (isBlankString(weakSelf.deliveryTime)) {
                    return [Tools myHud:@"请输入配送时间"];
                }
            }
        }
        
        weakSelf.payInfo([weakSelf getPayInfo]);
    }];
    
    self.orderTotalView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(45);
}

// 配送时间View
- (void)initDeliveryTimeView {
    
    if (_deliveryTimeView == nil) {
        
        _deliveryTimeView = [DeliveryTimeView new];
        _deliveryTimeView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_deliveryTimeView];
        
        _deliveryTimeView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(256)
        .yIs(ScreenHeight - 64);
        
        WS(weakSelf);
        [_deliveryTimeView setSelectTime:^(NSString *timeString) {
            
            weakSelf.isSelectTime = NO;
            
            if (![Tools isBlankString:timeString]) {
                
                weakSelf.deliveryTime = timeString;
                [weakSelf.tableView reloadData];
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
            else _deliveryTimeView.sd_layout.yIs(ScreenHeight - 256 - 64);
        }];
    }
}

#pragma mark - 事件处理
// 获取订单信息
- (NSDictionary *)getPayInfo {
    
    // 商品列表
    NSMutableArray *goodsList = [NSMutableArray array];
    for (int i = 0; i < self.goodsArray.count; i++) {
        
        ShopCart *model = self.goodsArray[i];
        NSDictionary *dic = _buySoon ? @{@"id":model.productId, @"num":model.productNum} : @{@"id":model.ID};
        [goodsList addObject:dic];
    }
    
    // 分店ID
    NSString *fendianId = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsID"];
    // 地址
    NSString *accept_address = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsAddress"];
    // 用户昵称
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    // 商家号
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    // 用户ID
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    
    // 发票抬头
    NSString *invoiceTitle = [Single sharedInstance].invoiceTitle;
    // 发票内容
    NSString *invoiceContent = [Single sharedInstance].invoiceContent;
    
    // 手机号
    NSString *mobileString = [Single sharedInstance].userTel;
    // 购买人
    NSString *nameString = [Single sharedInstance].userName;
    // 备注
    NSString *remarkString = [Single sharedInstance].remark;
    
    // 支付方式
    NSString *payment_id = [NSString stringWithFormat:@"%zd", [Single sharedInstance].payMent];;
    // 价格
    NSString *price = [NSString stringWithFormat:@"%.2f", self.totalPrice];
    // 优惠券优惠价格
    NSString *AwardPrice = [NSString stringWithFormat:@"%.2f",self.couponPrice];
    
    // 配送费用
    NSString *express_fee = @"0";
    // 配送方式
    NSString *express_id = @"0";
    // 配送时间
    NSString *deliveryTime = @"";
    
    // 积分
    NSString *usePoint = [NSString stringWithFormat:@"%.0f", self.integralSwitch.on * self.availableIntegral];
    NSLog(@"积分 = %@",usePoint);

    // 判断是否配送
    if (self.isDistribution) {
        
        SiteModel *model = self.model;
        mobileString = model.Phone;
        nameString = model.userName;
        express_id = @"1";
        express_fee = [NSString stringWithFormat:@"%.2f",[Single sharedInstance].freight];
        accept_address = [NSString stringWithFormat:@"%@ %@ %@",model.City, model.Area, model.Address];
        deliveryTime = self.deliveryTime;
    }
    else {
        
        Map *mapModel = self.model;
        fendianId = mapModel.id;
        accept_address = mapModel.addr;
    }
    
    if (isBlankString(userName)) {
        userName = @"";
    }

    // 订单信息
    NSDictionary *listDict = @{@"fendianId":fendianId,
                               @"mid":midString,
                               @"userId":userId,
                               @"userName":userName,
                               @"payment_id":payment_id,
                               @"payment_fee":@"0",
                               @"mobile":mobileString,
                               @"accept_name":nameString,
                               @"accept_address":accept_address,
                               @"remark":remarkString,
                               @"order_amount":price,
                               @"point":@"0",
                               @"AwardId":self.couponIdString,
                               @"AwardPrice":AwardPrice,
                               @"list":goodsList,
                               @"InvoiceTitle":invoiceTitle,
                               @"InvoiceContent":invoiceContent,
                               @"express_fee":express_fee,
                               @"express_id":express_id,
                               @"DeliveryTime":deliveryTime,
                               @"usePoint":usePoint};
    
    return listDict;
}

- (void)switchChange:(UISwitch *)integralSwitch {

    // 价格
    [self.orderTotalView setOrderTotalPrice:self.totalPrice - (integralSwitch.on * self.availableIntegral / 100.0f)
                                couponPrice:self.couponPrice
                                    freight:self.isDistribution * [Single sharedInstance].freight];
    [self.tableView reloadData];
}

// 获取模型
- (void)setModel:(id)model {

    _model = model;
    self.orderTotalView.payBtn.enabled = YES;
    self.orderTotalView.payBtn.backgroundColor = Color;
    self.isChooseAddress = YES;

    if ([model isKindOfClass:[SiteModel class]]) {

        self.isDistribution = YES;
        
        // 计算距离
        SiteModel *siteModel = model;
        CLLocationCoordinate2D coor;
        coor.latitude = [siteModel.X doubleValue];
        coor.longitude = [siteModel.Y doubleValue];
        [self distanceWithCoor:coor];
    }
    else {
        
        self.isDistribution = NO;
    }
    
    [self.tableView reloadData];
}

// 优惠券数量
- (void)setNumberOfCoupons:(NSInteger)numberOfCoupons {
    _numberOfCoupons = numberOfCoupons;
    if (numberOfCoupons == 0) {
        self.couponString = @"没有可用的优惠券";
    }
    else {
        self.couponString = [NSString stringWithFormat:@"您有%zd张优惠券可用",numberOfCoupons];
    }
    [_tableView reloadData];
}

// 商品数组
- (void)setGoodsArray:(NSArray *)goodsArray {
    _goodsArray = goodsArray;
    [_tableView reloadData];
}

// 总价
- (void)setTotalPrice:(CGFloat)totalPrice {

    _totalPrice = totalPrice;
    
    self.availableIntegral = [self.orderTotalView setOrderTotalPrice:self.totalPrice - (self.integralSwitch.on * self.availableIntegral / 100.0f)
                                                         couponPrice:self.couponPrice
                                                             freight:self.isDistribution * [Single sharedInstance].freight];
     
    /*
    self.totalPrice = [self.orderTotalView setOrderTotalPrice:self.totalPrice - (self.integralSwitch.on * self.availableIntegral / 100.0f)
                                                         couponPrice:self.couponPrice
                                                             freight:self.isDistribution * [Single sharedInstance].freight];
     */
}

// 积分
- (void)setIntegral:(NSInteger)integral {

    _integral = integral;
    self.availableIntegral = integral;
}

- (void)setAvailableIntegral:(CGFloat)availableIntegral {
    
    // 总价
    CGFloat totalPrice = self.totalPrice - self.couponPrice + self.isDistribution * [Single sharedInstance].freight;
    
    // 判断金额是否超出可用积分
    if ((float)self.integral / 100 > totalPrice) {
        _availableIntegral = totalPrice * 100;
    }
    else _availableIntegral = self.integral;
    
    [self.orderTotalView setOrderTotalPrice:self.totalPrice - (self.integralSwitch.on * (float)self.availableIntegral / 100)
                                couponPrice:self.couponPrice
                                    freight:self.isDistribution * [Single sharedInstance].freight];
    
    [self.tableView reloadData];
}

// 编辑文本框
- (void)textFieldEditChanged:(UITextField *)textField {
    
    if (textField.tag == 41) {
        [Single sharedInstance].invoiceTitle = textField.text;
    }
    else {
        [Single sharedInstance].invoiceContent = textField.text;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 收取货
    if (section == 0) {
        
        if (_isChooseAddress) {
            
            NSInteger row = 5 + self.isDistribution;
            
            if (self.isDistribution) row -= ![Single sharedInstance].isdeliverTime;
            
            return row;
        }
        else {
            
            return 2;
        }
    }
    // 付款方式
    else if (section == 1) {
        return 4;
    }
    // 发票
    else if (section == 2) {
        return _isInvoice * 2 + 1;
    }
    // 商品详情
    else if (section == 3) {
        return _goodsArray.count + 2 + self.isSelectCoupon + self.integralSwitch.on;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 标题
    if (indexPath.row == 0) {
        
        NSArray *imgs = @[@"TakingGoods",@"Payment",@"Invoice",@"GoodsDetailsIcon"];
        NSArray *titles = @[@"收（取）货地址", @"选择支付方式",@"发票",@"商品详情"];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
        }
        
        cell.layer.borderColor = LineColor.CGColor;
        cell.layer.borderWidth = 0.5;
        cell.textLabel.text = titles[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = Color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        if (indexPath.section == 2) {
            
            cell.imageView.image = IMAGE(_isInvoice ? @"Invoice_select" : @"Invoice");
        }
        else {
            
            cell.imageView.image = IMAGE(imgs[indexPath.section]);
        }
        
        return cell;
    }
    // 收取货地址
    else if (indexPath.section == 0) {
        
        // 未选择地址
        if (!_isChooseAddress) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.borderColor = LineColor.CGColor;
            cell.layer.borderWidth = 0.5;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"请选择收货地址";
            
            return cell;
        }
        // 选中地址
        else {
            
            // 配送
            if (_isDistribution) {
                
                if (indexPath.row == 1) {
                    
                    PickupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickupInfoCell"];
                    cell.model = self.model;
                    return cell;
                }
                else if (indexPath.row == 2 && [Single sharedInstance].isdeliverTime) {
                    
                    TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
                    cell.layer.borderWidth = 0;
                    [cell setTimeString:self.deliveryTime];
                    return cell;
                }
                else if (indexPath.row == 3 - ![Single sharedInstance].isdeliverTime) {
                    
                    TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
                    [cell setCouponString:self.couponString];
                    return cell;
                }
                else if (indexPath.row == 4 - ![Single sharedInstance].isdeliverTime) {
                    
                    TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
                    cell.textLabel.text = [NSString stringWithFormat:@"可用%.0f积分抵用%.2f元", self.availableIntegral, (float)self.availableIntegral / 100];
                    cell.accessoryView = self.integralSwitch;
                    return cell;
                }
                else {
                    
                    RemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkCell"];
                    return cell;
                }
            }
            // 自提
            else {
                
                if (indexPath.row == 1) {
                    
                    PointDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointDeliveryCell"];
                    cell.model = self.model;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                else if (indexPath.row == 2) {
                    
                    CustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerInfoCell"];
                    [cell setData];
                    return cell;
                }
                else if (indexPath.row == 3) {
                    
                    TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
                    cell.layer.borderWidth = 0;
                    [cell setCouponString:self.couponString];
                    return cell;
                }
                else if (indexPath.row == 4) {
                    
                    TimeOrCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeOrCouponCell"];
                    cell.textLabel.text = [NSString stringWithFormat:@"可用%.0f积分抵用%.2f元", self.availableIntegral, (float)self.availableIntegral / 100];
                    cell.accessoryView = self.integralSwitch;
                    return cell;
                }
            }
        }
    }
    // 支付方式
    else if (indexPath.section == 1) {
        
        PaymentTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTypeCell"];
        cell.currentIndex = indexPath.row - 1;
        cell.payId = _payId;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    // 发票
    else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvoiceCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [UITextField new];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = 40 + indexPath.row;
        textField.placeholder = indexPath.row == 1 ? @"发票抬头" : @"发票内容";
        textField.font = [UIFont systemFontOfSize:14];
        [textField addTarget:self
                      action:@selector(textFieldEditChanged:)
            forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:textField];
        
        if (indexPath.row == 1) {
            textField.text = [Single sharedInstance].invoiceTitle;
        }
        else {
            textField.text = [Single sharedInstance].invoiceContent;
        }
        
        textField.sd_layout
        .leftSpaceToView(cell, 15)
        .rightSpaceToView(cell, 15)
        .topSpaceToView(cell, 5)
        .bottomSpaceToView(cell, 5);
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    // 商品详情
    else if (indexPath.section == 3) {
        
        CostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostCell"];
        
        if (indexPath.row > _goodsArray.count) {
            
            if (indexPath.row == _goodsArray.count + 1) {
                
                cell.textLabel.text = @"运费";
                if (_isDistribution) {
                    
                    cell.freight = [Single sharedInstance].freight;
                }
                else cell.freight = 0;
            }
            else if (indexPath.row == _goodsArray.count + 2 && self.isSelectCoupon) {
             
                cell.textLabel.text = @"使用优惠券";
                cell.couponPrice = self.couponPrice;
            }
            else {
                
                cell.textLabel.text = @"积分抵扣";
                cell.couponPrice = self.availableIntegral / 100;
            }
        }
        else {
            [cell setGoodsModel:_goodsArray[indexPath.row - 1]];
        }
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row > 0) {
        
        // 未选择地址
        if (!_isChooseAddress) {
            return 45;
        }
        // 自提
        else if (!_isDistribution) {
            
            if (indexPath.row == 1) {
                
                return [self.tableView cellHeightForIndexPath:indexPath
                                                        model:self.model
                                                      keyPath:@"model"
                                                    cellClass:[PointDeliveryCell class]
                                             contentViewWidth:ScreenWidth];
            }
            else if (indexPath.row == 2) {
                
                return 135;
            }
        }
        // 配送
        else {
            
            if (indexPath.row == 1) {
                
                return [self.tableView cellHeightForIndexPath:indexPath
                                                        model:self.model
                                                      keyPath:@"model"
                                                    cellClass:[PickupInfoCell class]
                                             contentViewWidth:ScreenWidth];
            }
        }
    }
    
    return 45;
}

// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

// 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 发票
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        _isInvoice = !_isInvoice;
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // 选择支付方式
    else if (indexPath.section == 1 && indexPath.row > 0) {
        
        _payId = indexPath.row;
        [tableView reloadData];
    }
    else if (indexPath.section == 0) {
     
        // 选地址
        if (indexPath.row == 1) {
            
            ChooseAddressViewController *chooseAddressVC = [ChooseAddressViewController new];
            chooseAddressVC.deliveryStatus = self.deliveryStatus;
            chooseAddressVC.distributionStatus = self.distributionStatus;
            [chooseAddressVC setAddressBlock:^(id model, BOOL deliveryStatus) {
                
                [Single sharedInstance].isDelivery = deliveryStatus;
                self.model = model;
                
                // 价格
                self.availableIntegral = [self.orderTotalView setOrderTotalPrice:self.totalPrice  - (self.integralSwitch.on * (float)self.availableIntegral / 100)
                                                                     couponPrice:self.couponPrice
                                                                         freight:self.isDistribution * [Single sharedInstance].freight] * 100;
                
                [tableView reloadData];
            }];
            self.goViewController(chooseAddressVC);
        }
        // 选择配送时间
        else if (indexPath.row == 2 && [Single sharedInstance].isdeliverTime) {
            
            if (self.isDistribution) {
                
                self.isSelectTime = !self.isSelectTime;
                [self initDeliveryTimeView];
            }
        }
        // 选择优惠券
        else if (indexPath.row == 3 - ![Single sharedInstance].isdeliverTime + !self.isDistribution) {
            
            if (self.numberOfCoupons == 0) {
                
//                return [Tools myHud:@"没有可用优惠券"];
                return;
            }
            else {
                
                MyCouponsViewController *couponVC = [MyCouponsViewController new];
                couponVC.couponArray = self.couponArray;
                couponVC.isSelectCoupon = YES;
                self.goViewController(couponVC);
                
                [couponVC setSelectCoupon:^(NSString *priceString,
                                            NSString *idString,
                                            BOOL isSelect)
                {
                    self.isSelectCoupon = isSelect;
                    self.couponIdString = idString;
                    self.couponPrice = [priceString floatValue];
                    
                    if (self.couponPrice > 0) {
                        self.couponString = [NSString stringWithFormat:@"已优惠￥%@元  更换",priceString];
                    }
                    
                    if (!isSelect) {
                        
                        self.couponIdString = @"";
                        self.couponPrice = 0;
                        self.couponString = [NSString stringWithFormat:@"您有%zd张优惠券可用",self.numberOfCoupons];
                    }
                    
                    // 价格
                    self.availableIntegral = [self.orderTotalView setOrderTotalPrice:self.totalPrice  - (self.integralSwitch.on * (float)self.availableIntegral / 100) couponPrice:self.couponPrice freight:self.isDistribution * [Single sharedInstance].freight] * 100;
                    
                    [tableView reloadData];
                }];
                
                [couponVC setSelectGoodsCoupon:^(NSString *priceString,
                                                 NSString *idString,
                                                 BOOL isSelect,
                                                 NSInteger index)
                 {
                     self.couponPrice = 0;
                     self.isSelectCoupon = isSelect;
                     CouponModel *couponModel = _couponArray[index];
                     if (!isSelect) {
                         
                         self.couponIdString = @"";
                         self.couponString = [NSString stringWithFormat:@"您有%zd张优惠券可用",self.numberOfCoupons];
                     }
                     else {
                         
                         for (int i = 0; i < self.goodsArray.count; i++) {
                             
                             ShopCart *model = self.goodsArray[i];
                             if ([couponModel.typeObjectId intValue] == [model.productId intValue]) {
                                 self.couponPrice = [model.salePrice floatValue];
                                 break;
                             }
                         }
                         
                         self.couponIdString = couponModel.Id;
                         self.couponString =  [NSString stringWithFormat:@"已选择%@ 更换",couponModel.TickName];
                     }
                     
                     // 价格
                     self.availableIntegral = [self.orderTotalView setOrderTotalPrice:self.totalPrice  - (self.integralSwitch.on * (float)self.availableIntegral / 100)
                                                                          couponPrice:self.couponPrice
                                                                              freight:self.isDistribution * [Single sharedInstance].freight] * 100;
                     [tableView reloadData];
                 }];
            }
        }
    }
}

#pragma mark 距离
- (void)distanceWithCoor:(CLLocationCoordinate2D)coor {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // 商家距离
    CLLocationCoordinate2D merchantsCoor;
    merchantsCoor.latitude = [[userDefaults objectForKey:@"xPoint"] floatValue];
    merchantsCoor.longitude = [[userDefaults objectForKey:@"yPoint"] floatValue];
    
    BMKMapPoint bdMap1 = BMKMapPointForCoordinate(merchantsCoor);
    BMKMapPoint bdMap2 = BMKMapPointForCoordinate(coor);

    CLLocationDirection distance = BMKMetersBetweenMapPoints(bdMap1, bdMap2);
    IFPLog(@"===配送最大距离%.2f, ===相距%.2f",[[userDefaults objectForKey:@"Distance"] floatValue], distance);
    
    if (distance > [[userDefaults objectForKey:@"Distance"] floatValue]) {
        
        [Tools myHud:@"您选择的收货地址超出配送范围，请重新选择"];
        
        self.orderTotalView.payBtn.enabled = NO;
        self.orderTotalView.payBtn.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        
        self.orderTotalView.payBtn.enabled = YES;
        self.orderTotalView.payBtn.backgroundColor = Color;
    }
}

@end
