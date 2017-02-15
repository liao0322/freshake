//
//  FSMyOrderListViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyOrderListViewController.h"
#import "FSSegmentView.h"
#import "FSMyOrderListTVCell.h"
#import "FSMyOrderListSectionHeaderView.h"
#import "FSMyOrderListSectionFooterView.h"
#import "Order.h"
#import "GoodsDetailViewController.h"
#import "MyOrderDetailsViewController.h"
#import "WXApi.h"
#import "PublishOrderAndGoodsViewController.h"
#import "SubmitOrderViewController.h"
#import "ShopCart.h"
//#import "FSViewExpressViewController.h"
#import "XFExpressDetailsViewController.h"

#define SEGMENT_VIEW_HEIGHT 45.0f

@interface FSMyOrderListViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    FSSegmentViewDelegate
>

@property (nonatomic) NSArray *titles;
@property (nonatomic) FSSegmentView *segmentView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) MJRefreshNormalHeader *normalHeader;

@property (copy, nonatomic, readonly) NSString *uidString;
@property (copy, nonatomic) NSString *urlString;

@property (nonatomic) NSMutableArray *dataSource;
//@property (nonatomic) NSMutableArray *orderCountArray;
//@property (nonatomic) NSMutableArray *commodityArray;

// temp
@property (copy, nonatomic) NSString *orderId;
@property (nonatomic) UIButton *bgView;
@property (copy, nonatomic) NSString *orderNoString;

@end

@implementation FSMyOrderListViewController

static NSString * const OrderListTVCellID = @"OrderListTVCellID";
static NSString * const OrderListSectionHeaderID = @"OrderListSectionHeaderID";
static NSString * const OrderListSectionFooterID = @"OrderListSectionFooterID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.segmentView.width = self.view.width;
    self.segmentView.height = SEGMENT_VIEW_HEIGHT;
    self.segmentView.x = 0;
    self.segmentView.y = 64;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)initialization {
    [super initialization];
    self.title = @"我的订单";
    
    
    
    // table view init
    self.tableView.contentInset = UIEdgeInsetsMake(SEGMENT_VIEW_HEIGHT, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(SEGMENT_VIEW_HEIGHT, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    self.tableView.mj_header = self.normalHeader;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.segmentView selectIndex:self.selectedIndex];
}

- (void)addSubviews {
    [super addSubviews];
    
    [self.view addSubview:self.segmentView];
}

- (void)registerCells {
    [super registerCells];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSMyOrderListTVCell class]) bundle:nil] forCellReuseIdentifier:OrderListTVCellID];
    
    [self.tableView registerClass:[FSMyOrderListSectionHeaderView class] forHeaderFooterViewReuseIdentifier:OrderListSectionHeaderID];
    
    [self.tableView registerClass:[FSMyOrderListSectionFooterView class] forHeaderFooterViewReuseIdentifier:OrderListSectionFooterID];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Order *model = self.dataSource[section];
    return model.List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *model = self.dataSource[indexPath.section];
    FSMyOrderListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListTVCellID forIndexPath:indexPath];
    cell.dict = model.List[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *model = self.dataSource[indexPath.section];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
    NSDictionary *dataDic = [model.List objectAtIndex:indexPath.row];
    detailVC.ProductId = [[dataDic objectForKey:@"goods_id"] integerValue];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 78.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Order *model = self.dataSource[section];
    FSMyOrderListSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderListSectionHeaderID];
    headerView.model = model;
    
    headerView.cancelOrderBlock = ^{
        NSLog(@"取消订单");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 执行取消订单操作
            [self cancelOrderWithSection:section];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:confirmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FSMyOrderListSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderListSectionFooterID];
    Order *model = self.dataSource[section];
    footerView.model = model;
    footerView.viewOrderDetailsBlock = ^{
        
        MyOrderDetailsViewController *orderDetailsVC = [MyOrderDetailsViewController new];
        orderDetailsVC.idString = [NSString stringWithFormat:@"%zd",[model.Id integerValue]];
        orderDetailsVC.orderString = model.order_no;
        orderDetailsVC.isGroup = NO;
        [self.navigationController pushViewController:orderDetailsVC animated:YES];
        
    };
    footerView.toPayBlock = ^{
        self.orderId = [NSString stringWithFormat:@"%zd",[model.Id integerValue]];
        [self showPayView];
    };
    
    footerView.buyAgainBlock = ^{
        
        NSMutableArray *listArray = [NSMutableArray array];
        for (int i = 0; i < model.List.count; i++) {
            NSDictionary *dict = model.List[i];
            ShopCart *m = [ShopCart new];
            
            m.productName = dict[@"goods_title"];
            m.salePrice = dict[@"goods_price"];
            m.productId = dict[@"goods_id"];
            m.ID = dict[@"goods_id"];
            m.productNum = dict[@"quantity"];
            
            [listArray addObject:m];
            
        }
        
        SubmitOrderViewController *submitOrderVC = [SubmitOrderViewController new];
        submitOrderVC.goodsArray = listArray;
        submitOrderVC.buySoon = YES;
        //submitOrderVC.isCollect = NO;
        //submitOrderVC.fendianId = model.StroreId;
        //submitOrderVC.midString = model.mid;
        //submitOrderVC.fendianAddress = model.addr;
        [self.navigationController pushViewController:submitOrderVC animated:YES];
        
    };
    
    footerView.viewExpressBlock = ^{
        XFExpressDetailsViewController *viewExpressVC = [[XFExpressDetailsViewController alloc] initWithOriginalNo:model.order_no];
        [self.navigationController pushViewController:viewExpressVC animated:YES];
    };
    
    footerView.toCommentBlock = ^{
        PublishOrderAndGoodsViewController *publish = [[PublishOrderAndGoodsViewController alloc] init];
        publish.orderModel = model;
        publish.indexRow = -1;
        
        [self.navigationController pushViewController:publish animated:YES];
    };
    
    footerView.confirmReceiptBlock = ^{
        [XFNetworking GET:[NSString stringWithFormat:ConfirmReceipt, self.uidString, model.order_no] parameters:nil success:^(id responseObject, NSInteger statusCode) {
            self.selectedIndex = 3;
            [self.segmentView selectIndex:self.selectedIndex];
            
        } failure:^(NSError *error, NSInteger statusCode) {
            [self showInfoWidthError:error];
        }];
    };
    
    return footerView;
}


