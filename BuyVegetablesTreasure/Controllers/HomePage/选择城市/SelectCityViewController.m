//
//  SelectCityViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/12/14.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "SelectCityViewController.h"
#import "BDMapViewController.h"

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"选择城市"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    
    NSLog(@"%@",_currentCityString);
    
    [self initTableView];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 50;
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#define mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [Tools isBlankString:[userDefaults objectForKey:@"CurrentSite"]] ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = [userDefaults objectForKey:@"CurrentSite"];
        cell.imageView.image = [UIImage imageNamed:@"地址图标"];
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"上海";
        }
        else cell.textLabel.text = @"深圳";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = NO;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 39)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenHeight, 39)];
    
    label.font = [UIFont systemFontOfSize:18];
    label.text = section == 0 ? @"当前地址" : @"选择其他城市";
    
    [headView addSubview:label];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        BDMapViewController *bdMap = [[BDMapViewController alloc] init];
        bdMap.isCurrentSite = YES;
        [self.navigationController pushViewController:bdMap animated:YES];
    }
    
    else if (indexPath.section == 1) {
        
        NSString *currentCity = @"";
        
        if (indexPath.row == 0) {
            currentCity = @"上海";
        }
        else currentCity = @"深圳";
        
        BDMapViewController *bdMapVC = [BDMapViewController new];
        bdMapVC.currentCity = currentCity;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bdMapVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

@end
