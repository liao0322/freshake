//
//  GroupPeopleViewController.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/27.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupPeopleViewController.h"
#import "DetailsTableView.h"
#import "GroupDetailModel.h"
#import "GroupDetailListModel.h"
#import "GroupViewController.h"
#import "MyOrderViewController.h"
#import "SubmitGroupViewController.h"
#import "GroupModel.h"
#import "WXApi.h"
#import "MyOrderDetailsViewController.h"
#import "PaymentTypeView.h"

#import <UShareUI/UShareUI.h>

@interface GroupPeopleViewController ()

@property (nonatomic, strong) DetailsTableView *detailsTableView;
@property (nonatomic, strong) NSMutableArray *detailsArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *orderStatusBtn;

@property (nonatomic, strong) PaymentTypeView *paymentTypeView;

@end

@implementation GroupPeopleViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self addNotificationCenter];
    [self requestOrder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];

    _detailsArray = [NSMutableArray array];
    
    [self setNav];
    [self initPaymentTypeView];
    [self initDetailsTableView];
    [self initOrderStatusBtn];
    [self requestOrder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 推送
// 添加推送
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payState:) name:@"PayState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessful) name:@"zhifubao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:@"zhifubaoCancel" object:nil];
}

// 支付状态
- (void)payState:(NSNotification *)notification {
    
    BOOL state = [[notification object] boolValue];
    
    if (state) {
        
        [self requestOrder];
    }
    else {
        
        [Tools myHud:@"取消支付"];
    }
}

// 付款成功
- (void)paySuccessful {
    
    [Tools myHud:@"付款成功" inView:self.view];
    [Single sharedInstance].isRefreshTitle = NO;
    // 前往我的订单
    [self requestOrder];
}

// 付款失败
- (void)payFailure {
    
    [Tools myHud:@"付款失败" inView:self.view];
    [Single sharedInstance].isRefreshTitle = NO;
}

#pragma mark - 初始化
- (void)initDetailsTableView {
    
    WS(weakSelf);
    if (_detailsTableView == nil) {
        
        _detailsTableView = [[DetailsTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _detailsTableView.myGroupModel = _model;
        _detailsTableView.goController = ^(UIViewController *viewController) {
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        };
        _detailsTableView.refreshDataSource = ^{
            [weakSelf requestOrder];
        };
        [self.view addSubview:_detailsTableView];
    }
    else {
        
        _detailsTableView.dataSource = _detailsArray;
        [_detailsTableView refreshTableView];
    }
}

- (void)initPaymentTypeView {
    
    _paymentTypeView = [PaymentTypeView new];
    _paymentTypeView.hidden = YES;
    
    WS(weakSelf);
    [_paymentTypeView setPaymentId:^(NSString *paymentId) {
        [weakSelf getUpdateActivityPaymentId:paymentId];
    }];
}

#pragma mark 订单状态
- (void)initOrderStatusBtn {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
    [bgView addSubview:line];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 5 * 3, CGRectGetHeight(bgView.frame))];
    _titleLabel.text = @"还差2人成团";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.textColor = [UIColor colorWithHexString:@"0xfc9d15"];
    _titleLabel.textColor = [UIColor colorDomina];
    [bgView addSubview:_titleLabel];
    
    _orderStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderStatusBtn.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 0, ScreenWidth / 5 * 2, CGRectGetHeight(bgView.frame));
//    _orderStatusBtn.backgroundColor = [UIColor colorWithHexString:@"0xff6600"];
    _orderStatusBtn.backgroundColor = [UIColor colorDomina];
    _orderStatusBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_orderStatusBtn setTitle:@"分享好友" forState:UIControlStateNormal];
    [_orderStatusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderStatusBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_orderStatusBtn];
}

#pragma mark 设置Nav
- (void)setNav {
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"拼团详情"];
    self.title = @"拼团详情";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

#pragma mark - 事件处理
#pragma makr 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 分享
- (void)share {
    
    GroupDetailModel *model = _detailsArray[0];
    NSString *goodsName = model.productName;
    NSString *goodsPrice = model.salePrice;
    NSString *shortDesc = model.shortDesc;
    __block UIImage *iconImg;
    
    
    NSString *titleString = [NSString stringWithFormat:@"%@(%@元)",goodsName,goodsPrice];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_Qzone)]];
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  model.thumbnailsUrll;
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleString descr:shortDesc thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = model.url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            [self alertWithError:error];
        }];
        
        
    }];
    
    
    return;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:model.thumbnailsUrll]
                          options:SDWebImageRetryFailed
                         progress:nil
                        completed:^(UIImage *image,
                                    NSError *error,
                                    SDImageCacheType cacheType,
                                    BOOL finished,
                                    NSURL *imageURL)
     {
         iconImg = image;
         NSString *titleString = [NSString stringWithFormat:@"%@(%@元)\n%@",goodsName,goodsPrice,shortDesc];
         /*
         
         [UMSocialConfig hiddenNotInstallPlatforms:[NSArray arrayWithObjects:
                                                    UMShareToQQ,
                                                    UMShareToQzone,
                                                    UMShareToWechatSession,
                                                    UMShareToWechatTimeline,nil]];
         
         [UMSocialSnsService presentSnsIconSheetView:self
                                              appKey:@"57e87c1667e58ee0380015f8"
                                           shareText:titleString
                                          shareImage:image
                                     shareToSnsNames:[NSArray arrayWithObjects:
                                                      UMShareToQQ,
                                                      UMShareToWechatSession,
                                                      UMShareToWechatTimeline,
                                                      UMShareToQzone,nil]
                                            delegate:nil];
         
          //设置QQ分享
         [UMSocialQQHandler setQQWithAppId:@"1105606669"
                                    appKey:@"k0uCtHZeQtqKe7Fo"
                                       url:model.url];
         [UMSocialQQHandler setSupportWebView:YES];
         
         
          //设置微信分享
         [UMSocialWechatHandler setWXAppId:WECARTAPPID
                                 appSecret:@"6f8462f766e5d976d9cde4fed3c6a8d1"
                                       url:model.url];
          */
     }];