#pragma mark - FSSegmentViewDelegate

- (void)segmentView:(FSSegmentView *)segmentView didSelectedIndex:(NSInteger)index {
    
    self.selectedIndex = index;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.normalHeader beginRefreshing];
}

#pragma mark - Custom

/// 下拉刷新时获取所有订单
- (void)refreshData:(MJRefreshNormalHeader *)sender {
    [self getOrder];
}

- (void)getOrder {
    [XFNetworking GET:self.urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        if ([self.normalHeader isRefreshing]) {
            [self.normalHeader endRefreshing];
        }
        
        [self.dataSource removeAllObjects];
        
        NSDictionary *data = [self dictWithData:responseObject];
        
        if ([data[@"pageCount"] integerValue] > 0) {
            for (NSDictionary *dic in data[@"List"]) {
                Order *model = [[Order alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
        
        if (self.dataSource.count == 0) {
            self.tableView.backgroundView = self.noDataView;
        } else {
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        if ([self.normalHeader isRefreshing]) {
            [self.normalHeader endRefreshing];
        }
        [self showInfoWidthError:error];
    }];
}

- (void)cancelOrderWithSection:(NSInteger)section {
    Order *model = self.dataSource[section];
    NSString *orderId = [model.Id stringValue];
    NSString *urlString = [NSString stringWithFormat:CANCELORDER,orderId,self.uidString];
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *data = [self dictWithData:responseObject];
        [SVProgressHUD showInfoWithStatus:data[@"context"]];
        model.status = @"4";
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
}

- (void)showPayView {
    if (_bgView == nil) {
        
        _bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
        [_bgView addTarget:self action:@selector(dismissPayView) forControlEvents:UIControlEventTouchUpInside];
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

}

// 是否隐藏支付View
- (void)dismissPayView {
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}

// 选择支付方式
- (void)selectPayType:(UIButton *)btn {
    [self dismissPayView];
    if (btn.tag == 10) [Single sharedInstance].payMent = AmountPlay;
    else [Single sharedInstance].payMent = btn.tag == 11 ? WeCartPay : AliPay;
    [self updatePaymentWithPayment:[NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent]];
}

// 更新支付方式
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

// 请求是否存在支付密码
- (void)requestIsPayPwd {
    
    NSString *urlString = [NSString stringWithFormat:IsPayPwd,self.uidString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         [self setPayAlertControllerWithIsExist:[data[@"issuccess"] boolValue]];
         
     } failure:nil];
}

// 输入支付密码
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

// 使用余额支付
- (void)requstAmountPayWithPassword:(NSString *)password {
    
    NSString *url = [NSString stringWithFormat:AmountPay,_orderNoString,password];
    [HttpRequest sendGetOrPostRequest:url param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) [self zhifubaoPush];
         else [Tools myHud:data[@"context"] inView:self.view];
         
     } failure:nil];
}

// 支付通知
- (void)zhifubaoPush {
    [self getOrder];
}

// 设置支付密码
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


#pragma mark - LazyLoad

- (NSArray *)titles {
    return @[@"全部", @"待付款", @"待提货", @"已提货", @"待评价"];
}

- (NSString *)uidString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
}

- (FSSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[FSSegmentView alloc] initWithTitles:self.titles];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (MJRefreshNormalHeader *)normalHeader {
    if (!_normalHeader) {
        _normalHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData:)];
        _normalHeader.lastUpdatedTimeLabel.hidden = NO;
    }
    return _normalHeader;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSString *)urlString {
    NSString *urlString = nil;
    NSString *stateUrl = nil;
    
    if (self.selectedIndex == 0) { // 所有订单
        stateUrl = ORDER;
    }
    else if (self.selectedIndex == 1) { // 待付款
        stateUrl = WAITPAY;
    }
    else if (self.selectedIndex == 2) { // 待提货
        stateUrl = SHIPED;
    }
    else if (self.selectedIndex == 3) { // 已提货
        stateUrl = FINISHED;
    }
    else if (self.selectedIndex == 4) { // 待评价
        stateUrl = WAITCOMMENT;
    }
    
    urlString = [NSString stringWithFormat:stateUrl,1,1000,self.uidString];
    return urlString;
}

/*
- (NSMutableArray *)orderCountArray {
    if (!_orderCountArray) {
        _orderCountArray = [NSMutableArray array];
    }
    return _orderCountArray;
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
    }
    return _commodityArray;
}
*/

@end
