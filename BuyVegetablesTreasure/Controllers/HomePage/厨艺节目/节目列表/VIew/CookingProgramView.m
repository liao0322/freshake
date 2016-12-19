//
//  CookingProgramView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CookingProgramView.h"
#import "CookingDetailsViewController.h"
#import "IntroduceCell.h"

@interface CookingProgramView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *cookingProgramTableView;

@end

@implementation CookingProgramView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommodityTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initCommodityTableView {
    
    _cookingProgramTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _cookingProgramTableView.delegate = self;
    _cookingProgramTableView.dataSource = self;
    _cookingProgramTableView.separatorStyle = NO;
    [self addSubview:_cookingProgramTableView];
    
    [_cookingProgramTableView registerClass:[IntroduceCell class] forCellReuseIdentifier:@"IntroduceCell"];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_cookingProgramTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduceCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.isCollect = ^(NSString *idString, NSString *nameString,BOOL collect) {
        _isCollect(idString,nameString,collect);
    };
    
    [cell setModel:_dataSource[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CookingProgramListModel *model = _dataSource[indexPath.section];
    
    CookingDetailsViewController *detailsVC = [CookingDetailsViewController new];
    detailsVC.idString = model.Id;
    detailsVC.nameString = model.Title;
    detailsVC.isVedio = [model.isVedio boolValue];
    detailsVC.videoURL = model.Vediourl;
    _goViewController(detailsVC);
}

#pragma mark 返回Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:_cookingProgramTableView];
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
