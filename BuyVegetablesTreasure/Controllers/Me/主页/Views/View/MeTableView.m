//
//  MeTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/7.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "MeTableView.h"
#import "PointRecordViewController.h"
#import "AmountViewController.h"
#import "MyCouponsViewController.h"
#import "PersonalDataViewController.h"
#import "MeUITTableViewCell.h"

#define ListCellHeight 50

@interface MeTableView ()

@property (nonatomic, copy) NSArray *nameArray;
@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation MeTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageArray = @[@"我的订单",@"优惠券",@"我的收藏",@"我的拼团",@"地址管理"];
        _nameArray = @[@"我的订单",@"我的优惠券",@"我的收藏",@"我的拼团",@"地址管理"];
        
        [self initMeTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initMeTableView {
    
    _meTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _meTableView.delegate = self;
    _meTableView.dataSource = self;
    _meTableView.separatorStyle = NO;
//    _meTableView.rowHeight = 100;
    _meTableView.tableFooterView = [[UIView alloc] init];
    
    [_meTableView registerClass:[MeUITTableViewCell class] forCellReuseIdentifier:@"MeViewCell"];
    
    [self addSubview:_meTableView];
}

#pragma mark 事件处理
- (void)refreshTableView {
    
    [_meTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) return _nameArray.count;
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MeUITTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeViewCell"];
        cell.selectionStyle = NO;
        
        [cell setDataSource];
        
        //赋值
        if (_dataScoure.count > 0) {
            [cell.numView setData:_dataScoure[0]];
        }
        
        cell.pushLogin = ^(NSArray *arr) {
            
            PersonalDataViewController *personalDataVC = [[PersonalDataViewController alloc] init];
            personalDataVC.point = _pointString;
            
            personalDataVC.changeImage=^(){
                [_meTableView reloadData];
            };
            _goViewController(personalDataVC);
        };
        
        cell.numView.btnBlock = ^(NSInteger tag){
            
            if (tag == 50) {
                
                PointRecordViewController *pointRecordVC = [[PointRecordViewController alloc] init];
                pointRecordVC.point = _pointString;
                _goViewController(pointRecordVC);
            }
            else if (tag == 51) {
                
                AmountViewController *amountVC = [[AmountViewController alloc] init];
                _goViewController(amountVC);
            }
            else {
                
                _goViewController([MyCouponsViewController new]);
            }
        };
        
        cell.goViewController = ^(UIViewController *viewController) {
            _goViewController(viewController);
        };
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xD7D7D7"];
            [cell addSubview:line];
        }
        
        cell.textLabel.text = _nameArray[indexPath.row];
        cell.imageView.image = IMAGE(_imageArray[indexPath.row]);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 260;
    }
    else return ListCellHeight;

}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    }
    return 0.01;
}

#pragma 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {

        NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
        
        if ([Tools isBlankString:uidString]) {
            return _goViewController([NSClassFromString(@"ShopLoginViewController") new]);
        }
        
        NSArray *viewControllerArray = @[@"MyOrderViewController",
                                         @"MyCouponsViewController",
                                         @"MyCollectViewController",
                                         @"MyGroupViewController",
                                         @"MySiteViewController"];
        
        _goViewController([NSClassFromString(viewControllerArray[indexPath.row]) new]);
    }
}

@end
