//
//  EditSiteViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "EditSiteViewController.h"
#import "UserSiteInfoCell.h"
#import "UserInfoView.h"
#import "UserSiteCell.h"
#import "BDMapViewController.h"
#import "SelectCityPickerView.h"
#import "CityModel.h"
#import "List.h"
#import "Map.h"

@interface EditSiteViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSArray *_userLabelTitleArray;
    NSArray *_userTextFeildTilteArray;
    NSArray *_reminderArray;
    
    NSArray *_mapArray;
    NSMutableArray *_cityArray;
    
    NSString *_addressString;
    NSString *_cityString;
    NSString *_provinceString;
    
    NSInteger cityId;
    NSInteger provnceID;
    NSInteger cityID;
    
    SelectCityPickerView *_selectCityView;
    BDMapViewController *_bdMapVc;
}
@end

@implementation EditSiteViewController

@synthesize isShowContent;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *titleString;
    titleString = _isEidt ? @"删除地址" : @"添加地址";
    
    self.navigationItem.titleView = [Utillity customNavToTitle:titleString];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];

    _mapArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    _userLabelTitleArray = @[@"联系人",@"手机号码",@"所在城市",@"地  址"];
    _userTextFeildTilteArray = @[@"李明明",@"18578578569",@"深圳市南山区",@"科苑路北科大厦B3栋1002"];
    _reminderArray = @[@"收货人姓名",@"联系你的电话",@"选择您所在的城市",@"选择您所在的地址"];

    self.tableView.separatorStyle = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserSiteInfoCell" bundle:nil] forCellReuseIdentifier:@"UserSiteInfoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserSiteCell" bundle:nil] forCellReuseIdentifier:@"UserSiteCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self request];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求
- (void)request {
    
    [HttpRequest sendGetOrPostRequest:GETCITY param:nil requestStyle:Get setSerializer:Date isShowLoading:NO success:^(id data)
     {
         
         for (NSDictionary *dic in data) {
             
             CityModel *cityModel = [[CityModel alloc] init];
             [cityModel setValuesForKeysWithDictionary:dic];
             
             for (NSDictionary *dict in dic[@"List"]) {
                 
                 List *listModel = [[List alloc] init];
                 [listModel setValuesForKeysWithDictionary:dict];
                 [cityModel.cityArray addObject:listModel];
             }
             
             [_cityArray addObject:cityModel];
         }
         
     } failure:nil];
}

