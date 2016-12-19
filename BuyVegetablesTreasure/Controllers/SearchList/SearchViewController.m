//
//  SearchViewController.m
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/3.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "SearchViewController.h"
#import "HotTableViewCell.h"
#import "SearchListViewController.h"
#import "SearchModel.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    NSString *_isShowHistory;
    NSString *_searchMessger;
    NSString *_titleString;
    NSMutableArray *historySearchArray;
    NSMutableArray *hotSearchArray;
    NSMutableArray *queryArray;
    
    UISearchBar *_searchBar;
    UITableView *_tableView;
    UITableView *queryTableView;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"0xff6600"];
    
    historySearchArray=[NSMutableArray array];
    hotSearchArray=[NSMutableArray array];
    queryArray = [NSMutableArray array];
    
    [self initTableView];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] && ![[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"] isEqualToString:@""]) {
        _isShowHistory=@"1";
        [self HistoryRequest];
    }else{
        _isShowHistory=@"0";
    }
    [self HotRequest];
    [self initTextField];
    [self initQueryTableView];
}

-(void)back {
    
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化输入框
-(void)initTextField {
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.navigationItem.leftBarButtonItem.width, 0.0f, SCREEN_WIDTH - (self.navigationItem.leftBarButtonItem.width) - (self.navigationItem.rightBarButtonItem.width), 50)];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    _searchBar.showsCancelButton = NO;
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.delegate = self;
    _titleString = _searchBar.placeholder;
    self.navigationItem.titleView = _searchBar;
    
//    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 30)];
//    _textField.borderStyle = UITextBorderStyleRoundedRect;
//    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _textField.delegate = self;
//    self.navigationItem.titleView = _textField;
    
//    [_textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldEditChanged:(UITextField *)textField {
    
    [self QueryGoodsWithText:textField.text];
}

#pragma mark 初始化UITableView
-(void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTableView)];
    [_tableView addGestureRecognizer:tap];
    
    [_tableView registerClass:[HotTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)initQueryTableView {
    
    queryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT - 64)];
    queryTableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    queryTableView.hidden = YES;
    queryTableView.tableFooterView = [[UIView alloc] init];
    queryTableView.dataSource = self;
    queryTableView.delegate = self;
    [self.view addSubview:queryTableView];
    [queryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QueryCell"];
}

#pragma mark - 热门搜索数据请求
- (void)HotRequest {
    
    NSString *urlString = [NSString stringWithFormat:GetHotS,[[NSUserDefaults standardUserDefaults] objectForKey:@"MID"]];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
        
            [hotSearchArray removeAllObjects];
            
            for (NSDictionary *dic in data[@"list"]) {
                [hotSearchArray addObject:dic[@"context"]];
            }
            
            for (NSDictionary *dic in data[@"list1"]) {
                [hotSearchArray addObject:dic[@"hotContext"]];
            }
        }
        else [Tools myHud:data[@"context"] inView:self.view];
        
        _searchBar.placeholder = data[@"searchMessger"];
        
        [_tableView reloadData];
        
    } failure:nil];
}

#pragma mark - 历史搜索数据请求
- (void)HistoryRequest {
    
    NSString *urlString = [NSString stringWithFormat:HISTORYURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             if (historySearchArray.count > 0) {
                 [historySearchArray removeAllObjects];
             }
             
             for (NSDictionary *dic in data[@"list"]) {
                 [historySearchArray addObject:dic[@"context"]];
             }
             
             if (historySearchArray.count > 0) {
                 _isShowHistory = @"1";
             }
             else {
                 _isShowHistory = @"0";
             }
             

         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
         [_tableView reloadData];
         
     } failure:nil];
}

#pragma mark - 删除历史记录数据请求
- (void)DelHistoryRequest {
    
    NSString *urlString = [NSString stringWithFormat:DELSEARCH,[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             _isShowHistory = @"0";
             [historySearchArray removeAllObjects];
         }
         else [Tools myHud:data[@"context"] inView:self.view];
         
         [_tableView reloadData];
         
     } failure:nil];
}

