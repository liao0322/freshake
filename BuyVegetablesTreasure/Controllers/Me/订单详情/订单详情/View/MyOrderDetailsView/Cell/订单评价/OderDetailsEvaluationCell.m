//
//  OderDetailsEvaluationCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/7.
//
//

#import "OderDetailsEvaluationCell.h"

@interface OderDetailsEvaluationCell ()

// 商品名称
@property (nonatomic, strong) UILabel *goodsNameLabel;
// 评价
@property (nonatomic, strong) UILabel *evaluationLabel;

@end

@implementation OderDetailsEvaluationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    // 评分星星
    for (int i = 0; i < 5; i++) {
        
        UIImage *img = IMAGE(@"Order_Stars");
        UIImageView *imgView = [UIImageView new];
        imgView.image = img;
        imgView.tag = i + 300;
        [self.contentView addSubview:imgView];
        
        imgView.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 15)
        .widthIs(img.size.width)
        .heightIs(img.size.height);
        
        if (i > 0) {
            imgView.sd_layout.leftSpaceToView([self viewWithTag:i + 299], 1);
        }
    }
    
    // 商品名称
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.font = [UIFont systemFontOfSize:13];
    _goodsNameLabel.textColor = TextColor;
    _goodsNameLabel.textAlignment = NSTextAlignmentRight;
    [_goodsNameLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsNameLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView([self viewWithTag:300])
    .heightIs(15);
    
    // 线
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView([self viewWithTag:300], 15)
    .heightIs(0.5);
    
    // 评分
    _evaluationLabel = [UILabel new];
    _evaluationLabel.font = [UIFont systemFontOfSize:13];
    _evaluationLabel.textColor = TextColor;
    _evaluationLabel.numberOfLines = 0;
    [self.contentView addSubview:_evaluationLabel];
    
    _evaluationLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(line, 15)
    .autoHeightRatio(0);
    
    UILabel *bottomLine = [UILabel new];
    bottomLine.backgroundColor = LineColor;
    [self.contentView addSubview:bottomLine];
    
    bottomLine.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(_evaluationLabel, 15)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
}

- (void)setEvaluationModel:(EvaluationModel *)evaluationModel {
    
    for (int i = 0; i < [evaluationModel.level intValue]; i++) {
        [(UIImageView *)[self viewWithTag:i + 300] setImage:IMAGE(@"Order_Stars_Selected")];
    }

    if (isBlankString(evaluationModel.Context)) {
        _evaluationLabel.text = @" ";
    }
    else {
        _evaluationLabel.text = evaluationModel.Context;
    }
    
    _goodsNameLabel.text = evaluationModel.productName;
    
}

@end
