//
//  DetailsTableView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "DetailsTableView.h"
#import "GroupStatusCell.h"
#import "GroupGoodsCell.h"
#import "UserStatusCell.h"
#import "RemainingTimeCell.h"
#import "MemberInfoCell.h"
#import "PlayGroupView.h"
#import "GroupDetailListModel.h"
//#import "GroupDetailsImageViewController.h"
#import "FSGroupBuyHelperViewController.h"

@interface DetailsTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *delailsTableView;
@property (nonatomic, copy) NSArray *cellArray;

@property (nonatomic, assign) GroupDetailModel *groupDetailModel;

@end

@implementation DetailsTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initGroupTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initGroupTableView {
    
    _delailsTableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
    _delailsTableView.delegate = self;
    _delailsTableView.dataSource = self;
    _delailsTableView.separatorStyle = NO;
    [self addSubview:_delailsTableView];
    
    _cellArray = @[@"GroupStatusCell",@"GroupGoodsCell",@"UserStatusCell",@"RemainingTimeCell",@"MemberInfoCell",@"UITableViewCell"];
    for (int i = 0; i < _cellArray.count; i++) {
        Class cls = NSClassFromString(_cellArray[i]);
        [_delailsTableView registerClass:[cls class] forCellReuseIdentifier:_cellArray[i]];
    }
}

#pragma mark 事件处理
- (void)refreshTableView {
    
    if (_dataSource.count > 0) {
        _groupDetailModel = _dataSource[0];
    }
    
    [_delailsTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_groupDetailModel.UStatus integerValue] >= 3 ? 4 : _cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_groupDetailModel.UStatus integerValue] >= 3) {
        
        if (section == 3) {
            return _groupDetailModel.listArray.count;
        }
    }
    else {
        
        if (section == 4) {
            
            if (_dataSource.count > 0) {
                return _groupDetailModel.listArray.count;
            }
        }
    }
    
    return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        GroupStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupStatusCell"];
        cell.selectionStyle = NO;
        cell.refreshBlock = ^{
            _refreshDataSource();
        };
        [cell setModel:_groupDetailModel];
        return cell;
    }
    else if (indexPath.section == 1) {
        
        GroupGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupGoodsCell"];
        cell.selectionStyle = NO;
        [cell setGroupModel:_myGroupModel];
        
        if ([_groupDetailModel.UStatus integerValue] == 3) {
            [cell.isSuccessImageView setImage:IMAGE(@"FSPT拼团成功")];
        }
        else if ([_groupDetailModel.UStatus integerValue] == 4) {
            [cell.isSuccessImageView setImage:IMAGE(@"FSPT拼团失败")];
        }
        else {
            [cell.isSuccessImageView setImage:nil];
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        
        UserStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserStatusCell"];
        cell.selectionStyle = NO;
        
        if (_groupDetailModel != nil) {
            [cell setModel:_groupDetailModel];
        }
        
        return cell;
    }
    else if (indexPath.section == 3 && [_groupDetailModel.UStatus integerValue] != 4 && [_groupDetailModel.UStatus integerValue] != 3) {
        
        RemainingTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemainingTimeCell"];
        cell.selectionStyle = NO;
        cell.refreshBlock = ^{
            _refreshDataSource();
        };
        
        if (_groupDetailModel != nil) {
            [cell setModel:_groupDetailModel];
            [cell setTime:_groupDetailModel.STime];
        }
        
        return cell;
    }
    else if (indexPath.section == 4 || [_groupDetailModel.UStatus integerValue] >= 3) {
        
        GroupDetailListModel *listModel = _groupDetailModel.listArray[indexPath.row];
        
        MemberInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberInfoCell"];
        cell.selectionStyle = NO;
        [cell setModel:listModel];
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.selectionStyle = NO;
        
        NSString *numberString = [NSString stringWithFormat:@"%zd",[_groupDetailModel.UStatus integerValue] + 1];
        
        PlayGroupView *playGroup = [[PlayGroupView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) andShowNumber:numberString];
        playGroup.goPlayGroup=^(){
            _goController([FSGroupBuyHelperViewController new]);
        };
        
        [cell addSubview:playGroup];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
#pragma mark 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_groupDetailModel.UStatus integerValue] >= 3) {
        
        if (indexPath.section == 0) {
            return 80;
        }
        else if (indexPath.section == 1) {
            return 100;
        }
        else if (indexPath.section == 2) {
            return (ScreenWidth - 60) / 5 + 70;
        }
        else {
            return 60;
        }
    }
    else {
        
        if (indexPath.section == 0) {
            return 80;
        }
        else if (indexPath.section == 1) {
            return 100;
        }
        else if (indexPath.section == 2) {
            return (ScreenWidth - 60) / 5 + 70;
        }
        else if (indexPath.section == 3) {
            return 50;
        }
        else if (indexPath.section == 4) {
            return 60;
        }
        else {
            return 90;
        }
    }
}

#pragma mark 设置断头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark 设置断尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma 点击Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
