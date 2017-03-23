//
//  GoodsDetailViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/1/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsDetailViewController.h"
//#import "ShopLoginViewController.h"
#import "FSLoginViewController.h"
#import "GoodsCartViewController.h"
#import "SubmitOrderViewController.h"
#import "ShopCart.h"
#import "CompileNumber.h"
#import "Pruduct.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "GoodsDetail.h"
#import "EvaluationModel.h"
#import "FSNavigationController.h"

@interface GoodsDetailViewController ()<UIScrollViewDelegate>
{
    MBProgressHUD * hud;
}

@end

@implementation GoodsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    _productNum = 0;
    [self requestDataFromNet:YES];
    
    // 如果是收藏进来的隐藏购物车
    if (![_isCollect isEqualToString:@"1"]) {
        [self getShoppingCartNum];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Single sharedInstance].isRefreshTitle = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    _isCollectStr = @"0";
    
    // array init
    _dataSourse = [NSMutableArray array];
    _evalutationArray = [NSMutableArray array];
    _evalutationCountArray = [NSMutableArray array];
    
    // setup nav bar
    _collectBBI= [UIFactory createImageBBI:IMAGE(@"收藏") WithTarget:self action:@selector(collectClicked:)];
    UIBarButtonItem *shareBBI = [UIFactory createImageBBI:IMAGE(@"分享") WithTarget:self action:@selector(shareClicked:)];
    UIBarButtonItem *spaceBBI1 = [UIFactory createSpaceBBIWithWidth:0];
    UIBarButtonItem *spaceBBI2 = [UIFactory createSpaceBBIWithWidth:20];
    self.navigationItem.rightBarButtonItems = @[spaceBBI1,_collectBBI,spaceBBI2,shareBBI];
    self.title = @"商品详情";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_ProductId forKey:@"ProductId"];
    
    [self initBottomScrollView];
    [self.view addSubview:self.bottomScrollView];
    
    [self.bottomScrollView addSubview:self.goodsImageDetailsScrollView];
    [self.bottomScrollView addSubview:self.goodsDetailsView];
    [self goImageDetails];
}

#pragma mark - 控件初始化
#pragma mark 底部按钮
- (void)initBottomView {
    
    [_bottomview removeFromSuperview];
    _productNum = _stork == 0 ? 0 : 1;
    
    //_bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
    
    _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    _bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomview];
    
    CompileNumber *compikeNumberVC = [[CompileNumber alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth / 3, 50)];
    compikeNumberVC.stork = _stork;
    [compikeNumberVC.goodsSumLabel setText:[NSString stringWithFormat:@"%zd",_productNum]];
    [_bottomview addSubview:compikeNumberVC];
    
    // 加入购物车
    _addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addbutton.frame = CGRectMake(ScreenWidth / 3, 0, ScreenWidth / 3, 50);
    _addbutton.backgroundColor = [UIColor colorDomina];
    _addbutton.tag = 111;
    _addbutton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_addbutton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_addbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addbutton addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomview addSubview:_addbutton];
    
    if ([_isCollect isEqualToString:@"1"]) {
        _addbutton.hidden = YES;
    }
    
    // 立即购买
    _buybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buybutton.frame = CGRectMake(ScreenWidth / 3 * 2, 0, ScreenWidth / 3, 50);
    _buybutton.backgroundColor = [UIColor orangeColor];
    _buybutton.tag = 222;
    _buybutton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_buybutton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_buybutton addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomview addSubview:_buybutton];
    
    __weak typeof(compikeNumberVC)weakCompikeNumberView = compikeNumberVC;
    compikeNumberVC.goodsNumberBlock = ^(NSString *goodsNumberString,BOOL isStork,BOOL isDel,BOOL isAdd)
    {
        if (isStork && isAdd == YES)
        {
            [Tools myHud:@"库存不足" inView:self.view];
            return ;
        }
        _productNum = [goodsNumberString integerValue];
        weakCompikeNumberView.goodsSumLabel.text = [NSString stringWithFormat:@"%zd",_productNum];
    };
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0x9D9D9D"];
    line.alpha = 0.1;
    [_bottomview addSubview:line];
}

