//
//  HelpView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/10.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "HelpView.h"
#import "HelpModel.h"
#import "HelptextViewController.h"

#define SectionHeight 50

@interface HelpView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HelpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHelpView];
    }
    return self;
}

- (void)initHelpView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame];
    _tableView.rowHeight = SectionHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    [self addSubview:_tableView];
}

#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HelpModel *model = _dataSource[section];
    return model.HelpList.count;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SectionHeight - 1, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xE1E1E1"];
        [cell addSubview:line];
    }
    
    HelpModel *model = _dataSource[indexPath.section];
    
    cell.textLabel.text = model.HelpList[indexPath.row][@"helpName"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HelpModel *model = _dataSource[indexPath.section];
    HelptextViewController *helpTextVC = [[HelptextViewController alloc]init];
    helpTextVC.context = model.HelpList[indexPath.row][@"context"];
    _goViewController(helpTextVC);
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}

#pragma mark 创建段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HelpModel *model = _dataSource[section];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, SectionHeight)];
    titleLabel.text = model.helpTypeName;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [bgView addSubview:titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SectionHeight - 1, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE1E1E1"];
    [bgView addSubview:line];
    
    return bgView;
}

@end
