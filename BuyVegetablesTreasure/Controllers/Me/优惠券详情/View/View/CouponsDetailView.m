//
//  CouponsDetailView.m
//  VegetablesApp
//
//  Created by M on 16/6/1.
//  Copyright © 2016年 M. All rights reserved.
//

#import "CouponsDetailView.h"

@implementation CouponsDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initTableView];
        [self setTableHeadImg];
    }
    return self;
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xfcce30"];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[CouponsDetailCell class] forCellReuseIdentifier:@"CouponsDetailCell"];
}

- (void)setTableHeadImg {
    
    UIImage *headImg = [IMAGE(@"CouponsHead") imageCompressForTargetWidth:ScreenWidth];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:headImg];
    imgView.frame = CGRectMake(0, 0, ScreenWidth, headImg.size.height);
    _tableView.tableHeaderView = imgView;
}

- (void)setMyCouponArray:(NSMutableArray *)myCouponArray {
    
    _myCouponArray = myCouponArray;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsDetailCell"];
    cell.couponsModel = _couponsModel;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