#pragma mark 初始化购物车图标


#pragma mark 初始化详情页面
- (void)initGoodsDetailTableView {
    
    _goodsDetailsView = [[GoodsDetailsView alloc] initWithFrame:_bottomScrollView.frame];
    NSLog(@"%@",NSStringFromCGRect(_goodsDetailsView.frame));
    
}

#pragma mark 初始化底部ScrollView
- (void)initBottomScrollView {
    
    if (_bottomScrollView == nil) {
        _bottomScrollView = [[UIScrollView alloc] init];
        //_bottomScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49);
        _bottomScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _bottomScrollView.backgroundColor = [UIColor whiteColor];
        _bottomScrollView.delegate = self;
    }
    
    [self initGoodsDetailTableView];
    [self initGoodsImageDetailsScrollView];
}

#pragma mark 初始化图文详情页面
- (void)initGoodsImageDetailsScrollView {

    if (_goodsImageDetailsScrollView == nil) {
        
        //_goodsImageDetailsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64 - 50, ScreenWidth, ScreenHeight - 64 - 50)];
        _goodsImageDetailsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _goodsImageDetailsScrollView.delegate = self;
    }
    
    _imageView.hidden = YES;
    [self initDetailsSubView];
    [self requestEvalutationWithLevel:@"0"];
}

- (void)initDetailsSubView {
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 110;
        btn.frame = CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, 50);
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:i == 0 ? @"图文详情" : @"商品评价" forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? [UIColor colorDomina] : [UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.goodsImageDetailsScrollView addSubview:btn];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SYSTEM_WIDTH, 2)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
    [self.goodsImageDetailsScrollView addSubview:line];
    
    UILabel *moveLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth / 2, 2)];
    moveLine.tag = 210;
    moveLine.backgroundColor = [UIColor colorDomina];
    [self.goodsImageDetailsScrollView addSubview:moveLine];
    
    _detailsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 53, ScreenWidth, ScreenHeight - 64 - 50 - 53)];
    _detailsScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    _detailsScrollView.delegate = self;
    _detailsScrollView.pagingEnabled = YES;
    _detailsScrollView.showsHorizontalScrollIndicator = NO;
    [self.goodsImageDetailsScrollView addSubview:_detailsScrollView];
    
    [self initDetailsView];
}

- (void)initEvalutationView {
    
    [_evalutationView removeFromSuperview];
    _evalutationView = [[EvaluationView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, _detailsScrollView.frame.size.height)];
    _evalutationView.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    _evalutationView.evalutationArray = _evalutationArray;
    _evalutationView.evalutationCountArray = _evalutationCountArray;
    [_detailsScrollView addSubview:_evalutationView];
    
    __weak typeof(self)weakSelf =  self;
    _evalutationView.scoreBlock = ^(NSString *level) {
        
        [weakSelf requestEvalutationWithLevel:level];
    };
    
    self.evalutationView.evaluationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomScrollView.contentOffset = CGPointMake(0, -64);
        } completion:^(BOOL finished) {
            [self.evalutationView.evaluationTableView.mj_header endRefreshing];
        }];
    }];
}

- (void)initDetailsView {
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 100)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [_detailsScrollView addSubview:webView];
    
    NSString *urlString = [NSString stringWithFormat:@"api/Phone/ProductInfo.htm?id=%zd",_ProductId];
    urlString = LMMC(urlString);
    NSLog(@"%@",urlString);
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomScrollView.contentOffset = CGPointMake(0, -64);
        } completion:^(BOOL finished) {
            [webView.scrollView.mj_header endRefreshing];
        }];
    }];
}

#pragma mark - 事件处理
#pragma mark 移动button
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_y = location.y - previousLocation.y;
    
    CGRect frame = button.frame;
    if (frame.origin.y < 60) frame.origin.y = 60;
    else if (frame.origin.y > ScreenHeight - 49 - 64 - 45) frame.origin.y = ScreenHeight - 64 - 49 - 45 - 20;
    
    button.frame = frame;
    button.center = CGPointMake(button.center.x, button.center.y + delta_y);

}

