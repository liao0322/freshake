//
//  GoodsDetailsView.m
//  VegetablesApp
//
//  Created by M on 16/5/31.
//  Copyright © 2016年 M. All rights reserved.
//

#import "GoodsDetailsView.h"
#import "OtherDetailsCell.h"

#define FrameWidth self.frame.size.width
#define FrameHeight self.frame.size.height

@implementation GoodsDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FrameWidth, FrameHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{

            _lookBlock();
            
        } completion:^(BOOL finished) {
            [_tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)setDetailsModel:(Pruduct *)detailsModel {

    _detailsModel = detailsModel;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_detailsModel != nil) {
        
        if (_detailsModel.attr.count > 0) {
            return 2;
        }
        else {
            return 1;
        }
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_detailsModel != nil) {
        
        if (section == 0) {
            return 1;
        }
        else {
            return _detailsModel.attr.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell"];
        
        if (cell == nil) {
            
            cell = [[GoodsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsDetailCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailsModel = _detailsModel;
        }
        
        return cell;
    }
    else if (indexPath.section == 1) {
        
        OtherDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherDetailsCell"];
        
        if (cell == nil) {
            
            cell = [[OtherDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherDetailsCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = _detailsModel.attr[indexPath.row][@"paName"];
            cell.valueLabel.text = _detailsModel.attr[indexPath.row][@"paValue"];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:tableView];
}

@end
