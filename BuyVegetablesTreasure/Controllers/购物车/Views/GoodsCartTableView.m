//
//  GoodsCartTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GoodsCartTableView.h"
#import "GoodsCartCell.h"

#define SectionHeight 50

@interface GoodsCartTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) UITableView *goodsCartTableView;

@end

@implementation GoodsCartTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _point = @"0";
        _tick = @"0";
        [self initCommodityTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initCommodityTableView {
    
    _goodsCartTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _goodsCartTableView.delegate = self;
    _goodsCartTableView.dataSource = self;
    _goodsCartTableView.rowHeight = 110;
    _goodsCartTableView.separatorStyle = NO;
    [self addSubview:_goodsCartTableView];
    
    _goodsCartTableView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    [_goodsCartTableView registerClass:[GoodsCartCell class] forCellReuseIdentifier:@"GoodsCartCell"];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_goodsCartTableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _goodsCartArray.count;
    }
    else return 1;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GoodsCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCartCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShopCart *model = _goodsCartArray[indexPath.row];
        [cell setModel:model];
        
        cell.goodsNumberBlock = ^(NSInteger goodsNumber, BOOL isDel, BOOL isAdd)
        {
            if (isAdd) {
                goodsNumber += 1;
            }
            else {
                goodsNumber -= 1;
            }
            
            _indexPath = indexPath;
            _goodsNumber = goodsNumber <= 0 ? 1 : goodsNumber;
            
            if (goodsNumber <= 0) {
                
                goodsNumber = 1;
                _deleteCartGoods(model.productId);
            }
            else {
                
                _upCartGoodsNumber(goodsNumber,model.productId,isAdd);
            }

            [_goodsCartTableView reloadData];
        };
        
        [cell setBtnClick:^{
           
            ShopCart *model = _goodsCartArray[indexPath.row];
            model.isSelect = !model.isSelect;
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_goodsCartArray];
            [arr replaceObjectAtIndex:indexPath.row withObject:model];
            
            if (_bottomViewBlock) {
                _bottomViewBlock();
            }
            
            _goodsCartArray = arr;
            [_goodsCartTableView reloadData];
            
        }];
        
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        NSString *pointString = [NSString stringWithFormat:@"积分%@,可抵用%.2f元",_point, [_point floatValue] / 100];
        NSString *tickCountString = [NSString stringWithFormat:@"优惠券%@张",_tick];
        NSArray *arr = @[@"你还可以使用积分和优惠券购买商品",pointString,tickCountString];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            for (int i = 0; i < 3; i++) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20 + i * 25, ScreenWidth - 30, 15)];
                label.text = arr[i];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorWithHexString:@"0x403f3f"];
                label.tag = i + 100;
                [cell addSubview:label];
            }
            
            for (int i = 0; i < 2; i++) {
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 110, ScreenWidth, 1)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
                [cell addSubview:line];
            }
        }
        
        for (int i = 0; i < arr.count; i++) {
            [(UILabel *)[self viewWithTag:i + 100] setText:arr[i]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDelegate
#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return SectionHeight;
    }
    
    return 0.01;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark 返回段头View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_goodsCartArray.count > 0 && section == 1) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
        [bgView addSubview:line];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, SectionHeight)];
        nameLabel.text = @"商品总价";
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorWithHexString:@"0x161616"];
        [bgView addSubview:nameLabel];
        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 10, 0, ScreenWidth - CGRectGetMaxX(nameLabel.frame) - 20, SectionHeight)];
        totalPriceLabel.font = [UIFont systemFontOfSize:14];
        totalPriceLabel.textColor = [UIColor colorWithHexString:@"0x161616"];
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:totalPriceLabel];
        
        float totalPrice = 0.0;
        for (int i = 0; i < _goodsCartArray.count; i++) {
            
            ShopCart *model = _goodsCartArray[i];
            if (!model.isSelect) {
                
                totalPrice += [model.salePrice floatValue] * [model.productNum integerValue];
            }
        }
        totalPriceLabel.text = [NSString stringWithFormat:@"总计：¥%.2f",totalPrice];
        
        return bgView;
    }
    
    return nil;
}

@end