#pragma mark - 切换图文详情
- (void)goImageDetails {

    self.goodsDetailsView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //self.bottomScrollView.contentOffset = CGPointMake(0, ScreenHeight - 64 - 50);
            self.bottomScrollView.contentOffset = CGPointMake(0, ScreenHeight - 64);
        } completion:^(BOOL finished) {
            [self.goodsDetailsView.tableView.mj_footer endRefreshing];
        }];
    }];
}

#pragma mark 返回
- (void)back {
    
    [Single sharedInstance].level = 0;
    [Single sharedInstance].isRefreshTitle = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收藏按钮点击
- (void)collectClicked:(UIButton *)btn {
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] == nil ||
       [[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] isEqualToString:@""])
    {
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        [self requestDataFromNetCollect];
    }
}

#pragma mark 分享按钮点击
- (void)shareClicked:(UIButton *)btn {
    
    Pruduct *model = _dataSourse[0];
    NSString *goodsName = model.productName;
    NSString *goodsPrice = model.salePrice;
    NSString *shortDesc = model.shortDesc;
    __block UIImage *iconImg;
    
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
         
         // 设置QQ分享
         [UMSocialQQHandler setQQWithAppId:@"1105606669"
                                    appKey:@"k0uCtHZeQtqKe7Fo"
                                       url:model.productUrl];
         [UMSocialQQHandler setSupportWebView:YES];
         
         // 设置微信分享
         [UMSocialWechatHandler setWXAppId:WECARTAPPID
                                 appSecret:@"6f8462f766e5d976d9cde4fed3c6a8d1"
                                       url:model.productUrl];
     }];
}

#pragma mark 购物车按钮点击
- (void)goShoppingCart {
    
    self.hidesBottomBarWhenPushed = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([Tools isBlankString:[userDefaults objectForKey:@"UID"]]) {
        
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
        
        
        // self.hidesBottomBarWhenPushed = YES;
        // [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
    }
    else {
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[GoodsCartViewController new] animated:YES];
    }
}
    
#pragma mark 立即购买、加入购物车
-(void)addCart:(UIButton *)btn {
    
    NSInteger index = btn.tag;
    
    if (index == 111) {
        
        [self requestGoods];
    }
    else if (index == 222) {
        
        if (_productNum == 0) return [Tools myHud:@"还未选中商品" inView:self.view];
        else {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if ([Tools isBlankString:[defaults objectForKey:@"UID"]]) {
                
                FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
                
                FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
                
                [self presentViewController:navController animated:YES completion:nil];
                
            }
            else {
                
                Pruduct *pruductModel = _dataSourse[0];
                
                self.hidesBottomBarWhenPushed = YES;
                
                ShopCart *shopCartModel = [ShopCart new];
                shopCartModel.productName = pruductModel.productName;
                shopCartModel.productId = [NSString stringWithFormat:@"%zd",_ProductId];
                shopCartModel.ID = [NSString stringWithFormat:@"%zd",_ProductId];
                shopCartModel.productNum = [NSNumber numberWithInteger:_productNum];
                shopCartModel.categoryId = pruductModel.categoryId;
                
                NSString *group_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"];
                if ([group_id intValue] > 1) shopCartModel.salePrice = pruductModel.UserPrice;
                else shopCartModel.salePrice = pruductModel.salePrice;
                
                SubmitOrderViewController *submitOrderVC = [SubmitOrderViewController new];
                submitOrderVC.buySoon = YES;
                submitOrderVC.goodsArray = @[shopCartModel];
                
                if ([_isCollect isEqualToString:@"1"]) {
                    
                    submitOrderVC.isCollect = [_isCollect boolValue];
                    submitOrderVC.midString = self.midStr;
                }
                
                [self.navigationController pushViewController:submitOrderVC animated:YES];
            }
        }
    }
    
    [self getShoppingCartNum];
}

