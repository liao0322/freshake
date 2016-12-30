//
//  MyOrderView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MyOrderView.h"
#import "MyOrderDetailsViewController.h"
#import "PublishOrderAndGoodsViewController.h"

#define bg_Height 50


@interface MyOrderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *lineScrollView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGRect temRect;
@property (nonatomic, strong) UIButton *temBtn;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIPageControl *page;
@property (nonatomic, strong) UIView *bgBtnView;

@end

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _temRect = CGRectZero;
        _btnArr = [NSMutableArray array];
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 10)];
    _bgScrollView.delegate = self;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _titleArray.count, SCREEN_HEIGHT / 2);
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _page = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _page.numberOfPages = _titleArray.count;
    _page.currentPage = 0;
    [_bgScrollView addSubview:_page];
    [self addSubview:_bgScrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgScrollView.frame), self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:@"GoodsCell"];
    [_tableView registerClass:[MyOrderInfoCell class] forCellReuseIdentifier:@"OrderInfoCell"];
}

- (void)initOrderStateView {
    
    _bgBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bg_Height)];
    _bgBtnView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgBtnView];
    
    _titleArray = @[@"所有订单",@"待付款",@"待提货",@"已提货",@"待评价"];
    for (int i = 0; i < _titleArray.count; i++) {
        
        int btnWidth = SCREEN_WIDTH / _titleArray.count;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.frame = CGRectMake(btnWidth * i + 5, 0, btnWidth, bg_Height);
        
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        //        [bgBtn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_btnArr addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            [btn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
            _temBtn = btn;
            _temRect = btn.frame;
        } else {
            
            [btn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
        }
        
        [_bgBtnView addSubview:btn];
        if (_index == i) {
            
            _bgBtn = btn;
            
        }
    }

    NSLog(@"btnframe>>>>>>>>%@", NSStringFromCGRect(_bgBtn.frame));
    NSLog(@"frame>>>>>>>>%@",NSStringFromCGRect(_temBtn.frame));

    _lineScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenWidth == 320 ? 12 : 12, CGRectGetMaxY(_temRect), SCREEN_WIDTH / _titleArray.count - 15, 2)];
    _lineScrollView.backgroundColor = [UIColor colorDomina];
    _lineScrollView.delegate = self;
    _lineScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _titleArray.count, 2);
    _lineScrollView.showsVerticalScrollIndicator = NO;
    _lineScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_lineScrollView];

    
    
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self initOrderStateView];

    if (_index == 0) {
        _bgBtn.tag = 100;
        [_bgBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (_index == 1) {
        _bgBtn.tag = 101;
        [_bgBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView.mj_header beginRefreshing];
    }else if (_index == 2) {
        _bgBtn.tag = 102;
        [_bgBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView.mj_header beginRefreshing];
        
    } else if (_index == 3) {
        _bgBtn.tag = 103;
        [_bgBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView.mj_header beginRefreshing];
        
    } else if (_index == 4) {
        _bgBtn.tag = 104;
        [_bgBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView.mj_header beginRefreshing];
        
    }
    
//    UIButton *btn = _btnArr[_index];
//    [_temBtn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
//    _temBtn = btn;

   }

#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}

#pragma mark 前往控制器
- (void)goViewController:(NSInteger)index model:(Order *)model {

    if (index == 12) {
        
        MyOrderDetailsViewController *orderDeailVC = [MyOrderDetailsViewController new];
        orderDeailVC.idString = [NSString stringWithFormat:@"%zd",[model.Id integerValue]];
        orderDeailVC.orderString = model.order_no;
        orderDeailVC.isGroup = NO;
        _goViewController(orderDeailVC);
    }
    else if (index == 11) {
        _goPay(model);
    }
    else {
        
        PublishOrderAndGoodsViewController *publish = [[PublishOrderAndGoodsViewController alloc] init];
        publish.orderModel = model;
        publish.indexRow = -1;
        _goViewController(publish);
    }
}

#pragma mark 关闭订单
- (void)shutOrder:(UIButton *)btn {
    
    Order *model = _dataSource[btn.tag - 30];
    _orderId = [model.Id stringValue];
    _cancelOrder();
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Order *model = _dataSource[section];
    return 2 + model.List.count;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            for (int i = 0; i < 2; i++) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (CGRectGetHeight(cell.frame) - 0.5), ScreenWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
                [cell addSubview:line];
            }
        }
        
        // 订单状态
        UIButton *orderStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        orderStatus.frame = CGRectMake(0, 0, 55, CGRectGetHeight(cell.frame));
        orderStatus.tag = indexPath.section + 30;
        cell.accessoryView = orderStatus;
        
        UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, CGRectGetHeight(cell.frame))];
        orderStatusLabel.font = [UIFont systemFontOfSize:14.0];
        orderStatusLabel.textColor = [UIColor colorDomina];
        orderStatusLabel.textAlignment = NSTextAlignmentCenter;
        [orderStatus addSubview:orderStatusLabel];
        
        if ([model.status integerValue] == 1) {

            orderStatusLabel.text = @"取消订单";
            [orderStatus addTarget:self action:@selector(shutOrder:) forControlEvents:UIControlEventTouchUpInside];
            
//            if ([model.payment_status integerValue] == 1) {
//                
//                
//            }
//            else {
//                orderStatusLabel.text = @"已支付";
//            }
        }
        else if ([model.status integerValue] == 2) {
            orderStatusLabel.text = @"待提货";
        }
        else if ([model.status integerValue] == 3) {
            orderStatusLabel.text = @"已提货";
        }
        else {
            orderStatusLabel.text = @"已取消";
        }
        
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.imageView.image = [UIImage imageNamed:@"FSMyOrder订单"];
        cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",model.order_no];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
        
        return cell;
    }
    else if (indexPath.row == model.List.count + 1) {
        
        MyOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
        cell.selectionStyle = UITableViewCellStyleDefault;
        [cell setModel:model];
        
        cell.btnClickBlock = ^(NSInteger index) {
            [self goViewController:index model:model];
        };
        
        return cell;
    }

    MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell"];
    cell.selectionStyle = UITableViewCellStyleDefault;
    [cell setModel:model.List[indexPath.row - 1]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        return 50;
    }
    else if (indexPath.row == model.List.count + 1) {
        return 90;
    }
    
    else return 100;
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Order *model = _dataSource[indexPath.section];

    if (indexPath.row - 1 < model.List.count) {
        
        if ([model.status integerValue] == 3) {
            
            model.List = [NSMutableArray arrayWithArray:@[model.List[indexPath.row - 1]]];
            [self goViewController:10 model:model];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    [_temBtn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
    _temBtn = btn;

    if (btn.tag == 100) {
        [_bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _stateUrl = ORDER;
    }
    else if (btn.tag == 101) {
        [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        _stateUrl = WAITPAY;
    }
    else if (btn.tag == 102) {
        [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
        _stateUrl = SHIPED;
    }
    else if (btn.tag == 103) {
        [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 3, 0) animated:YES];

        _stateUrl = FINISHED;
    }
    else if (btn.tag == 104) {
        [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 4, 0) animated:YES];

        _stateUrl = WAITCOMMENT;
    }
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:_stateUrl,1,1000,midString];
    NSLog(@"###########%@",urlString);
    _requestOrder(urlString);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bgScrollView) {
        _lineScrollView.contentOffset = CGPointMake(_bgScrollView.contentOffset.x / _titleArray.count, 0);
        _lineScrollView.frame = CGRectMake(_bgScrollView.contentOffset.x / _titleArray.count + 12, bg_Height, SCREEN_WIDTH / _titleArray.count - 15, 2);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _bgScrollView) {
        
        int i = _bgScrollView.contentOffset.x / SCREEN_WIDTH;
        UIButton *btn = _btnArr[i];

        [_temBtn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
        _temBtn = btn;
    }
}

@end
