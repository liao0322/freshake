//
//  RechargeViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RechargeViewController.h"
#import "MeViewController.h"
#import "PaymentCell.h"
#import "RechargeView.h"

@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    RechargeView *_rechargeView;
    RechargeView *_bottomView;
    UITableView *_tableView;
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.title = @"充值确认";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoPush) name:@"zhifubao" object:nil];
    
    [self initUITableView];
    [self initView];
}

- (void)zhifubaoPush {
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 初始化tableView
-(void)initUITableView
{
    //_tableView = [Tools tableViewWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 165) style:UITableViewStylePlain delegate:self dataSource:self];
    _tableView = [Tools tableViewWithFrame:self.view.bounds style:UITableViewStylePlain delegate:self dataSource:self];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 165;
    _tableView.scrollEnabled = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil]
     forCellReuseIdentifier:@"PaymentCell"];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 55+10+165, SCREEN_WIDTH,0.5)];
    line.backgroundColor=[UIColor colorWithHexString:@"0xd7d7d7"];
    [self.view addSubview:line];

}
#pragma mark 初始化上、下View
-(void)initView
{
    _rechargeView = [[RechargeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    _rechargeView.isBottomView = @"0";
    [_rechargeView SetUI:[NSString stringWithFormat:@"￥ %.2f",[_Money floatValue]] WithTitle:@"充值金额:" AndColor:@"0xff5f3e"];
    [self.view addSubview:_rechargeView];
    
    
    _bottomView = [[RechargeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-55, SCREEN_WIDTH, 55)];
    _bottomView.isBottomView = @"1";
    [_bottomView SetUI:[NSString stringWithFormat:@"￥ %.2f",[_Money floatValue]] WithTitle:@"充值金额:" AndColor:@"0xff5f3e"];
    [self.view addSubview:_bottomView];

    __weak typeof(self)weakSelf = self;
    _bottomView.RechargeBtn = ^(NSString *money){
        [weakSelf weiPay];
    };
}

#pragma mark 金额充值
- (void)weiPay {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userIdString = [defaults objectForKey:@"UID"];
    NSString *userNameString = [defaults objectForKey:@"user_name"];
    NSString *payMentIdString = [NSString stringWithFormat:@"%zd",[Single sharedInstance].payMent];
    
    NSString *urlString = [NSString stringWithFormat:WeiPay,userIdString,userNameString,_Money,payMentIdString,self.rechargeId];
    NSLog(@"%@",self.rechargeId);
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         [Single sharedInstance].isBalance = YES;
         if ([payMentIdString isEqualToString:@"3"]) {
             [Tools alipayPayRequestWithTradeNO:data[@"order_no"]
                                    ProductName:@"鲜摇派余额充值"
                             ProductDescription:@"鲜摇派"
                                         Amount:data[@"totalPrice"]
                                     notify_url:data[@"notify_url"]];
         }
         else if ([payMentIdString isEqualToString:@"4"]) {
             [Tools WeCartPayWithNoncestr:data[@"nonce_str"]
                                  package:@"Sign=WXPay"
                                partnerid:data[@"mch_id"]
                                 prepayid:data[@"prepay_id"]
                                timestamp:data[@"time_stamp"]];
        }
        
    } failure:nil];
}

#pragma mark 设置组
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