//    
//    UIImageView *imgView = [UIImageView new];
//    [imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailsUrll]
//               placeholderImage:IMAGE(@"logo.jpg")];
//    
//    NSString *titleString = [NSString stringWithFormat:@"%@(%@元)\n%@",goodsName,goodsPrice,shortDesc];
//    
//    [UMSocialConfig hiddenNotInstallPlatforms:[NSArray arrayWithObjects:
//                                               UMShareToQQ,
//                                               UMShareToQzone,
//                                               UMShareToWechatSession,
//                                               UMShareToWechatTimeline,nil]];
//    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"57e87c1667e58ee0380015f8"
//                                      shareText:titleString
//                                     shareImage:imgView.image
//                                shareToSnsNames:[NSArray arrayWithObjects:
//                                                 UMShareToQQ,
//                                                 UMShareToWechatSession,
//                                                 UMShareToWechatTimeline,
//                                                 UMShareToQzone,nil]
//                                       delegate:nil];
//    
//    // 设置QQ分享
//    [UMSocialQQHandler setQQWithAppId:@"1105606669"
//                               appKey:@"k0uCtHZeQtqKe7Fo"
//                                  url:model.url];
//    [UMSocialQQHandler setSupportWebView:YES];
//    
//    // 设置微信分享
//    [UMSocialWechatHandler setWXAppId:WECARTAPPID
//                            appSecret:@"6f8462f766e5d976d9cde4fed3c6a8d1"
//                                  url:model.url];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)btnClick {
    
    GroupDetailModel *model = _detailsArray[0];
    
    if ([model.UStatus integerValue] == 1) {

        if (isBlankString(model.express_id)) {
            
            SubmitGroupViewController *submitGroupVC = [[SubmitGroupViewController alloc] init];
            submitGroupVC.isUpdate = YES;
            
            GroupModel *model = [[GroupModel alloc] init];
            model.Id = _model.Id;
            model.ProductName = _model.productName;
            model.ActivityPrice = _model.ActivityPrice;
            
            submitGroupVC.groupModel = model;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:submitGroupVC animated:YES];
        }
        else {
            
            self.paymentTypeView.hidden = NO;
        }
        
    }
    else if ([model.UStatus integerValue] == 2) {
        
        [self share];
    }
    else if ([model.UStatus integerValue] == 3) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        MyOrderDetailsViewController *payOrderVC = [[MyOrderDetailsViewController alloc] init];
        payOrderVC.idString = _model.AddUserId;
        payOrderVC.orderString = _model.Order_No;
        payOrderVC.midString = _model.Sid;
        payOrderVC.isGroup = YES;
        
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }
    else {
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[GroupViewController new] animated:YES];
    }
}

#pragma mark - 请求数据
#pragma mark 获取订单详情
- (void)requestOrder {
    
    NSString *urlString = [NSString stringWithFormat:GetActivityInfo,_model.Id,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        [_detailsArray removeAllObjects];
        
        if ([data[@"issuccess"] boolValue]) {
            
            GroupDetailModel *model = [[GroupDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:data];
            
            for (NSDictionary *dic in data[@"List"]) {
                
                GroupDetailListModel *listModel = [[GroupDetailListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                [model.listArray addObject:listModel];
            }
            
            [_detailsArray addObject:model];
            
            [self initDetailsTableView];

            if ([model.UStatus integerValue] == 1) {

                if ([_model.UserId isEqualToString:_model.AddUserId]) {
                    self.titleLabel.text = @"开团成功，待支付";
                } else self.titleLabel.text = @"参团成功，待支付";
                
                [_orderStatusBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                
                if ([model.PayTime integerValue] <= 0) {
                    
                    [_orderStatusBtn setBackgroundColor:[UIColor lightGrayColor]];
                    
                    _titleLabel.text = @"拼团失败";
                    _orderStatusBtn.enabled = NO;
                }
            }
            else if ([model.UStatus integerValue] == 2) {
                
                NSInteger count = [model.ActivityUserNum integerValue] - model.listArray.count;
                
                if (count < 0) {
                    count = 0;
                }
                
                _titleLabel.text = [NSString stringWithFormat:@"还差%zd人成团", count];
                [_orderStatusBtn setTitle:@"分享好友" forState:UIControlStateNormal];
            }
            else if ([model.UStatus integerValue] == 3) {
                
                _titleLabel.text = @"拼团成功";
                [_orderStatusBtn setTitle:@"查看订单" forState:UIControlStateNormal];
            }
            else if ([model.UStatus integerValue] == 4) {
                
                _titleLabel.text = @"拼团失败";
                [_orderStatusBtn setTitle:@"我要拼团" forState:UIControlStateNormal];
            }
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getUpdateActivityPaymentId:(NSString *)paymentId {
    
    // 隐藏
    self.paymentTypeView.hidden = YES;
    // 修改支付方式
    [Single sharedInstance].payMent = [paymentId integerValue];
    
    NSString *urlString = [NSString stringWithFormat:UpdateActivityPayment_id, _model.Id, paymentId];
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
                    
                    [Tools alipayPayRequestWithTradeNO:data[@"order_no"]  ProductName:@"鲜摇派" ProductDescription:@"鲜摇派" Amount:data[@"totalPrice"] notify_url:ALIPAYURL];
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
