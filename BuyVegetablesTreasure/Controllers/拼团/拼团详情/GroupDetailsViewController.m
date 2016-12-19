//
//  GroupDetailsViewController.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/26.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "GroupDetailsViewController.h"
#import "PlayGroupView.h"
#import "SubmitGroupViewController.h"
#import "SubmitOrderViewController.h"
#import "GroupDetailsImageViewController.h"
#import "ShopLoginViewController.h"
#import "ShopCart.h"

@interface GroupDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;
}
@end

@implementation GroupDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"拼团详情"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    [self initTableView];
}

-(void)initTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[GroupDateilTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight=_model.titleHight+180+ScreenWidth / 2;
    [self.view addSubview:_tableView];
    
    PlayGroupView *_playGroup=[[PlayGroupView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) andShowNumber:@"1"];
    _playGroup.goPlayGroup=^(){
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[GroupDetailsImageViewController new] animated:YES];
    };
    _tableView.tableFooterView=_playGroup;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([Tools isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]]) {
        
        viewController = [ShopLoginViewController new];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupDateilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell=[[GroupDateilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setGroupModel:_model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.payGroup=^(){
        
        SubmitGroupViewController *submitGroupVC = [SubmitGroupViewController new];
        submitGroupVC.groupModel = _model;
        [self goViewController:submitGroupVC];
    };
    
    cell.payOwn=^{

        ShopCart *shopCartModel = [ShopCart new];
        shopCartModel.productNum = [NSNumber numberWithInt:1];
        shopCartModel.productId = _model.ProductId;
        shopCartModel.productName = _model.ProductName;
        shopCartModel.ID = _model.ProductId;
        shopCartModel.salePrice = _model.salePrice;

        SubmitOrderViewController *submitOrderVC = [SubmitOrderViewController new];
        submitOrderVC.buySoon = YES;
        submitOrderVC.goodsArray = @[shopCartModel];
        [self.navigationController pushViewController:submitOrderVC animated:YES];
    };
    
    return cell;
}

@end
