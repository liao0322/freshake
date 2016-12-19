//
//  ScoreView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ScoreView.h"
#import "ScoreCell.h"
#import "MyOrderGoodsCell.h"

@implementation ScoreView 

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initOrderTableView];
    }
    return self;
}

- (void)initOrderTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[MyOrderGoodsCell class] forCellReuseIdentifier:@"GoodsCell"];
    [_tableView registerClass:[ScoreCell class] forCellReuseIdentifier:@"ScoreCell"];
}

- (void)initUIActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您可以上传5张图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", nil];
    [actionSheet addButtonWithTitle:@"相册"];
    [actionSheet showInView:_tableView];
}

#pragma mark 刷新
- (void)refreshTableView {
    [_tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dic = _model.List[0];
    
    return 2 - [dic[@"evaluation"] boolValue] + _model.List.count;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            for (int i = 0; i < 2; i++) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * (CGRectGetHeight(cell.frame) - 0.5), ScreenWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xE4E4E4"];
                [cell addSubview:line];
            }
        }
        
        
        NSDictionary *dic = _model.List[0];
        
        _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(cell.frame))];
        _orderStatusLabel.text = [dic[@"evaluation"] boolValue] ? @"已评价" : @"待评价";
        _orderStatusLabel.font = [UIFont systemFontOfSize:13];
        _orderStatusLabel.textColor = Color;
        _orderStatusLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = _orderStatusLabel;
        
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.imageView.image = IMAGE(@"订单号");
        cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",_model.order_no];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        
        return cell;
    }
    else if (indexPath.row == _model.List.count + 1) {
        
        ScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.evaluationBlock = ^(NSString *contextString,NSString *scoreString,NSString *isAnonymous) {
            _evaluationBlock(contextString,scoreString,isAnonymous);
        };
        
        [cell setSelectImg:^{
            [self initUIActionSheet];
//            self.selectImg();
        }];
        
        [cell setSetImage:^(NSArray *imgArray) {
            self.setImage(imgArray);
        }];
        
        return cell;
    }
    
    MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell"];
    cell.selectionStyle = UITableViewCellStyleDefault;
    [cell setModel:_model.List[indexPath.row - 1]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 50;
    }
    else if (indexPath.row == _model.List.count + 1) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenWidth tableView:tableView];
    }
    
    return 100;
}

#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        _selectImg(0);
        NSLog(@"相机");
    }
    else if (buttonIndex == 2) {
        _selectImg(1);
        NSLog(@"相册");
    }
}

@end
