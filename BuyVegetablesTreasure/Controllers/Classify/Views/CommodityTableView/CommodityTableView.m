//
//  CommodityTableView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/20.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "CommodityTableView.h"
#import "LeftClassModel.h"
#import "ClassificationCell.h"
#import "GoodsDetailViewController.h"

#define FrameWidth self.frame.size.width
#define FrameHeight self.frame.size.height
#define SectionHeight 50

@interface CommodityTableView ()

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CommodityTableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCommodityTableView];
    }
    return self;
}

#pragma mark - 初始化
- (void)initCommodityTableView {
    
    _commodityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FrameWidth, FrameHeight) style:UITableViewStyleGrouped];
    _commodityTableView.delegate = self;
    _commodityTableView.dataSource = self;
    _commodityTableView.rowHeight = 110;
    _commodityTableView.separatorStyle = NO;
    [self addSubview:_commodityTableView];
    
    [_commodityTableView registerClass:[ClassificationCell class] forCellReuseIdentifier:@"ClassificationCell"];
}

#pragma mark - 事件处理
#pragma mark 刷新
- (void)refreshTableView {
    [_commodityTableView reloadData];
}

#pragma mark 移动
- (int)move:(float)currentY {
    
    float y = 0;
    for (int i = 0; i < _commodityArray.count; i++) {
        
        y += SectionHeight + 10;
        
        LeftClassModel *model = _commodityArray[i];
        for (int a = 0; a < model.listArray.count; a++) {
            y += 110;
        }
        
        if (y > currentY) {
            return i;
        }
    }
    
    return 0;
}

#pragma mark 移动行
- (void)moveSection:(NSInteger)index {
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [_commodityTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark 添加商品
- (void)addGoodsWithGoodsId:(NSString *)productId ProductNum:(NSString *)productNum TotPrice:(NSString *)totPrice IsUpdateGoodsNumber:(BOOL)isUpdateGoodsNumber indexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uidString = [userDefaults objectForKey:@"UID"];
    NSString *midString = [userDefaults objectForKey:@"MID"];
    NSString *storeIdString = [userDefaults objectForKey:@"merchantsID"];
    
    NSString *urlString;
    if ([Tools isBlankString:uidString]) {
        _goViewController([NSClassFromString(@"ShopLoginViewController") new]);
    }
    else if (isUpdateGoodsNumber) {
        urlString = [NSString stringWithFormat:UpCart,UUID,midString,productId,uidString,productNum,isUpdateGoodsNumber ? @"1" : @"0"];
    }
    else {
        
        if ([productNum integerValue] == 0) {
            urlString = [NSString stringWithFormat:DelCartUrl,UUID,midString,productId,uidString];
        }
        else if ([productNum integerValue] == 1) {
            urlString = [NSString stringWithFormat:ADDCARTURL,productId,UUID,uidString,totPrice,productNum,midString,storeIdString];
        }
        else {
            urlString = [NSString stringWithFormat:UpCart,UUID,midString,productId,uidString,productNum,isUpdateGoodsNumber ? @"1" : @"0"];
        }
    }
    
    
    _updateGoods(urlString,indexPath);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _commodityArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LeftClassModel *model = _commodityArray[section];
    return model.listArray.count;
}

#pragma mark 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassificationCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ClassificationCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LeftClassModel *model = _commodityArray[indexPath.section];
    [cell setGoodsModel:model.listArray[indexPath.row]];
    
    __weak typeof(cell)weakCell = cell;
    cell.goodsBlock = ^(NSString *goodsNum,NSString *goodsID,BOOL isAdd,NSString *salePrice) {
        
        if ([goodsNum integerValue] < 0) {
            goodsNum = @"0";
            return ;
        }
        
        if ([Tools isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]]) {
            return _goViewController([NSClassFromString(@"ShopLoginViewController") new]);
        }
        
        if (isAdd) {
            
            CGRect frame = [weakCell.goodsImageView convertRect:weakCell.goodsImageView.bounds toView:self];
            _addCartAnimation(frame,weakCell.goodsImageView.image);
            _goodsNumber = 1;
        }
        else {
            
            _goodsNumber = -1;
        }
        
        BOOL isUpdateGoodsNumber = YES;
        if ([goodsNum integerValue] == 0 || [goodsNum integerValue] == 2 || isAdd) {
            isUpdateGoodsNumber = NO;
        }
        
        [self addGoodsWithGoodsId:goodsID ProductNum:goodsNum TotPrice:salePrice IsUpdateGoodsNumber:isUpdateGoodsNumber indexPath:indexPath];
    };
    
    [cell setImageClick:^{
        
        GoodsDetailViewController *detail = [[GoodsDetailViewController alloc]init];
        if (_commodityArray.count > 0) {
            
            LeftClassModel *model = _commodityArray[indexPath.section];
            RightGoodsModel *right = model.listArray[indexPath.row];
            detail.ProductId = [right.id integerValue];
        }
        _goViewController(detail);
        
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark 返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}

#pragma mark 返回段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark 创建段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_commodityArray.count > 0) {
        
        LeftClassModel *model = _commodityArray[section];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SectionHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, SectionHeight)];
        headLabel.textColor = [UIColor blackColor];
        headLabel.text = model.CategoryName;
        headLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:headLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), SYSTEM_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xD5D5D5"];
        [bgView addSubview:line];
        
        return bgView;
    }
    
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_currentIndex != [self move:scrollView.contentOffset.y]) {
        _currentIndex = [self move:scrollView.contentOffset.y];
        _moveType(_currentIndex);
    }
}

@end
