//
//  MyCollectViewController.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/12/10.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectModel.h"
#import "CollectView.h"
#import "CookingProgramListModel.h"

@interface MyCollectViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) CollectView *collectView;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isGoods;

@end

@implementation MyCollectViewController

- (void)viewWillAppear:(BOOL)animated {
    
    if (_isGoods) {
        
        [self requestDataFromNet];
    }
    else {
        [self getVedioList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF2F2F2"];
//    self.navigationItem.titleView = [Utillity customNavToTitle:@"收 藏"];
    self.title = @"收 藏";
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorDomina];
    
    _isGoods = YES;
    _dataSource = [NSMutableArray array];
    
//    [self initTypeView];
    [self initCollectView];
    [self initDeleteView];
}

#pragma mark - 初始化
#pragma mark 删除
- (void)initDeleteView {
    
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    [self.view addSubview:_deleteView];
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, CGRectGetHeight(_deleteView.frame));
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteView addSubview:btn];
        
        if (i == 0) {
            
            btn.tag = 55;
            btn.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
            [btn setTitle:@" 全选" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0x404040"] forState:UIControlStateNormal];
            [btn setImage:IMAGE(@"FS未选中") forState:UIControlStateNormal];
            [btn setImage:IMAGE(@"FS选中") forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            
            btn.backgroundColor = [UIColor colorDomina];
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteArr) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
    [_deleteView addSubview:line];
}

#pragma mark 类型
- (void)initTypeView {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth / 2 * i, 0, ScreenWidth / 2, CGRectGetHeight(bgView.frame));
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.selected = !i;
        btn.tag = i + 10;
        [btn setTitle:i == 0 ? @"商品" : @"视频" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x606060"] forState:UIControlStateNormal];
        [btn setTitleColor:Color forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame) - 1, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xCECECE"];
    [bgView addSubview:line];
    
    UILabel *moveLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame) - 1, ScreenWidth / 2, 1)];
    moveLine.backgroundColor = Color;
    moveLine.tag = 20;
    [bgView addSubview:moveLine];
}

#pragma mark 初始化CollectView
- (void)initCollectView {
    
    _collectView = [[CollectView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_collectView];
    
    WS(weakSelf);
    _collectView.goViewController = ^(UIViewController *viewController) {
        [weakSelf goViewController:viewController];
    };
    
    _collectView.deleteCollect = ^(NSString *idString) {
        [weakSelf deleteCollectWithId:idString];
    };
    
    _collectView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_isGoods) {
            [self requestDataFromNet];
        }
        else {
            [self getVedioList];
        }
        
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:55];
        btn.selected = NO;
    }];
    
    _collectView.didselectBlock = ^(){
        
        if (weakSelf.collectView.tableView.editing){
            
            NSMutableArray *idArray = [NSMutableArray array];
            if (_dataSource.count > 0) {
                
                for (NSIndexPath *indexPath in weakSelf.collectView.tableView.indexPathsForSelectedRows) {
                    [idArray addObject:indexPath];
                }
                
                UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:55];
                
                if (idArray.count != _dataSource.count) {
                    btn.selected = NO;
                }else{
                    btn.selected = YES;
                }
            }
        }
        
        
    };
}

#pragma mark - 事件处理
#pragma mark 全选
- (void)allSelect:(UIButton *)btn {
    
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
- (void)deleteArr {

    NSMutableArray *idArray = [NSMutableArray array];
    if (_dataSource.count > 0) {
        
        for (NSIndexPath *indexPath in _collectView.tableView.indexPathsForSelectedRows) {
            [idArray addObject:indexPath];
        }
    }

    for (int i = 0; i < idArray.count; i++) {
        
        NSIndexPath *indexPath = idArray[i];
        
        if (_isGoods) {
            
            MyCollectModel *model = _dataSource[indexPath.section];
            [self deleteCollectWithId:model.id];
        }
        else {
            
            CookingProgramListModel *model = _dataSource[indexPath.section];
            [self deleteCollectWithId:model.Id];
        }

    }
    
    _collectView.dataSource = _dataSource;
    [_collectView refreshTableView];
    
    if (_isGoods) [self requestDataFromNet];
    else [self getVedioList];
}

#pragma mark 编辑
- (void)edit {
    
    [_collectView.tableView setEditing:!_collectView.tableView.editing animated:YES];
    _collectView.isEdit = _collectView.tableView.editing;

    CGRect frame = _deleteView.frame;
    frame.origin.y = frame.origin.y + (_collectView.isEdit ? -50 : 50);
    [UIView animateWithDuration:0.3 animations:^{
        _deleteView.frame = frame;
    }];
    
    if (_collectView.tableView.editing) {
        _collectView.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50);
    }else{
        _collectView.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    
    NSString *title = _collectView.tableView.editing ? @"完成" : @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorDomina];
    
}