#pragma mark 按钮点击
- (void)btnClick:(UIButton *)btn {
    
    _currentPage = btn.tag - 110;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:btn.tag == 110 ? 111 : 110];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
    
    UILabel *line = (UILabel *)[self.view viewWithTag:210];
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = line.frame;
        frame.origin.x = ScreenWidth / 2 * _currentPage;
        line.frame = frame;
    }];
    
    [_detailsScrollView setContentOffset:CGPointMake(ScreenWidth * (btn.tag - 110), 0) animated:YES];
}

#pragma mark - 数据请求
- (void)requestDataFromNet:(BOOL)isShowHud {
    
    [_dataSourse removeAllObjects];
    
    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    uid = [Tools isBlankString:uid] ? @"0" : uid;
    
    NSString *urlString = [NSString stringWithFormat:GETPRODUCTINFO,[NSString stringWithFormat:@"%zd",_ProductId],uid];
    NSLog(@"详情%@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
    
         Pruduct *model = [[Pruduct alloc]init];
         [model setValuesForKeysWithDictionary:data];
         [_dataSourse addObject:model];
         
         UIButton *_Cbutton = _collectBBI.customView;
         if ([model.IsFolder isEqualToString:@"false"]) {
             _isCollectStr = @"0";
             [_Cbutton setImage:IMAGE(@"收藏") forState:UIControlStateNormal];
         }
         else {
             [_Cbutton setImage:IMAGE(@"已收藏") forState:UIControlStateNormal];
             _isCollectStr = @"1";
         }
         
         // 库存-购物车数量
         _stork = [model.stock integerValue] - [model.CartNum integerValue];
         
         [self initBottomView];
         
         _goodsDetailsView.detailsModel = model;
         
         
     } failure:nil];
}

