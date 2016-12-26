//
//  deliverySiteViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "deliverySiteViewController.h"
#import "SelectSexView.h"
#import "CityPickerView.h"
#import "BDMapViewController.h"
#import "SiteViewController.h"

#define CellHeight 50

@interface deliverySiteViewController ()<AMapSearchDelegate>

@property (nonatomic, strong) NSArray *userInfoTitleArray;
@property (nonatomic, strong) NSArray *infoPlaceholderArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *cityIdArray;
@property (nonatomic, strong) UITableView *userInfoTableView;
@property (nonatomic, strong) CityPickerView *selectCityView;
@property (nonatomic, strong) SelectSexView *selectSexView;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoor;
@property (nonatomic, strong) Map *mapModel;
@property (nonatomic, strong) UISwitch *defaultSwitch;

@end

@implementation deliverySiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
    [self setNav];
    [self initArray];
    [self initUserInfoTabelView];
    [self initSelectCityView];
    [self getCity];

    if (_isDeleteSite) [self initDeleteBtn];
    
//    if (_isDefault) [self saveUserInfo];
}

#pragma mark - 初始化
#pragma mark 初始化数组
- (void)initArray {
    
    _cityIdArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    _userInfoTitleArray = @[@"联 系 人:",@"性     别:",@"手机号码:",@"所在城市:",@"收货地址:",@"详细地址:"];
    _infoPlaceholderArray = @[@"请输入收货人姓名",@"",@"请输入联系号码",@"点击选择城市",@"点击选择所在地区",@"请输入详细地址"];
}

- (UISwitch *)defaultSwitch {
    
    if (!_defaultSwitch) {
        _defaultSwitch = [UISwitch new];
    }
    
    return _defaultSwitch;
}

#pragma mark 导航
- (void)setNav {
    self.navigationItem.titleView = [Utillity customNavToTitle:_isDeleteSite ? @"编辑地址" : @"添加地址"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserInfo)];
//    self.navigationItem.rightBarButtonItem.tintColor = Color;
}

#pragma mark 显示用户信息
- (void)initUserInfoTabelView {

    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 430) style:UITableViewStyleGrouped];
    _userInfoTableView.rowHeight = CellHeight;
    _userInfoTableView.dataSource = self;
    _userInfoTableView.delegate = self;
    _userInfoTableView.scrollEnabled = NO;
    _userInfoTableView.tableFooterView = [[UIView alloc] init];
//    _userInfoTableView.backgroundColor = [UIColor colorWithHexString:@"0xEAEBEC"];
    _userInfoTableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    [_userInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserInfoCell"];
    [self.view addSubview:_userInfoTableView];
    
    // 保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(40, CGRectGetMaxY(_userInfoTableView.frame) + 20, ScreenWidth - 80, 45);
    saveBtn.backgroundColor = [UIColor colorDomina];
    saveBtn.layer.cornerRadius = 5;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

#pragma mark 选择城市
- (void)initSelectCityView {

    if (_selectCityView == nil) {
        
        _selectCityView = [[CityPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight / 3)];
        [self.view bringSubviewToFront:_selectCityView];
        [self.view addSubview:_selectCityView];
    }
    else {
        
        CGRect frame = _selectCityView.frame;
        frame.origin.y = ScreenHeight - ScreenHeight / 3;
        
        [UIView animateWithDuration:0.5 animations:^{
            _selectCityView.frame = frame;
        }];
    }
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(_selectCityView)weakSelectCityView = _selectCityView;
    _selectCityView.buttonClickBlock = ^(NSString *cityString) {
        
        for (int i = 0; i < weakSelf.cityArray.count; i++) {
            
            if ([cityString isEqualToString:weakSelf.cityArray[i]]) {
                [Single sharedInstance].cityId = weakSelf.cityIdArray[i];
            }
        }
        
        CGRect frame = weakSelectCityView.frame;
        frame.origin.y = ScreenHeight;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelectCityView.frame = frame;
        }];
        
        if (![Tools isBlankString:cityString]) {
            [(UITextField *)[weakSelf.view viewWithTag:53] setText:cityString];
        }
    };
}

#pragma mark 删除按钮
- (void)initDeleteBtn {

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, ScreenWidth, CellHeight);
    deleteBtn.backgroundColor = [UIColor colorWithHexString:@"0xff6600"];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setTitle:@"删除当前地址" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _userInfoTableView.tableFooterView = deleteBtn;
}

#pragma mark 事件处理
#pragma mark 返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 删除用户信息
- (void)deleteUserInfo {
    [Tools myAlert:@"确定删除该地址？" target:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self deleteRequstWithId:_siteModel.id];
    }
}

