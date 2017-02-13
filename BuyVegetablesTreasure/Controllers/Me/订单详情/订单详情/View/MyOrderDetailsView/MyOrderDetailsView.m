//
//  MyOrderDetailsView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import "MyOrderDetailsView.h"
#import "OtherCell.h"
#import "QrCodeView.h"
#import "OrderAddressCell.h"
#import "MyOrderGoodsCell.h"
#import "PaymentTimeCell.h"
#import "OderDetailsEvaluationCell.h"

#define GetUserId [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]

@interface MyOrderDetailsView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
// 剩余时间
@property (nonatomic, assign) NSInteger remainingTime;

@end

@implementation MyOrderDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initTableView];
    }
    
    return self;
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[OtherCell class] forCellReuseIdentifier:@"OtherCell"];
    [_tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:@"OrderAddressCell"];
    [_tableView registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:@"MyOrderGoodsCell"];
    [_tableView registerClass:[OderDetailsEvaluationCell class] forCellReuseIdentifier:@"OderDetailsEvaluationCell"];
    [_tableView registerClass:[PaymentTimeCell class] forCellReuseIdentifier:@"PaymentTimeCell"];
    [self addSubview:_tableView];
    
    _tableView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}

#pragma mark - 事件处理
// 设置详情数据
- (void)setOrderDetailsModel:(MyOrderDetailsModel *)orderDetailsModel {
    
    _orderDetailsModel = orderDetailsModel;
    [_tableView reloadData];
}

// 设置评论数据
- (void)setEvaluationArray:(NSArray *)evaluationArray {
    
    _evaluationArray = evaluationArray;
    [_tableView reloadData];
}

// 计算时间
- (NSString *)timeConversion:(NSInteger)time {
    
    NSString *nTime;
    if (time >= 0 && time < 60) {
        nTime = [NSString stringWithFormat:@"%02zd秒",time];
    }
    else if (time > 60 && time < 3600) {
        nTime = [NSString stringWithFormat:@"%02zd分%02zd秒", time / 60 ,time % 60];
    }
    else {
        nTime = [NSString stringWithFormat:@"%02zd时%02zd分%02zd秒", time / 3600, time % 3600 / 60, time % 3600 % 60];
    }
    return nTime;
}

// 更新时间
- (void)updateTime {
    
    if (_remainingTime == 0) {
        
        [_timer invalidate];
        _timer = nil;
        
        return _overdue();
    }
    
    _remainingTime--;
    _timeLabel.text = [NSString stringWithFormat:@"您于%@下的订单\n请在%@内付款,超时订单将自动取消",_orderDetailsModel.add_time,[self timeConversion:_remainingTime]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_orderDetailsModel == nil) {
        return 0;
    }

    return 6 + (_evaluationArray.count > 0 ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 订单号
    if (section == 0) {
        
        if ([_orderDetailsModel.payment_status intValue] == 1 && [_orderDetailsModel.RemainingTime intValue] > 0) {
            
            if ([_orderDetailsModel.status intValue] == 4) {
                return 1;
            }
            
            return 2;
        }
    }
    // 地址
    if (section == 1) {
        return 2;
    }
    // 商品
    else if (section == 2) {
        return _orderDetailsModel.list.count;
    }
    // 发票
    else if (section == 4) {
        
        // 判断是否有发票
        if (![Tools isBlankString:_orderDetailsModel.InvoiceTitle]) {

            return 3;
        }
    }
    else if (section == 5) {
        
        // 判断是否支付
        if ([_orderDetailsModel.payment_status integerValue] == 2) {
            return 6;
        }
        
        return 5;
    }
    // 商品评价
    else if (section == 6) {
        
        if (_evaluationArray.count > 0) {
            return _evaluationArray.count + 1;
        }
        
        return 0;
    } else if (section == 3) {
        return 0;
    }
    
    
    // 订单号、提货码、发票
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    // 剩余付款的时间
    if (indexPath.section == 0 && indexPath.row > 0) {
        
        PaymentTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTimeCell"];
        cell.orderDetailsModel = _orderDetailsModel;
        
        if (_timer == nil) {
        
            // 计时器 - 计算剩余时间
            _timeLabel = cell.timeLabel;
            _remainingTime = [_orderDetailsModel.RemainingTime integerValue];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
        }
        
        return cell;
    }
    // 地址
    if (indexPath.section == 1 && indexPath.row > 0) {

        OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
        cell.orderDetailsModel = _orderDetailsModel;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    // 商品
    else if (indexPath.section == 2) {
        
        MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderGoodsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:_orderDetailsModel.list[indexPath.row]];
        NSLog(@"%@", _orderDetailsModel.list[indexPath.row]);
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    // 评价
    else if (indexPath.section == 6 && indexPath.row > 0) {
        
        OderDetailsEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OderDetailsEvaluationCell"];
        cell.evaluationModel = _evaluationArray[indexPath.row - 1];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    
    OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
    [cell setOrderModel:_orderDetailsModel indexPath:indexPath];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.pushViewController = ^(UIViewController *viewController){
        UIResponder *responder = [[self nextResponder] nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)responder;
            [vc.navigationController pushViewController:viewController animated:YES];
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
// row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 剩余付款的时间
    if (indexPath.section == 0 && indexPath.row > 0) {
        
        return [self.tableView cellHeightForIndexPath:indexPath
                                                model:_orderDetailsModel
                                              keyPath:@"orderDetailsModel"
                                            cellClass:[PaymentTimeCell class]
                                     contentViewWidth:ScreenWidth];
    }
    // 地址
    if (indexPath.section == 1 && indexPath.row > 0) {
        
        return [self.tableView cellHeightForIndexPath:indexPath
                                                model:_orderDetailsModel
                                              keyPath:@"orderDetailsModel"
                                            cellClass:[OrderAddressCell class]
                                     contentViewWidth:ScreenWidth];
    }
    // 商品
    else if (indexPath.section == 2) {
        return 100;
    }
    // 评价
    else if (indexPath.section == 6 && indexPath.row > 0) {
        
        return [self.tableView cellHeightForIndexPath:indexPath
                                                model:_evaluationArray[indexPath.row - 1]
                                              keyPath:@"evaluationModel"
                                            cellClass:[OderDetailsEvaluationCell class]
                                     contentViewWidth:ScreenWidth];
    }
    else if (indexPath.row == 0 || indexPath.section == 5 || indexPath.section == 4) {
        
        if (indexPath.section != 2) {
            return 45;
        }
    }
    
    return 0;
}

// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && [self.orderDetailsModel.status intValue] >= 2) {
        
        QrCodeView *qrCodeView = [QrCodeView new];
        qrCodeView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.100];
        qrCodeView.urlString = [NSString stringWithFormat:@"%@_%@_%@",GetUserId, self.orderDetailsModel.order_no, self.orderDetailsModel.mid];
        [self addSubview:qrCodeView];
        
        qrCodeView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
    }
}

@end