#pragma mark 收藏请求√
- (void)requestDataFromNetCollect {
    
    NSString *urlString = [NSString stringWithFormat:ADDFOLDER,
                           [NSString stringWithFormat:@"%zd",_ProductId],
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"],
                           [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsID"]];
    NSLog(@"=收藏=%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
     {
    
         if ([data[@"issuccess"] boolValue]) {
             
             UIButton *_Cbutton = _collectBBI.customView;
             if ([_isCollectStr isEqualToString:@"1"]) {
                 _isCollectStr = @"0";
                 [_Cbutton setImage:IMAGE(@"收藏") forState:UIControlStateNormal];
             }
             else{
                 _isCollectStr = @"1";
                 [_Cbutton setImage:IMAGE(@"已收藏") forState:UIControlStateNormal];
             }
             
             [Tools myHud:data[@"context"] inView:self.view];
         }
         
     } failure:nil];
}

#pragma mark 获取购物车数量
- (void)getShoppingCartNum {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    uidString = [Tools isBlankString:uidString] ? @"0" : uidString;
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
     {
         int sum = [[data objectForKey:@"sum"] intValue];
         _emblem.text = [NSString stringWithFormat:@"%d",sum];
         
     } failure:nil];
}

#pragma mark 加入购物车
- (void)requestGoods {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [defaults objectForKey:@"MID"];
    NSString *storeId = [defaults objectForKey:@"merchantsID"];
    
    if ([defaults objectForKey:@"UID"] == nil) {
        
        FSLoginViewController *loginVC = [[FSLoginViewController alloc] init];
        
        FSNavigationController *navController = [[FSNavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navController animated:YES completion:nil];
    }
    
    else {
        
//        Pruduct *model = _dataSourse[0];
        
//        if ([model.PurchaseNum integerValue] != 0) {
//            
//            if ([model.PurchasedNum integerValue] + _productNum > [model.PurchaseNum integerValue]) {
//                return [Tools myHud:[NSString stringWithFormat:@"该商品限购%@份",model.PurchaseNum] inView:self.view];
//            }
//        }

        if (_productNum == 0) [Tools myHud:@"还未选中商品" inView:self.view];
        else if (_productNum > 0 ) {
            
            _openid = UUID;
            _wid = [[defaults objectForKey:@"UID"] integerValue];
            _telphone = [defaults objectForKey:@"mobile"];
            _address = [[defaults objectForKey:@"address"] isEqualToString:@""] ? @"" : [[defaults objectForKey:@"address"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            Pruduct *model = _dataSourse[0];
            
            NSString *string = [NSString stringWithFormat:@"%@",model.salePrice];
            NSString *price = [NSString stringWithFormat:@"%.2f",[string floatValue] *_productNum];
            
            NSString *urlString = [NSString stringWithFormat:ADDSHOPPINGART,_ProductId,_openid,_wid,_telphone,_address,price,_productNum,mid,storeId];
            NSLog(@"==加入购物车==%@",urlString);
            
            if (_stork > 0) {
                
                _stork -= _productNum;
      
                [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:NO success:^(id data)
                 {
      
                     NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"]];
                     
                     if ([issuccess isEqualToString:@"1"]) {
                         [Tools myHud:@"成功加入购物车" inView:[[UIApplication sharedApplication].delegate window]];
                     }
                     else if ([issuccess isEqualToString:@"0"]) {
                         NSLog(@"%@", data[@"context"]);
                         [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
                     }
                     [self requestDataFromNet:NO];
                     [self initBottomView];
                     
                     
                 } failure:^(NSError *error) {
                     NSLog(@"%@", error);
                 }];
            }
            else {
                
                [Tools myHud:@"库存不足" inView:self.view];
            }
        }
    }
}                             

#pragma mark 评价
- (void)requestEvalutationWithLevel:(NSString *)level {
    
    _imageView.hidden = YES;
    
    [_evalutationArray removeAllObjects];
    
    NSString *productId = [NSString stringWithFormat:@"%zd",_ProductId];
    
    NSString *urlString = [NSString stringWithFormat:ScoreUrl,@"0",productId,@"0",level];
    NSLog(@"==商品评价==%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         
         
         NSString *issuccess = [NSString stringWithFormat:@"%@",data[@"issuccess"] ];
         
         if (_evalutationArray.count > 0)
         {
             [_evalutationArray removeAllObjects];
         }
         
         if ([issuccess isEqualToString:@"1"]) {
             
             NSArray *arr = data[@"List"];
             for (NSDictionary *dic in arr) {
                 
                 EvaluationModel *model = [[EvaluationModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 model.contHeight = [Utillity getTextHeightWithText:model.Context width:ScreenWidth - 80 font:[UIFont systemFontOfSize:13]];
                 [_evalutationArray addObject:model];
             }
             
             NSArray *evalutationCountArray = @[@"goods",@"goodH",@"goodZ",@"goodC"];
             for (int i = 0; i < evalutationCountArray.count; i++) {
                 
                 NSString *evalutationCountString = data[evalutationCountArray[i]];
                 [_evalutationCountArray addObject:evalutationCountString];
             }
             
             [self initEvalutationView];
             
             if (arr.count == 0)
             {
                 if (_imageView == nil)
                 {
                     _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50, SCREEN_HEIGHT/2-100, 100, 100)];
                 }
                 _imageView.hidden = NO;
                 _imageView.image = IMAGE(@"无数据");
                 _imageView.contentMode = UIViewContentModeCenter;
                 [_evalutationView addSubview:_imageView];
             }
         }
         
     } failure:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _detailsScrollView) {
        
        _currentPage = scrollView.contentOffset.x / ScreenWidth;
        
        UIButton *button = (UIButton *)[self.view viewWithTag:_currentPage + 110];
        button.titleLabel.textColor = [UIColor colorDomina];
        
        button = (UIButton *)[self.view viewWithTag:!_currentPage + 110];
        button.titleLabel.textColor = [UIColor blackColor];
        
        UILabel *line = (UILabel *)[self.view viewWithTag:210];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame = line.frame;
            frame.origin.x = ScreenWidth / 2 * _currentPage;
            line.frame = frame;
        }];
    }
}

@end