#pragma mark - 数据请求
#pragma mark 保存用户信息
- (void)saveUserInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *userName = [(UITextField *)[self.view viewWithTag:50] text];
    NSString *idString = _isDeleteSite ? _siteModel.id : @"0";
    NSString *phoneString = [(UITextField *)[self.view viewWithTag:52] text];
    NSString *cityStirng = [(UITextField *)[self.view viewWithTag:53] text];
    NSString *areaString = [(UITextField *)[self.view viewWithTag:54] text];
    NSString *addressString = [(UITextField *)[self.view viewWithTag:55] text];
    NSString *sexString = [NSString stringWithFormat:@"%zd",_selectSexView.sex];
    
    if ([Tools isBlankString:userName]) {
        return [Tools myHud:@"请输入收货人名字" inView:self.view];
    }
    if ([Tools isBlankString:phoneString]) {
        return [Tools myHud:@"请填写手机号码" inView:self.view];
    }
    else if (![Tools isMobileNum:phoneString]) {
        return [Tools myHud:@"请输入正确号码" inView:self.view];
    }
    else if ([Tools isBlankString:cityStirng]) {
        return [Tools myHud:@"请选择所在城市" inView:self.view];
    }
    else if ([Tools isBlankString:areaString]) {
        return [Tools myHud:@"请选择地址" inView:self.view];
    }

    if ([_siteModel.Area isEqualToString:areaString]) {
        
        _currentCoor.latitude = [_siteModel.X doubleValue];
        _currentCoor.longitude = [_siteModel.Y doubleValue];
    }
    else {
        
        _currentCoor.latitude = [_mapModel.xPoint doubleValue];
        _currentCoor.longitude = [_mapModel.yPoint doubleValue];
    }
    
    NSString *urlString = [NSString stringWithFormat:EditAddress,uidString,userName,sexString,idString,cityStirng,areaString,addressString,phoneString,_currentCoor.latitude, _currentCoor.longitude, [Single sharedInstance].cityId, self.defaultSwitch.on];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
     {
         if ([data[@"issuccess"] boolValue]) {
             
             [self.navigationController popViewControllerAnimated:YES];
             [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         }
         else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
         
     } failure:nil];
}

#pragma mark 删除地址
- (void)deleteRequstWithId:(NSString *)idString {
    
    NSString *urlString = [NSString stringWithFormat:DeleteAdress,idString];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        if ([data[@"issuccess"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
        }
        else [Tools myHud:data[@"context"] inView:[[UIApplication sharedApplication].delegate window]];
        
    } failure:nil];
}

#pragma mark 获取城市
- (void)getCity {
    
    NSLog(@"%@",GetCity);
    [HttpRequest sendGetOrPostRequest:GetCity param:nil requestStyle:Get setSerializer:Json isShowLoading:YES success:^(id data)
    {
        [_cityArray removeAllObjects];
        
        for (NSDictionary *dic in data) {
            
            [_cityArray addObject:dic[@"name"]];
            [_cityIdArray addObject:dic[@"id"]];
        }
        
        if (_cityIdArray.count > 0) {
            [Single sharedInstance].cityId = _cityIdArray[0];
        }
        
        for (int i = 0; i < _cityArray.count; i++) {
            
            if ([_siteModel.City isEqualToString:_cityArray[i]]) {
                [Single sharedInstance].cityId = _cityIdArray[i];
            }
        }
        
        _selectCityView.cityIdArray = _cityIdArray;
        _selectCityView.cityArray = _cityArray;
        [_selectCityView refreshCity];
//        [_userInfoTableView reloadData];
        
    } failure:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
    
        return _userInfoTitleArray.count;
    }
    
    return 1;
}

#pragma mark 创建Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
        cell.textLabel.text = _userInfoTitleArray[indexPath.row];
        
        if (indexPath.row == 1) {
            
            _selectSexView = [[SelectSexView alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 110, CellHeight)];
            [cell addSubview:_selectSexView];
            
            if (indexPath.row == 1 && ![Tools isBlankString:_siteModel.id]) {
                [_selectSexView setSexBtn:[_siteModel.sex boolValue]];
            }
        }
        else {
            
            UITextField *textField;
            
            if (IS_IPAD) {
                textField= [[UITextField alloc] initWithFrame:CGRectMake(180, 0, ScreenWidth - 60, CellHeight)];
            }else {
                textField= [[UITextField alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 60, CellHeight)];
            }
            
            textField.tag = indexPath.row + 50;
            textField.font = [UIFont systemFontOfSize:14];
            textField.placeholder = _infoPlaceholderArray[indexPath.row];
            [textField setEnabled:(indexPath.row == 3 || indexPath.row == 4) ? NO : YES];
            [cell addSubview:textField];
            
            if (![Tools isBlankString:_siteModel.id]) {
                
                if (indexPath.row == 0) {
                    textField.text = _siteModel.userName;
                }
                else if (indexPath.row == 2) {
                    textField.text = _siteModel.Phone;
                }
                else if (indexPath.row == 3) {
                    
                    textField.text = _siteModel.City;
                }
                else if (indexPath.row == 4) {
                    textField.text = _siteModel.Area;
                }
                else if (indexPath.row == 5) {
                    textField.text = _siteModel.Address;
                }
            }
        }
        
        return cell;;
    }
     else {
     
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x737373"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
        cell.textLabel.text = @"设为默认地址";
        cell.accessoryView = self.defaultSwitch;
        
        if (![Tools isBlankString:self.siteModel.id]) {
        
            self.defaultSwitch.on = [self.siteModel.isdefault boolValue];
        }
        
        return cell;
     }
   
}

#pragma mark - UITableViewDelegate
#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        [self.view endEditing:YES];
        [self initSelectCityView];
    }
    else if (indexPath.row == 4) {
        
        self.hidesBottomBarWhenPushed = YES;
  
        SiteViewController *siteVC = [[SiteViewController alloc]init];
        siteVC.midStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsID"];
        siteVC.isCollect = NO;
        siteVC.isDelivery = YES;
        siteVC.isDistribution = NO;
        [self.navigationController pushViewController:siteVC animated:YES];
        
        siteVC.midSite = ^(Map *mapModel) {
            
            _mapModel = mapModel;
            [(UITextView *)[self.view viewWithTag:54] setText:mapModel.Fendianname];
        };
    }
}

// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


@end