- (void)saveAddress{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UserSiteInfoCell *cell_1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UserSiteInfoCell *cell_2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    UserSiteInfoCell *cell_3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    UserSiteInfoCell *cell_4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    
    if ([Tools isBlankString:cell_1.userInfoTextField.text] && [Tools isBlankString:cell_2.userInfoTextField.text] && [Tools isBlankString:cell_3.userInfoTextField.text] && [Tools isBlankString:cell_4.userInfoTextField.text]) {
        
        [Tools myHud:@"资料未填写完成" inView:self.view];
        return;
    }
    
    // ID
    NSString *Id = @"0";
    
    // 用户ID
    NSString *userid = [defaults objectForKey:@"UID"];
    
    // 商家ID
    NSString *storeid;
    
    // 联系人
    NSString *contacts;
    
    // 联系人电话
    NSString *telephone;
    
    // 地址
    NSString *address;
    
    // 省ID
    NSString *provnce;
    
    // 市ID
    NSString *city;
    
    // 区ID
    NSString *area = @"";
    
    for (int i = 0; i < 4; i++) {
        
        UserSiteInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        switch (i) {
            case 0:
                contacts = cell.userInfoTextField.text;
                break;
            case 1:
                telephone = cell.userInfoTextField.text;
                break;
            case 2:
                provnce = [NSString stringWithFormat:@"%zd",provnceID];
                city = [NSString stringWithFormat:@"%zd",cityID];
                break;
            case 3:
                address = cell.userInfoTextField.text;
                break;
                
            default:
                break;
        }
    }
    
    for (int i = 0; i < _mapArray.count; i++) {
        
        UserSiteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
        
        if (cell.selectBtn.selected == YES) {
            
            Map *mapInfo = _mapArray[i];
            storeid = mapInfo.id;
        }
    }
    
    
    NSString *urlString = [NSString stringWithFormat:SAVEADDRESS,Id,userid,storeid,contacts,telephone,address,provnce,city,area];
    
    NSString *jsonString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [HttpRequest sendGetOrPostRequest:jsonString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
        [self.navigationController popToRootViewControllerAnimated:YES];
         
     } failure:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _userLabelTitleArray.count;
    }
    else if (section == 1){
        return _mapArray.count;
    }
    
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        UserSiteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSiteInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            [cell.userInfoTextField setEnabled:NO];
            
            if (indexPath.row == 2) {
                cell.userInfoTextField.text = _cityString;
            }
            else {
                cell.userInfoTextField.text = _addressString;
            }
        }
        
        [cell setLabelTitle:_userLabelTitleArray[indexPath.row]];
        [cell setTextFeildPlaceholder:_reminderArray[indexPath.row]];
        
        return cell;
    }
    else if (indexPath.section == 1){
        
        UserSiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserSiteCell"];
        
        if (indexPath.row == 0) {
            
            UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xDAD9D9"];
            
            [cell addSubview:line];
        }
        
        cell.selectionStyle = NO;
        
        Map *mapInfo = _mapArray[indexPath.row];
        
        cell.nameLabel.text = mapInfo.Fendianname;
        cell.addressLabel.text = mapInfo.addr;
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

        UIButton *btn       = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame           = CGRectMake(0, 0, ScreenWidth, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"确认订单框"]
                       forState:UIControlStateNormal];
        
        [btn setTitle:_isEidt ? @"删除地址" : @"保存收货地址" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:btn];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 3) {
    
//        if ([Tools isBlankString:_cityString]) {
//            [Tools myHud:@"请选择地址" inView:self.view];
//            return;
//        }

        _bdMapVc = [[BDMapViewController alloc] init];
        _bdMapVc.cityString = _cityString;
        
        __weak typeof(self)WeakSelf = self;
        _bdMapVc.storeBlcok = ^(NSArray *mapArray,NSString *address) {
            _mapArray = mapArray;
            _addressString = address;
            [WeakSelf.tableView reloadData];
        };
        
        [self.navigationController pushViewController:_bdMapVc animated:YES];
        
        if (_selectCityView != nil) {
            
            [self removeSelectCityView];
        }
    }
    
    else if (indexPath.section == 0 && indexPath.row == 2) {
        
        if (_cityArray.count > 0) {
            if (_selectCityView == nil) {
                
                _selectCityView = [[SelectCityPickerView alloc] init];
                
                _selectCityView.frame = CGRectMake(0, SCREEN_HEIGHT  - 240, SCREEN_WIDTH, 240);
                
                _selectCityView.provincePickerView.delegate = self;
                _selectCityView.provincePickerView.dataSource = self;
                
                __weak __typeof(self)WeakSelf = self;
                _selectCityView.btnClickBlock = ^(NSString *block) {
                    
                    [WeakSelf removeSelectCityView];
                };
                
                self.tableView.bounces = NO;
                [self.view addSubview:_selectCityView];
            }
        }
    }
    
    if (indexPath.section == 1) {
        
        for (int i = 0; i < _mapArray.count; i++) {
            
            UserSiteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
            
            if (i == indexPath.row) {
                cell.selectBtn.selected = YES;
            }
            else {
                cell.selectBtn.selected = NO;
            }
        }
    }
}

-(void)removeSelectCityView {
    
    if (_selectCityView != nil) {
        [_selectCityView removeFromSuperview];
        _selectCityView = nil;
    }
    
    self.tableView.bounces = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }
    else if (indexPath.section == 1){
        return 70;
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return 0;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return _cityArray.count - 1;
    }
    else {
        
        CityModel *model = _cityArray[cityId];
        return model.cityArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        CityModel *model = _cityArray[row];
        return model.name;
    }
    
    CityModel *model = _cityArray[cityId];
    
    List *list = model.cityArray[row];
    
    return list.name;
}

// 选择了某行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView == _selectCityView.provincePickerView && component == 0) {
        
        NSLog(@"%zd",row);
        
        cityId = row;
        CityModel *model = _cityArray[cityId];
        List *list = model.cityArray[0];
        
        provnceID = [model.id integerValue];
        _provinceString = model.name;
        _cityString = [NSString stringWithFormat:@"%@ %@",_provinceString,list.name];

        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
    }
    else {
        
        CityModel *model = _cityArray[cityId];
        List *list = model.cityArray[row];
        
        cityID = [list.id integerValue];
        _cityString = [NSString stringWithFormat:@"%@ %@",_provinceString,list.name];
    }
    
    [self.tableView reloadData];
}

@end