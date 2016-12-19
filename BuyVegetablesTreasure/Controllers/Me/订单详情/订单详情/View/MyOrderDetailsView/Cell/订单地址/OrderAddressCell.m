//
//  OrderAddressCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import "OrderAddressCell.h"

@interface OrderAddressCell ()

@property (nonatomic, strong) UILabel *line;

@end

@implementation OrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 店铺信息
    NSArray *branchTitles = @[@"提货地址:",@"提货点:",@"电话:"];
    for (int i = 0; i < branchTitles.count; i++) {
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        titleLabel.tag = i + 300;
        titleLabel.numberOfLines = 0;
        titleLabel.text = branchTitles[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
        [self.contentView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 10)
        .autoHeightRatio(0);
        
        // 内容
        UILabel *contentLabel = [UILabel new];
        contentLabel.numberOfLines = 0;
        contentLabel.tag = i + 100;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:contentLabel];
        
        contentLabel.sd_layout
        .leftSpaceToView(titleLabel, 20)
        .rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(titleLabel)
        .autoHeightRatio(0);
        
        if (i >= 1) {
            
            titleLabel.sd_layout.topSpaceToView((UILabel *)[self viewWithTag:i + 99], 5);
        }
    }
    
    // 线
    self.line = [UILabel new];
    self.line.backgroundColor = LineColor;
    [self.contentView addSubview:self.line];
    
    self.line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView((UILabel *)[self viewWithTag:102], 10)
    .heightIs(0.5);
    
    
    NSArray *userTitles = @[@"提货人:",@"电话:",@"预约时间:",@"买家留言:"];
    for (int i = 0; i < userTitles.count; i++) {
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        titleLabel.tag = 500 + i;
        titleLabel.numberOfLines = 0;
        titleLabel.text = userTitles[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
        [self.contentView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.line, 10)
        .autoHeightRatio(0);
        
        // 内容
        UILabel *contentLabel = [UILabel new];
        contentLabel.numberOfLines = 0;
        contentLabel.tag = i + 200;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:contentLabel];
        
        contentLabel.sd_layout
        .leftSpaceToView(titleLabel, 20)
        .rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(titleLabel)
        .autoHeightRatio(0);
        
        if (i > 0) {
            titleLabel.sd_layout.topSpaceToView((UILabel *)[self viewWithTag:i + 199], 5);
        }
    }
    
    // 底部线
    UILabel *bottomLine = [UILabel new];
    bottomLine.backgroundColor = LineColor;
    [self.contentView addSubview:bottomLine];
    
    bottomLine.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView((UILabel *)[self viewWithTag:203], 10)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
}

- (void)setOrderDetailsModel:(MyOrderDetailsModel *)orderDetailsModel {
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LineColor.CGColor;
    
    // 商家信息
    NSArray *branchInfos = @[orderDetailsModel.addr,
                             orderDetailsModel.fendian,
                             orderDetailsModel.tel];
    for (int i = 0; i < branchInfos.count; i++) {
        
        if ([Tools isBlankString:branchInfos[i]]) {
            [(UILabel *)[self viewWithTag:i + 100] setText:@"无"];
        }
        else [(UILabel *)[self viewWithTag:i + 100] setText:branchInfos[i]];
    }
    
    NSArray *userInfos = @[orderDetailsModel.username,
                           orderDetailsModel.telphone,
                           orderDetailsModel.DeliveryTime,
                           orderDetailsModel.message];
    for (int i = 0; i < userInfos.count; i++) {
        
        if ([Tools isBlankString:userInfos[i]]) {
            [(UILabel *)[self viewWithTag:i + 200] setText:@"无"];
        }
        else [(UILabel *)[self viewWithTag:i + 200] setText:userInfos[i]];
    }
    
    // 判断是否配送
    if ([orderDetailsModel.express_id intValue] == 1) {
        
        [(UILabel *)[self viewWithTag:300] setText:@"送货地址:"];
        [(UILabel *)[self viewWithTag:100] setText:orderDetailsModel.address];
        [(UILabel *)[self viewWithTag:101] setText:@""];
        [(UILabel *)[self viewWithTag:301] setText:@""];
        [(UILabel *)[self viewWithTag:500] setText:@"收货人:"];
        [(UILabel *)[self viewWithTag:302] setHidden:YES];
        [(UILabel *)[self viewWithTag:102] setHidden:YES];
        
        self.line.sd_layout.topSpaceToView([self viewWithTag:300], 10);
    }
    else {
        
        [(UILabel *)[self viewWithTag:202] setText:orderDetailsModel.picktime];
    }
}

@end
