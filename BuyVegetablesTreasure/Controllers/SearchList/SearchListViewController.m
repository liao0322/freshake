//
//  SearchListViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/3.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "SearchListViewController.h"
#import "PopularityView.h"
#import "SearchListCell.h"
#import "SearchModel.h"
#import "ShoppingCartModel.h"
#import "ShopLoginViewController.h"
#import "GoodsCartViewController.h"
#import "GoodsDetailViewController.h"

@interface SearchListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    PopularityView *_popularityCollectionView;
    
    UITextField *searchTextField;
    UILabel *emblem;
    
    NSMutableArray *searchArray;
    NSMutableArray *_shoppingCartGoodsArray;
    
    NSInteger _productNum;
    NSInteger _wtotPrice;
    NSInteger _goodsID;
    
    UIImageView *_cartAnimView;
}
@end

@implementation SearchListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
    [self getShoppingCartNum];
    [self initShoppingCartIconView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchArray = [NSMutableArray array];
    _shoppingCartGoodsArray = [NSMutableArray array];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    // 确认按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"0xfd9d15"];
    
    // 搜索文本框
    searchTextField = [[UITextField alloc] init];
    searchTextField.frame = CGRectMake(0, 0, SCREEN_WIDTH - 100, 30);
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.placeholder = _urlString;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [searchTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.navigationItem.titleView = searchTextField;
    
    [self initCollectionView];
    [self initShoppingCartIconView];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    if ([Tools isBlankString:textField.text])
    {
        searchTextField.placeholder = @"请输入关键字";
    }
}

// 返回按钮事件
- (void)back{
    [searchTextField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)ok
{
    [searchTextField resignFirstResponder];
    if ([Tools isBlankString:searchTextField.text]) {
        [Tools myHud:@"请输入关键字" inView:self.view];
        return;
    }
    _urlString = searchTextField.text;
    [searchTextField resignFirstResponder];
    [self request];
}

#pragma mark - 初始化控件
- (void)initCollectionView
{
    
    _popularityCollectionView = [[PopularityView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _popularityCollectionView.popularityCollectionView.dataSource = self;
    _popularityCollectionView.popularityCollectionView.delegate   = self;
    
    [_popularityCollectionView.popularityCollectionView registerNib:[UINib nibWithNibName:@"SearchListCell" bundle:nil]forCellWithReuseIdentifier:@"SearchListCell"];
    _popularityCollectionView.popularityCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (searchArray.count > 0)
        {
            [searchArray removeAllObjects];
        }
        [self request];
        [self getShoppingCartNum];
        
    }];
    
    [self.view addSubview:_popularityCollectionView];
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
#pragma mark 移动button
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
//    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    CGRect frame = button.frame;
    if (frame.origin.y < 60) frame.origin.y = 60;
    else if (frame.origin.y > ScreenHeight - 49 - 64 - 45) frame.origin.y = ScreenHeight - 64 - 49 - 45 - 20;
    
    button.frame = frame;
    button.center = CGPointMake(button.center.x, button.center.y + delta_y);
}

#pragma mark 获取购物车数量
- (void)getShoppingCartNum{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    
    uidString = [Tools isBlankString:uidString] ? @"0" : uidString;
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTNUM,UUID,uidString,midString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         int sum = [[data objectForKey:@"sum"] intValue];
         emblem.text = [NSString stringWithFormat:@"%d",sum];
         
     } failure:nil];
}

