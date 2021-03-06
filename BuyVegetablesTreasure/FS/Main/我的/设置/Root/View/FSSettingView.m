//
//  FSSettingView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSSettingView.h"
#import "FSHelptextViewController.h"

#define SectionHeight 55

@interface FSSettingView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation FSSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = @[@"帮助中心",@"消息通知",@"关于我们",@"特别说明"];
        [self initSettingView];
    }
    return self;
}

- (void)initSettingView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
//    _tableView.rowHeight = SectionHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
}

#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}

#pragma mark 退出
- (void)outClick {
    [Tools myAlert:@"确定退出?" target:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SectionHeight;
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
       
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SectionHeight, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
            [cell addSubview:line];
      
    }
    cell.textLabel.text = _dataSource[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x404040"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *viewControllers = @[@"FSHelpViewController",@"FSOpenPushViewController",@"FSAboutMeViewController"];
    
    if (indexPath.section > 2) {
        
        FSHelptextViewController *helpTextVC = [[FSHelptextViewController alloc] init];
        helpTextVC.titleText = @"特别说明";
        helpTextVC.context = @"       鲜摇派在此声明,您通过本软件参加的商业活动以及优惠券活动与苹果公司无关!";
        _goViewController(helpTextVC);
    }
    else {
        _goViewController([NSClassFromString(viewControllers[indexPath.section]) new]);
    }

}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark 创建段尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (![Tools isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]]) {
        if (section == _dataSource.count - 1) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight + 25)];
            bgView.userInteractionEnabled = YES;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(20, 25, SCREEN_WIDTH - 40, SectionHeight);
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            btn.backgroundColor = [UIColor colorWithHexString:@"0x86bb35"];
            btn.layer.cornerRadius = 5;
            [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            
            return bgView;
        }
    }
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *mobile = [userDefaults objectForKey:@"mobile"];
        NSString *firstStart = [userDefaults objectForKey:@"firstStart"];               // 首次运行程序
        NSString *merchantsID = [userDefaults objectForKey:@"merchantsID"];             // 商家ID
        NSString *merchantsName = [userDefaults objectForKey:@"merchantsName"];         // 提货点名字
        NSString *merchantsAddress = [userDefaults objectForKey:@"merchantsAddress"];   // 提货点地址
        NSString *merchantsTime = [userDefaults objectForKey:@"merchantsTime"];         // 提货点时间
        NSString *MID = [userDefaults objectForKey:@"MID"];     // 提货点ID
        NSString *distance = [userDefaults objectForKey:@"distance"];           // 距离
        float latitude = [userDefaults doubleForKey:@"positioningLatitude"];    // 经度
        float longitude = [userDefaults doubleForKey:@"positioningLongitude"];  // 纬度
        
        NSString *DistanceString = [userDefaults objectForKey:@"Distance"];
        NSString *DistancePriceString = [userDefaults objectForKey:@"DistancePrice"];
        
        BOOL IsDistribution = [userDefaults boolForKey:@"IsDistribution"];
        NSString *fullPrice = [userDefaults objectForKey:@"fullPrice"];
        
        NSString *xPoint = [userDefaults objectForKey:@"xPoint"];
        
        NSString *yPoint = [userDefaults objectForKey:@"yPoint"];
        NSString *fendianname = [userDefaults objectForKey:@"Fendianname"];
        
        
        // 清除沙盒
        [Utillity deleteCache];
        
        // 重新赋值
        [userDefaults setObject:firstStart forKey:@"firstStart"];
        [userDefaults setObject:merchantsID forKey:@"merchantsID"];
        [userDefaults setObject:merchantsName forKey:@"merchantsName"];
        [userDefaults setObject:merchantsAddress forKey:@"merchantsAddress"];
        [userDefaults setObject:merchantsTime forKey:@"merchantsTime"];
        [userDefaults setObject:MID forKey:@"MID"];
        [userDefaults setObject:distance forKey:@"distance"];
        [userDefaults setDouble:latitude forKey:@"positioningLatitude"];
        [userDefaults setDouble:longitude forKey:@"positioningLongitude"];
        [userDefaults setObject:mobile forKey:@"mobile"];
        [userDefaults setObject:DistanceString forKey:@"Distance"];
        [userDefaults setObject:DistancePriceString forKey:@"DistancePrice"];
        [userDefaults setBool:IsDistribution forKey:@"IsDistribution"];
        [userDefaults setObject:fullPrice forKey:@"fullPrice"];
        [userDefaults setObject:xPoint forKey:@"xPoint"];
        [userDefaults setObject:yPoint forKey:@"yPoint"];
        [userDefaults setObject:fendianname forKey:@"Fendianname"];
        
        
        _LogOut();
    }
}


@end
