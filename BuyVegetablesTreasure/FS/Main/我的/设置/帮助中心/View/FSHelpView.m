//
//  FSHelpView.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2016/12/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "FSHelpView.h"
#import "FSHelpModel.h"
#import "FSHelptextViewController.h"

#define SectionHeight 55

@interface FSHelpView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FSHelpView

- (instancetype)initWithFrame:(CGRect)frame {
    
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
    FSHelpModel *model = _dataSource[section];
    return model.HelpList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SectionHeight - 1, ScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xd9d9d9"];
        [cell addSubview:line];
    }
    FSHelpModel *model = _dataSource[indexPath.section];
    
    cell.textLabel.text = model.HelpList[indexPath.row][@"helpName"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSHelpModel *model = _dataSource[indexPath.section];
    FSHelptextViewController *fsHelpTextVC = [[FSHelptextViewController alloc] init];
    fsHelpTextVC.context = model.HelpList[indexPath.row][@"context"];
    _goViewController(fsHelpTextVC);
    
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeight;
}

#pragma mark 创建段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSHelpModel *model = _dataSource[section];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, SectionHeight)];
    titleLabel.text = model.helpTypeName;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [bgView addSubview:titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SectionHeight - 1, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE1E1E1"];
    [bgView addSubview:line];
    
    return bgView;
}


@end
