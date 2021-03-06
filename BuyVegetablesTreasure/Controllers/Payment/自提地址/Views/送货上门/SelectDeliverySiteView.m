//
//  SelectDeliverySiteView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/3/30.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "SelectDeliverySiteView.h"
#import "deliverySiteViewController.h"

@interface SelectDeliverySiteView ()

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation SelectDeliverySiteView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initAddSiteBtn];
        [self initStoreDeliveryTableView];
    }
    return self;
}

#pragma mark - 初始化
#pragma mark 新增地址按钮
- (void)initAddSiteBtn {

    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(0, ScreenHeight - 45, ScreenWidth, 45);
    self.addBtn.backgroundColor = [UIColor colorDomina];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.addBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addBtn addTarget:self
                    action:@selector(btnClick)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
}

#pragma mark 显示商家提货点
- (void)initStoreDeliveryTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FSSelectDeliverySiteCell class] forCellReuseIdentifier:@"FSSelectDeliverySiteCell"];
    [self addSubview:self.tableView];
}

#pragma mark - 事件处理
#pragma mark 刷新TableView
- (void)refreshSite {
    [self.tableView reloadData];
}

#pragma mark 添加地址
- (void)btnClick {
    _addBtnClick(NO, 0);
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _siteArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSSelectDeliverySiteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSSelectDeliverySiteCell"];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.defaultBtnClick = ^() {
        SiteModel *model = _siteArray[indexPath.section];
       
        NSLog(@"^^^^^^^^^^^^^%@",model);
        _defaultAddress(YES, model);
    };
    cell.deleteBtnClick = ^() {
        SiteModel *model = _siteArray[indexPath.section];
        _deleteAddress(model.id);
    };
    cell.editBtnClick = ^(){
        _addBtnClick(YES, indexPath.section);
    };
    [cell setModel:_siteArray[indexPath.section]];
    
    return cell;
}

#pragma mark 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_siteArray.count > 0) {
        [Single sharedInstance].isDelivery = YES;
        _userAddress(_siteArray[indexPath.section]);
    }
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.01;
    }
    
    return 10;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView cellHeightForIndexPath:indexPath
//                                       model:self.siteArray[indexPath.section]
//                                     keyPath:@"model"
//                                   cellClass:[FSSelectDeliverySiteCell class]
//                            contentViewWidth:ScreenWidth];
    return 135;
}

@end
