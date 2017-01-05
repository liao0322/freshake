//
//  FSMyCollectViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSMyCollectViewController.h"
#import "MyCollectModel.h"
#import "CollectView.h"


@interface FSMyCollectViewController ()

@property (nonatomic, strong) CollectView *collectView;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FSMyCollectViewController

- (void)viewWillAppear:(BOOL)animated {
    [self connectDataFromNet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    self.title = @"收 藏";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorDomina];
    
    _dataSource = [NSMutableArray array];
    
    
    [self initCollectView];
    [self initDeleteView];
}

#pragma mark - 删除
- (void)initDeleteView {
    
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    [self.view addSubview:_deleteView];
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, CGRectGetHeight(_deleteView.frame));
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_deleteView addSubview:btn];
        
        if (i == 0) {
            btn.tag = 55;
            btn.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
            [btn setTitle:@"   全选" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
            [btn setImage:IMAGE(@"FS未选中") forState:UIControlStateNormal];
            [btn setImage:IMAGE(@"FS选中") forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            btn.backgroundColor = [UIColor colorDomina];
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteClickArr) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xb2b2b2"];
    [_deleteView addSubview:line];
}

#pragma mark 初始化CollectView
- (void)initCollectView {
    
    _collectView = [[CollectView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_collectView];
    
    WS(weakSelf);
    
    _collectView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    _collectView.deleteCollect = ^(NSString *idStr) {
        [weakSelf deleteCollectWithShopId:idStr];
    };
    
    _collectView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self connectDataFromNet];
        
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:55];
        btn.selected = NO;
    }];
    
    _collectView.didselectBlock = ^(){
      
        if (weakSelf.collectView.tableView.editing) {
            
            NSMutableArray *idArray = [NSMutableArray array];
            if (_dataSource.count > 0) {
                
                for (NSIndexPath *indexPath in weakSelf.collectView.tableView.indexPathsForSelectedRows) {
                    [idArray addObject:indexPath];
                }
                
                UIButton *btn = (UIButton *)[weakSelf.view  viewWithTag:55];
                
                if (idArray.count != _dataSource.count) {
                    btn.selected = NO;
                    
                } else {
                    btn.selected = YES;
                }
            }
        }
    };
}

#pragma mark 全选
- (void)allSelectClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        
        if (btn.selected) {
            [_collectView.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [_collectView.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark 删除所选
- (void)deleteClickArr {
    
    NSMutableArray *idArray = [NSMutableArray array];
    if (_dataSource.count > 0) {
        
        for (NSIndexPath *indexPath in _collectView.tableView.indexPathsForSelectedRows) {
            [idArray addObject:indexPath];
        }
    }
    
    for (int i = 0; i < idArray.count; i++) {
        
        NSIndexPath *indexPath = idArray[i];
        
       
            
            MyCollectModel *model = _dataSource[indexPath.section];
            [self deleteCollectWithShopId:model.id];
       
        
    }
    
    _collectView.dataSource = _dataSource;
    [_collectView refreshTableView];
    
    [self connectDataFromNet];

}

#pragma mark 编辑
- (void)editClick {
    
    [_collectView.tableView setEditing:!_collectView.tableView.editing animated:YES];
    _collectView.isEdit = _collectView.tableView.editing;
    
    CGRect frame = _deleteView.frame;
   
    if (_collectView.tableView.editing) {
        _collectView.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50);
        frame.origin.y = frame.origin.y - 50;
        
    } else{
        _collectView.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        frame.origin.y = ScreenHeight;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _deleteView.frame = frame;
    }];
    
    NSString *title = _collectView.tableView.editing ? @"完成" : @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorDomina];
}

#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 获取收藏列表数据
- (void)connectDataFromNet {
    NSString *urlString = [NSString stringWithFormat:GETFOLDERPRODUCT, [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    NSLog(@"*****我的收藏****%@", urlString);
    
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Date success:^(id data) {
        if ([data [@"issuccess"] boolValue]) {
            [_dataSource removeAllObjects];
            for (NSDictionary *dict in data[@"List"]) {
                MyCollectModel *model = [[MyCollectModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataSource addObject:model];
                NSLog(@"**********%@^^^^^^^^^^",_dataSource);
            }
            
            if (_dataSource.count > 0) {
                
                _collectView.hidden = NO;
//                _collectView.isGoods = YES;
                _collectView.dataSource = _dataSource;
                [_collectView refreshTableView];
            }
            else {
                _collectView.hidden = YES;
                [Tools myHud:@"暂无收藏商品" inView:self.view];
            }
            
            [_collectView.tableView.mj_header endRefreshing];
        }
        else {
            
            _collectView.hidden = YES;
//            _collectView.isGoods = YES;
            _collectView.dataSource = _dataSource;
            [_dataSource removeAllObjects];
            [_collectView refreshTableView];
            
            [_collectView.tableView.mj_header endRefreshing];
            
            [Tools myHud:@"暂无收藏商品" inView:self.view];
        }
    } failure:^(NSError *error) {
       
        [_collectView.tableView.mj_header endRefreshing];
        
        [Tools myHud:@"服务器异常,稍后再试!" inView:self.view];
    }];
}

#pragma mark 删除收藏请求

- (void)deleteCollectWithShopId:(NSString *)idStr {
    NSString *urlString;
    
    MyCollectModel *model;
    for (int i = 0; i < _dataSource.count; i++) {
        model = _dataSource[i];
        if ([idStr intValue] == [model.id intValue]) {
            break;
        }
    }
    urlString = [NSString stringWithFormat:DELFOLDER,[NSString stringWithFormat:@"%@", model.Tid]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data) {
        if ([data[@"issuccess"] boolValue]) {
            
            for (int a = 0; a < _dataSource.count; a++) {
                MyCollectModel *model = _dataSource[a];
                if ([idStr intValue] == [model.id intValue]) {
                    [_dataSource removeObjectAtIndex:a];
                    break;
                }
            }
            _collectView.dataSource = _dataSource;
            [_collectView refreshTableView];
        }
        [Tools myHud:data[@"context"] inView:self.view];
    } failure:^(NSError *error) {
        [Tools myHud:@"服务器异常,稍后再试!" inView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
