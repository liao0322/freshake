//
//  MyOrderDetailsViewController.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import "MyOrderDetailsViewController.h"
#import "MyOrderDetailsView.h"
#import "PaymentTypeView.h"

@interface MyOrderDetailsViewController ()

@property (nonatomic, strong) MyOrderDetailsView *orderDetailsView;
// 支付按钮
@property (nonatomic, strong) UIButton *payBtn;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 选择支付类型
@property (nonatomic, strong) PaymentTypeView *paymentTypeView;

@end

@implementation MyOrderDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"订单详情"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    // 初始化支付按钮
    [self initPayBtn];
    // 初始化视图
    [self initOrderDetailsView];
    // 初始化支付类型
    [self initPaymentTypeView];
    // 通知
    [self addNotificationCenter];
    
    if (self.isGroup) {
        
        // 获取团购的订单
        [self getGroupOrderDetails];
    }
    else {
        
        // 获取订单信息
        [self getOrderDetalis];
        [self getEvaluationWithId:self.idString];
    }
    
}

#pragma mark - 通知
// 添加通知
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payState:) name:@"PayState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"zhifubao" object:nil];
}

// 支付状态
- (void)payState:(NSNotification *)notification {
    
    BOOL state = [[notification object] boolValue];
    
    if (state) {
        
        [Tools myHud:@"支付成功"];
        [self getOrderDetalis];
        [self getEvaluationWithId:self.idString];
    }
}

// 付款成功
- (void)paySuccessful {
    
    [Tools myHud:@"付款成功" inView:self.view];
    [self getOrderDetalis];
    [self getEvaluationWithId:self.idString];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.timer = self.orderDetailsView.timer;
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)initOrderDetailsView {
    
    self.orderDetailsView = [MyOrderDetailsView new];
    [self.view addSubview:self.orderDetailsView];
    
    self.orderDetailsView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .bottomSpaceToView(_payBtn, 0);
    
    WS(weakSelf);
    // 订单结束、重新刷新界面
    [self.orderDetailsView setOverdue:^{
        [weakSelf getOrderDetalis];
    }];
}

// 初始化支付类型
- (void)initPaymentTypeView {
    
    _paymentTypeView = [PaymentTypeView new];
    _paymentTypeView.hidden = YES;
    
    WS(weakSelf);
    [_paymentTypeView setPaymentId:^(NSString *paymentId) {
        [weakSelf updatePaymentWithPayment:paymentId];
    }];
}

// 初始化支付按钮
- (void)initPayBtn {
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = [UIColor colorDomina];
    _payBtn.hidden = YES;
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payBtn];
    
    _payBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(0);
}

#pragma mark - 事件处理
- (void)goPay {

    _paymentTypeView.hidden = NO;
}

#pragma mark - 请求
// 获取团购的订单
- (void)getGroupOrderDetails {
    
    NSString *urlString = [NSString stringWithFormat:GetGroupOrderInfo,_idString,_orderString,_midString];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            MyOrderDetailsModel *orderDetailsModel = [[MyOrderDetailsModel alloc] init];
            [orderDetailsModel setValuesForKeysWithDictionary:data];
            self.orderDetailsView.orderDetailsModel = orderDetailsModel;
            [self getEvaluationWithId:orderDetailsModel.Id];
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

// 获取订单详情
- (void)getOrderDetalis {
    
    NSString *urlString = [NSString stringWithFormat:ORDERDETAILS,_idString];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            MyOrderDetailsModel *orderDetailsModel = [[MyOrderDetailsModel alloc] init];
            [orderDetailsModel setValuesForKeysWithDictionary:data];
            self.orderDetailsView.orderDetailsModel = orderDetailsModel;
            
            // 订单状态
            NSInteger status = [orderDetailsModel.status intValue];
            // 支付状态
            NSInteger paymentStatus = [orderDetailsModel.payment_status intValue];
            
            if (status == 1 && paymentStatus == 1) {
                
                _payBtn.hidden = NO;
                _payBtn.sd_layout.heightIs(45);

            }
            else {

                _payBtn.hidden = YES;
                _payBtn.sd_layout.heightIs(0);
            }
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
    } failure:nil];
}

// 获取评价
- (void)getEvaluationWithId:(NSString *)idString {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetProductReview, userId, [idString integerValue]];
    
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if ([data[@"List"] count] > 0 &&
            [data[@"pageCount"] intValue] > 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            if ([data[@"issuccess"] boolValue]) {
                
                for (NSDictionary *dic in data[@"List"]) {
                    
                    EvaluationModel *model = [[EvaluationModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr addObject:model];
                }
                
                self.orderDetailsView.evaluationArray = arr;
            }
        }
        
    } failure:nil];
}

// 更新支付方式
- (void)updatePaymentWithPayment:(NSString *)paymentId {
    
    // 隐藏
    self.paymentTypeView.hidden = YES;
    // 修改支付方式
    [Single sharedInstance].payMent = [paymentId integerValue];
    
    NSString *urlString = [NSString stringWithFormat:UpdatePayment_id, _idString, paymentId];
    [self requestJsonWithUrlString:urlString isLoading:YES success:^(id data) {
        
        if (![data[@"issuccess"] boolValue]) {
            [Tools myHud:data[@"context"] inView:self.view];
        }
        else if ([data[@"totalPrice"] floatValue] <= 0) {
            return [self pushViewControlle:[NSClassFromString(@"MyOrderViewController") new] backIsHiddenTabbar:YES];
        }
        else {
            
            switch ([Single sharedInstance].payMent) {
                    
                case AmountPlay: {
                    
                    self.orderNoString = data[@"order_no"];
                    [self isPayPwd];
                    break;
                }
                    
                case AliPay: {
                    
                     [Tools alipayPayRequestWithTradeNO:data[@"order_no"] ProductName:@"鲜摇派" ProductDescription:@"鲜摇派" Amount:data[@"totalPrice"] notify_url:ALIPAYURL];
                    break;
                }
                    
                case WeCartPay: {
                    
                     [Tools WeCartPayWithNoncestr:data[@"nonce_str"] package:@"Sign=WXPay" partnerid:WECARTPARTERID prepayid:data[@"prepay_id"] timestamp:data[@"time_stamp"]];
                    break;
                }
            }
        }
        
    } failure:nil];
}

@end