#pragma mark - 查询商品
- (void)QueryGoodsWithText:(NSString *)text {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *jsonString = [NSString stringWithFormat:QUERYGOODS,text,@"1",midString,uidString];
    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonString);

    [HttpRequest sendGetOrPostRequest:jsonString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         [queryArray removeAllObjects];
         
         NSArray *arr = data[@"ClassList"];
         
         for (NSDictionary *dic in arr) {
             
             for (NSDictionary *dict in dic[@"List"]) {
                 SearchModel *model = [[SearchModel alloc] init];
                 [model setValuesForKeysWithDictionary:dict];
                 [queryArray addObject:model];
             }
         }
         
         for (int i = 0; i < queryArray.count; i++) {
             SearchModel *model = queryArray[i];
             NSLog(@"%@",model.productName);
         }
         
         [queryTableView reloadData];
         
     } failure:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) return [_isShowHistory isEqualToString:@"1"] ? 2 : 1;
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == queryTableView) return queryArray.count;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == _tableView) {
        HotTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.section==0) {
            [cell SetupUIWithArray:hotSearchArray];
            cell.GoSearch=^(NSInteger butTag){
                self.hidesBottomBarWhenPushed=YES;
                SearchListViewController *_SVC=[[SearchListViewController alloc]init];
                _SVC.urlString=hotSearchArray[butTag-100];
                [self.navigationController pushViewController:_SVC animated:YES];
            };
        }else{
            [cell SetupUIWithArray:historySearchArray];
            cell.GoSearch=^(NSInteger butTag){
                self.hidesBottomBarWhenPushed=YES;
                SearchListViewController *_SVC=[[SearchListViewController alloc]init];
                _SVC.urlString=historySearchArray[butTag-100];
                [self.navigationController pushViewController:_SVC animated:YES];
                
            };
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueryCell"];
    cell.selectionStyle = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    if (queryArray.count > 0) {
        SearchModel *model = queryArray[indexPath.row];
        cell.textLabel.text = model.productName;
    }
    
    return cell;
}

#pragma mark 设置段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        if (section==0) {
            if (hotSearchArray.count>0) {
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
                titleLabel.text = @"   热门搜索";
                titleLabel.textColor = [UIColor colorWithHexString:@"0xff6600"];
                titleLabel.font = [UIFont systemFontOfSize:17];
                return titleLabel;
            }else{
                return nil;
            }
            
        }else{
            if (historySearchArray.count>0) {
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
                titleLabel.text = @"   历史记录";
                titleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
                titleLabel.font = [UIFont systemFontOfSize:17];
                return titleLabel;
            }else{
                return nil;
            }
            
        }
    }
    return 0;
}

#pragma mark 设置段尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        
        if (section == 1 && historySearchArray.count>0)
        {
            UIView *_footView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 80.0f)];
            _footView.userInteractionEnabled = YES;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame  = CGRectMake(SCREEN_WIDTH/2-140*(ScreenWidth/320),30 ,280*(ScreenWidth/320) ,50);
            [btn setTitle:@"清除历史记录" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"0x454c53"] forState:UIControlStateNormal];
            //        [btn setBackgroundImage:IMAGE(@"记录边框") forState:UIControlStateNormal];
            [_footView addSubview:btn];
            
            btn.layer.cornerRadius = 25;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"0xd7d7d7"].CGColor;
            
            [btn addTarget:self action:@selector(CrearBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            return _footView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView) {
        
        if (indexPath.section==0) {
            if (hotSearchArray.count>0) {
                return ((hotSearchArray.count-1)/4+1)*45+10;
            }else{
                return 0.1;
            }
        }else{
            if (historySearchArray.count>0) {
                return ((historySearchArray.count-1)/4+1)*45+10;
            }else{
                return 0.1;
            }
        }
    }
    
    if (tableView == queryTableView) {
        return 50;
    }
    
    return 0;
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (tableView == _tableView) {
        if (section == 0) return hotSearchArray.count > 0 ? 50 : 0.1;
        else return historySearchArray.count > 0 ? 50 : 0.1;
    }
    
    return 0;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        return section == 1 && historySearchArray > 0 ? 80 : 0.1;
    }
    
    return 0;
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_searchBar resignFirstResponder];
    
    if (tableView != _tableView) {
        SearchModel *model = queryArray[indexPath.row];
        _titleString = model.productName;
        [self goSearchView];
    }
}

#pragma mark - 事件处理
- (void)goSearchView {
    
    self.hidesBottomBarWhenPushed = YES;
    SearchListViewController *searchVC = [[SearchListViewController alloc]init];
    searchVC.urlString = _titleString;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 点击清除按钮
-(void)CrearBtn:(UIButton *)btn {
    [self DelHistoryRequest];
}

- (void)touchTableView {
    [self.view endEditing:YES];
}

#pragma mark - UISrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
#pragma mark 编辑搜索框的文字
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([Tools isBlankString:searchText]) {
        queryTableView.hidden = YES;
        _tableView.hidden = NO;
    }
    else {
        queryTableView.hidden = NO;
        _tableView.hidden = YES;
        
        [queryArray removeAllObjects];
        [queryTableView reloadData];
    }
    
    _titleString = searchText;
    [self QueryGoodsWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self goSearchView];
}

@end
