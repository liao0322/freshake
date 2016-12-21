//
//  FSShoppingCartViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/16.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSShoppingCartViewController.h"
#import "ShopCart.h"
#import "FSShoppingCartTVCell.h"
#import "FSShoppingCartBottomView.h"
#import "FSShoppingCartTVFooterView.h"

@interface FSShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSMutableArray *commodityArray;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic) FSShoppingCartBottomView *bottomView;

@property (nonatomic) FSShoppingCartTVFooterView *footerView;

@end

@implementation FSShoppingCartViewController

static NSString * const shoppingCartTVCellID = @"shoppingCartTVCellID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)getDataFromRemote {
    // 获取购物车商品数据
    [self getCommodityData];
    
}

- (void)initialization {
    [super initialization];
    
    self.title = @"购物车";
}

- (void)addSubviews {
    [super addSubviews];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    
    self.bottomView.width = self.view.width;
    self.bottomView.height = 49;
    self.bottomView.x = 0;
    self.bottomView.bottom = self.view.height - 49;
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSShoppingCartTVCell class]) bundle:nil] forCellReuseIdentifier:shoppingCartTVCellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (self.commodityArray.count) {
        rows = self.commodityArray.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSShoppingCartTVCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartTVCellID forIndexPath:indexPath];
    
    cell.model = self.commodityArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == (self.commodityArray.count - 1)) {
        self.tableView.tableFooterView = self.footerView;
        self.tableView.tableFooterView.height = 120;
    }
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            // 改变总价
            /*
            Wine *wine = self.wines[row];
            if (wine.isSelect) {
                NSInteger price = [wine.count integerValue] * [wine.discount integerValue];
                _totalPrice -= price;
                [_totalPricesLabel setText:[NSString stringWithFormat:@"￥%.2f", _totalPrice]];
            }
             */
            
            // 执行删除操作
            //[self.wines removeObjectAtIndex:row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tableView setEditing:NO animated:YES];
        }];
        
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    
    return @[removeAction];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / (375 / 130.0f);
}

#pragma mark - Custom

- (void)getCommodityData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [defaults objectForKey:@"UID"];
    NSString *midString = [defaults objectForKey:@"MID"];
    NSString *urlString = [NSString stringWithFormat:SHOPPINGCARTGOODS,UUID,uidString,midString];
    NSLog(@"===购物车请求===%@",urlString);
    
    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dataDict = [self dictWithData:responseObject];
        
        [self.commodityArray removeAllObjects];
        
        if ([dataDict[@"issuccess"] boolValue]) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataDict[@"point"] forKey:@"point"];
            [userDefaults setObject:dataDict[@"TickCount"] forKey:@"TickCount"];
            
            for (NSDictionary *dic in dataDict[@"list"]) {
                
                ShopCart *model = [ShopCart modelWithDict:dic];
                [self.commodityArray addObject:model];
            }
            self.footerView.hidden = NO;
            self.bottomView.hidden = NO;
            [self.tableView reloadData];
            
            /*
            if (_goodsCartArray.count > 0) {
                _bottomView.hidden = NO;
                _goodsCartTableView.hidden = NO;
                _goodsCartTableView.goodsCartArray = _goodsCartArray;
                [_goodsCartTableView refreshTableView];
            }
            else {
                _bottomView.hidden = YES;
                _goodsCartTableView.hidden = YES;
            }
            
            [self initBottomView];
             */
        }
        else {
            
            /*
            if (_goodsCartArray.count == 0) {
                _bottomView.hidden = YES;
                _goodsCartTableView.hidden = YES;
            }
             */
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];
    }];
    
}

#pragma mark -
#pragma mark - LazyLoad

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
        
    }
    return _commodityArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshControl = self.refreshControl;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        //_tableView.tableFooterView.height = 10;
        //_tableView.tableFooterView = self.footerView;

    }
    return _tableView;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(getDataFromRemote) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (FSShoppingCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShoppingCartBottomView class]) owner:self options:nil] lastObject];
        
        _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOpacity = .3f;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.layer.shadowRadius = 2;
        //_bottomView.layer.shouldGroupAccessibilityChildren = NO;
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (FSShoppingCartTVFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FSShoppingCartTVFooterView class]) owner:self options:nil] lastObject];
        _footerView.hidden = YES;
    }
    return _footerView;
}

@end
