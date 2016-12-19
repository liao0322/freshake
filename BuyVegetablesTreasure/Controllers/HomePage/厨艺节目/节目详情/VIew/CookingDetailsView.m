//
//  CookingDetailsView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/29.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CookingDetailsView.h"
#import "CookingDetailsCell.h"

@interface CookingDetailsView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *cookingDetailsTableView;

@end

@implementation CookingDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommodityTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initCommodityTableView {
    
    _cookingDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) style:UITableViewStyleGrouped];
    _cookingDetailsTableView.delegate = self;
    _cookingDetailsTableView.dataSource = self;
    _cookingDetailsTableView.separatorStyle = NO;
    _cookingDetailsTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cookingDetailsTableView];
    
    [_cookingDetailsTableView registerClass:[CookingDetailsCell class] forCellReuseIdentifier:@"CookingDetailsCell"];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_cookingDetailsTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CookingDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookingDetailsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setModel:_dataSource[indexPath.section]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark 返回Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:_cookingDetailsTableView];
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