#pragma mark 前往购物车
- (void)goShoppingCart
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[GoodsCartViewController new] animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (searchArray.count > 0)
    {
        return searchArray.count;
    }
    
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchListCell"
                                                                     forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (searchArray.count > 0)
    {
        [cell setImageClick:^{
           
            SearchModel *model = searchArray[indexPath.row];
            
            self.hidesBottomBarWhenPushed = YES;
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            goods.ProductId = [model.id integerValue];
            [self.navigationController pushViewController:goods animated:YES];
            
        }];

        
        __weak typeof(cell)weakCell = cell;
        cell.goodsNumBlock = ^(NSString *goodsNum,NSString *goodsID,BOOL isAdd,BOOL isEnough)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uidString = [defaults objectForKey:@"UID"];
            if ([Tools isBlankString:uidString])
            {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
                return ;
            }
            else
            {
                if (isAdd == NO && isEnough == YES)
                {
                    CGRect rect = [weakCell.goodsImage convertRect:weakCell.goodsImage.bounds toView:self.view];
                    
                    [self initImage:rect withImage:weakCell.goodsImage.image];
                }

                BOOL a = YES;
                int num = 0;
                
                if (isEnough == NO && isAdd == NO)
                {
                    [Tools myHud:@"库存不足" inView:self.view];
                    return;
                }
                else num = isAdd ? num - 1 :num + 1;
                
                if ([goodsNum integerValue] == 2 || isAdd == NO) a = NO;
                else if ([goodsNum integerValue] == 0) a = NO;
                
                _num = num;
                
                SearchModel *model = searchArray[indexPath.row];
                
                [self addGoodsRequestWithGoodsId:goodsID
                                      ProductNum:goodsNum
                                        TotPrice:([emblem.text integerValue] + num) * [model.salePrice integerValue]
                                           IsAdd:a type:isAdd
                              ForItemAtIndexPath:indexPath];
            }
        };
        
        SearchModel *model = searchArray[indexPath.row];
        [cell setModel:model];
        
        _wtotPrice = [model.salePrice integerValue];
        
    }
    
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - 数据请求
- (void)request{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *uid = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:QUERYGOODS,_urlString,@"1",mid,uid];
    NSString *jsonString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [HttpRequest sendGetOrPostRequest:jsonString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         
         if (searchArray.count > 0) {
             [searchArray removeAllObjects];
         }
         
         NSArray *arr = data[@"ClassList"];
         
         for (NSDictionary *dic in arr) {
             
             for (NSDictionary *dcit in dic[@"List"]) {
                 
                 SearchModel *model = [[SearchModel alloc] init];
                 [model setValuesForKeysWithDictionary:dcit];
                 
                 [searchArray addObject:model];
             }
         }
         
         //停止刷新
         [_popularityCollectionView.popularityCollectionView.mj_header endRefreshing];
         [_popularityCollectionView.popularityCollectionView reloadData];

         if (searchArray.count ==0 ) {
             [Tools myHud:@"抱歉，未搜索到任何商品" inView:self.view];
         }
         
     } failure:^(NSError *error) {
         [_popularityCollectionView.popularityCollectionView.mj_header endRefreshing];
     }];
}

- (void)addGoodsRequestWithGoodsId:(NSString *)productId
                        ProductNum:(NSString *)productNum
                          TotPrice:(NSInteger )totPrice
                             IsAdd:(BOOL)isAdd
                              type:(BOOL)type
                ForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 用户ID
    NSString *wid = [userDefaults objectForKey:@"UID"];
    NSString *mid = [userDefaults objectForKey:@"MID"];
    NSString *storeId = [userDefaults objectForKey:@"merchantsID"];
    NSString *totPriceString = [NSString stringWithFormat:@"%zd",totPrice];
    
    NSLog(@"userId = %@",wid);
    
    NSString *urlString;
    
    if (wid == nil) {
        
        [self.navigationController pushViewController:[ShopLoginViewController new] animated:YES];
        return;
    }
    else if ( isAdd == YES ) {
        
        NSString *t;
        if (type == NO)
        {
            t = @"0";
        }
        else
        {
            t = @"1";
        }
        urlString = [NSString stringWithFormat:UpCart,UUID,mid,productId,wid,productNum,t];
    }
    else {
        
        switch ([productNum integerValue]) {
            case 0:
                
                urlString = [NSString stringWithFormat:DelCartUrl,UUID,mid,productId,wid];
                break;
                
            case 1:
                
                urlString = [NSString stringWithFormat:ADDCARTURL,productId,UUID,wid,totPriceString,productNum,mid,storeId];
                break;
                
            default:
                NSLog(@"更新商品");
                NSString *t;
                if (type == NO)
                {
                    t = @"0";
                }
                else
                {
                    t = @"1";
                }
                urlString = [NSString stringWithFormat:UpCart,UUID,mid,productId,wid,productNum,t];
                break;
        }
    }
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
         NSLog(@"更新成功");
         NSLog(@"%@",urlString);
         
         if ([data[@"issuccess"] boolValue]) {
             
             SearchModel *model = searchArray[indexPath.row];
             model.CartNum = [NSString stringWithFormat:@"%zd",[model.CartNum integerValue] + _num];
             [searchArray replaceObjectAtIndex:indexPath.row withObject:model];
             SearchListCell *cell = (SearchListCell *)[_popularityCollectionView.popularityCollectionView cellForItemAtIndexPath:indexPath];
             cell.goddsNumLabel.text = model.CartNum;
             
             emblem.text = [NSString stringWithFormat:@"%zd",[emblem.text integerValue] + _num];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}

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

@end
