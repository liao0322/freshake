//
//  GoodsDetailsView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/11/22.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsDetailsView.h"

@implementation GoodsDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        [self.tableView registerClass:[OtherDetailsCell class] forCellReuseIdentifier:@"OtherDetailsCell"];
//        [self.tableView registerClass:[GoodsDetailCell class] forCellReuseIdentifier:@"GoodsDetailCell"];
        
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                _lookBlock();
                
            } completion:^(BOOL finished) {
                
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
    }
    
    return self;
}

// 获取模型
- (void)setDetailsModel:(GoodsDetailsModel *)detailsModel {
    
    _detailsModel = detailsModel;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_detailsModel != nil) {
        
        if (_detailsModel.attr.count > 0) return 2;
        else return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_detailsModel != nil) {
        
        if (section == 0) return 1;
        else return _detailsModel.attr.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        
//        GoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell"];
//        cell.detailsModel = _detailsModel;
//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//        return cell;
//    }
//    else if (indexPath.section == 1) {
//        
//        OtherDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherDetailsCell"];
//        cell.nameLabel.text = _detailsModel.attr[indexPath.row][@"paName"];
//        cell.valueLabel.text = _detailsModel.attr[indexPath.row][@"paValue"];
//        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//        return cell;
//    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
// Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:tableView];
}

@end