#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击类型按钮事件
- (void)btnClick:(UIButton *)btn {
    
    UIButton *allsel = (UIButton *)[self.view viewWithTag:55];
    allsel.selected = NO;
    
    for (int i = 0; i < 2; i++) {
        [(UIButton *)[self.view viewWithTag:i + 10] setSelected:NO];
    }
    
    btn.selected = YES;
    
    CGRect frame = [self.view viewWithTag:20].frame;
    frame.origin.x = ScreenWidth / 2 * (btn.tag - 10);
    [UIView animateWithDuration:0.3 animations:^{
        [(UILabel *)[self.view viewWithTag:20] setFrame:frame];
    }];
    
    _collectView.dataSource = nil;
    [_collectView refreshTableView];

    if (btn.tag == 10) {
        [self requestDataFromNet];
    }
    else {
        [self getVedioList];
    }
}

#pragma mark 前往控制器
- (void)goViewController:(UIViewController *)viewController {
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 获取数据
- (void)requestDataFromNet {
    
    NSString *urlString = [NSString stringWithFormat:GETFOLDERPRODUCT,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    NSLog(@"===我的收藏==%@",urlString);
    
    [HttpRequest sendRequest:urlString param:nil requestStyle:Get setSerializer:Date success:^(id data) {
        
        if ([data[@"issuccess"] boolValue]) {
            
            _isGoods = YES;
            [_dataSource removeAllObjects];
            
            for (NSDictionary *dict in data[@"List"]) {
                
                MyCollectModel *model = [[MyCollectModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataSource addObject:model];
            }
            
            if (_dataSource.count > 0) {
                
                _collectView.hidden = NO;
                _collectView.isGoods = YES;
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
            
            _isGoods = YES;
            
            _collectView.hidden = YES;
            _collectView.isGoods = YES;
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

#pragma mark 获取视频列表
- (void)getVedioList {

    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MID"];
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:GetVedioCollection,midString,uidString];
    NSLog(@"%@",urlString);
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {

             _isGoods = NO;
             [_dataSource removeAllObjects];
             
             for (NSDictionary *dic in data[@"List"]) {
                 
                 CookingProgramListModel *model = [[CookingProgramListModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 [_dataSource addObject:model];
             }
             
             if (_dataSource.count > 0) {
             
                 _collectView.hidden = NO;
                 _collectView.isGoods = NO;
                 _collectView.dataSource = _dataSource;
                 [_collectView refreshTableView];
             }
             else {
              
                 _collectView.hidden = YES;
                 [Tools myHud:@"暂无收藏视频" inView:self.view];
             }
             
             [_collectView.tableView.mj_header endRefreshing];
         }
         else {
             
             _isGoods = NO;
             [_collectView.tableView.mj_header endRefreshing];
         }
         
     } failure:^(NSError *error) {
         [Tools myHud:@"服务器异常,稍后再试!" inView:self.view];
     }];
}

#pragma mark 删除收藏请求
- (void)deleteCollectWithId:(NSString *)idString {
    
    NSString *urlString;

    // 判断是否商品
    if (_isGoods) {
        
        MyCollectModel *model;
        for (int i = 0; i < _dataSource.count; i++) {
            
            model = _dataSource[i];
            if ([idString intValue] == [model.id intValue]) {
                break;
            }
        }
        urlString = [NSString stringWithFormat:DELFOLDER,[NSString stringWithFormat:@"%@",model.Tid]];
    }
    else {
        
        NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
        urlString = [NSString stringWithFormat:RemoveVedioCollection,idString,uidString];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlString);

    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             for (int a = 0; a < _dataSource.count; a++) {
                 
                 if (_isGoods) {
                     
                     MyCollectModel *model = _dataSource[a];
                     if ([idString intValue] == [model.id intValue]) {
                         [_dataSource removeObjectAtIndex:a];
                         break;
                     }
                 }
                 else {
                     
                     CookingProgramListModel *model = _dataSource[a];
                     if ([idString intValue] == [model.Id intValue]) {
                         [_dataSource removeObjectAtIndex:a];
                         break;
                     }
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


@end
