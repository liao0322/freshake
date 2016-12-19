//
//  New&HotViewController.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/1/12.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "New&HotViewController.h"
#import "MyCollectTableViewCell.h"
#import "New&HotTableViewCell.h"
#import "ShopLoginViewController.h"
#import "GoodsCartViewController.h"
#import "MyCollectModel.h"
#import "GoodsDetailViewController.h"
#import "NewPruduct.h"

@interface New_HotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataScore;
    UILabel *emblem;
    UIImageView *_cartAnimView;
    NSInteger    _stork;
}


@end

@implementation New_HotViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestDataFromNet];
    [self getShoppingCartNum];
    [self initShoppingCartIconView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.titleView = [Utillity customNavToTitle:_Navtitle];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    _dataScore=[NSMutableArray array];
    [self initTableView];
    [self initShoppingCartIconView];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 初始化tableView
-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[New_HotTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_dataScore.count > 0)
        {
            [_dataScore removeAllObjects];
        }
        
        [self requestDataFromNet];
        [self getShoppingCartNum];
        
    }];
    
    [self.view addSubview:_tableView];
}
#pragma mark 初始化购物车图标
- (void)initShoppingCartIconView {
    
    [(UIButton *)[self.view viewWithTag:100001] removeFromSuperview];
    
    UIButton *shoppingCartIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCartIconButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 75 - 64 - 25, 45, 45);
    [shoppingCartIconButton setImage:IMAGE(@"购物车背景") forState:UIControlStateNormal];
    shoppingCartIconButton.tag = 100001;
    //    [shoppingCartIconButton addTarget:self action:@selector(goShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [shoppingCartIconButton addTarget:self action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:shoppingCartIconButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShoppingCart)];
    [shoppingCartIconButton addGestureRecognizer:tap];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(shoppingCartIconButton.frame.size.width / 2 - 7.5, 5, 15, 10)];
    [bgView setImage:IMAGE(@"数字圈")];
    [shoppingCartIconButton addSubview:bgView];
    
    emblem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    emblem.font = [UIFont systemFontOfSize:8];
    emblem.textColor = [UIColor blackColor];
    emblem.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:emblem];
    
    if (isPad) {
        
        CGRect frame = shoppingCartIconButton.frame;
        frame.origin.x = SCREEN_WIDTH - 75;
        frame.size.height = 55;
        frame.size.width = 55;
        shoppingCartIconButton.frame = frame;
        
        frame = bgView.frame;
        frame.origin.x = shoppingCartIconButton.frame.size.width/2-7.5;
        bgView.frame = frame;
        
        emblem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
        emblem.font = [UIFont systemFontOfSize:9];
        emblem.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:emblem];
    }
    
    [self getShoppingCartNum];
}
#pragma mark - 移动购物车
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

#pragma mark - 设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataScore.count>0)
    {
        return _dataScore.count;
    }
    return 0;
}
#pragma mark - 设置行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *isNewPruduct = @"0";
    New_HotTableViewCell *_cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_dataScore.count>0)
    {
        NewPruduct *model=_dataScore[indexPath.section];
        if ([_latest isEqualToString:@"1"])
        {
            isNewPruduct = @"1";
        }
        [_cell setData:model isNewPruduct:isNewPruduct];
        __weak typeof(_cell)weakCell = _cell;
        _cell.addCart=^()
        {
            _stork = [model.stock integerValue] - [model.CartNum integerValue];
            if (_stork > 0)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                // 用户ID
                NSString *uid     = [userDefaults objectForKey:@"UID"];
                if ([Tools isBlankString:uid])
                {
                    [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
                    return;
                }
                //动画
                CGRect rect = [weakCell.ImageView convertRect:weakCell.ImageView.bounds toView:self.view];
                [self initImage:rect withImage:weakCell.ImageView.image];
                //修改模型购物车数量值
                model.CartNum = [NSString stringWithFormat:@"%zd",[model.CartNum integerValue] + 1];
                //购物车数量
//                emblem.text =[NSString stringWithFormat:@"%zd",[emblem.text integerValue] + 1];
//                emblem.hidden = [emblem.text integerValue] > 0 ? NO : YES;
            
                //加入购物车
                [self addGoodsRequestWithGoodsId:[model.Id stringValue] ProductNum:model.CartNum TotPrice:([emblem.text integerValue] + 1) * [model.salePrice integerValue]];
            }
            else
            {
                [Tools myHud:@"库存不足" inView:self.view];
            }
            
        };
        
        [_cell setImageClick:^(NewPruduct *model) {

            self.hidesBottomBarWhenPushed = YES;
            
            GoodsDetailViewController *detail = [GoodsDetailViewController new];
            detail.ProductId = [model.Id integerValue];
            [self.navigationController pushViewController:detail animated:YES];


        }];
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return _cell;
}
#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - 设置段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    return 5;
}
#pragma mark - 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark 获取数据
-(void)requestDataFromNet
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [Tools isBlankString:[userDefaults objectForKey:@"UID"]] ? @"" : [userDefaults objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GETPRUCTLIST,midString,uidString,_specialOffer,_latest];

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
    {
        if ([[NSString stringWithFormat:@"%@",data[@"issuccess"]] isEqualToString:@"1"]) {
            
            [_dataScore removeAllObjects];

            for (NSDictionary *dict in data[@"ClassList"]) {
                NewPruduct *model = [[NewPruduct alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataScore addObject:model];
            }
        }
        
        if (_dataScore.count == 0) {
            
            _tableView.hidden = YES;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50, SCREEN_HEIGHT/2-100, 100, 100)];
            imageView.image = IMAGE(@"无数据");
            imageView.contentMode = UIViewContentModeCenter;
            [self.view addSubview:imageView];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [Tools myHud:@"加载失败！请重新加载" inView:[[UIApplication sharedApplication].delegate window]];
    }];
    
    [_tableView.mj_header endRefreshing];
}

#pragma mark 获取购物车数量
- (void)getShoppingCartNum
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             int sum = [[data objectForKey:@"sum"] intValue];
             emblem.text = [NSString stringWithFormat:@"%d",sum];
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
         [_tableView reloadData];
         
     } failure:nil];
}

#pragma mark 加入购物车请求
- (void)addGoodsRequestWithGoodsId:(NSString *)productId ProductNum:(NSString *)productNum TotPrice:(NSInteger )totPrice
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 用户ID
    NSString *uid     = [userDefaults objectForKey:@"UID"];
    NSString *mid     = [userDefaults objectForKey:@"MID"];
    NSString *storeId = [userDefaults objectForKey:@"merchantsID"];
    NSString *totPriceString = [NSString stringWithFormat:@"%zd",totPrice];
    
    NSString *urlString;
    
    if ([Tools isBlankString:uid])
    {
        [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
        return;
    }
    else
    {
        switch ([productNum integerValue])
        {
                    
            case 1:
                    
                urlString = [NSString stringWithFormat:ADDCARTURL,productId,UUID,uid,totPriceString,productNum,mid,storeId];
                break;
                    
            default:
                urlString = [NSString stringWithFormat:UpCart,UUID,mid,productId,uid,productNum,@"0"];
                break;
        }
        
        [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
         {
             if ([data[@"issuccess"] boolValue]) {
                 
                 emblem.text =[NSString stringWithFormat:@"%zd",[emblem.text integerValue] + 1];
             }
             else [Tools myHud:data[@"context"] inView:self.view];
             
             [_tableView reloadData];
             
         } failure:nil];
    }
}
#pragma mark 进入购物车
- (void)goShoppingCart
{
    self.hidesBottomBarWhenPushed = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([Tools isBlankString:[userDefaults objectForKey:@"UID"]])
    {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
    }
    else
    {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[GoodsCartViewController new] animated:YES];
    }
}

#pragma mark 加入购物车动画
- (void)initImage:(CGRect)rect withImage:(UIImage *)image {
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:100001];
    
    _cartAnimView = [[UIImageView alloc] initWithFrame:rect];
    _cartAnimView.image = image;
    [self.view addSubview:_cartAnimView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    //这个是让旋转动画慢于缩放动画执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_cartAnimView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
    
    [UIView animateWithDuration:1.0 animations:^{
        
        if (isPad) {
            _cartAnimView.frame=CGRectMake(btn.frame.origin.x + 27.5, btn.frame.origin.y + 27.5, 0, 0);
        }
        else {
            _cartAnimView.frame=CGRectMake(btn.frame.origin.x + 27.5, btn.frame.origin.y + 27.5, 0, 0);
        }
        
    } completion:^(BOOL finished) {
        [_cartAnimView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
