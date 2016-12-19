//
//  ScoreCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "ScoreCell.h"

@interface ScoreCell ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textViwe;

// 内容
@property (nonatomic, strong) NSString *contextString;
// 评分
@property (nonatomic, strong) NSString *scoreString;
// 是否匿名
@property (nonatomic, strong) NSString *isAnonymous;
// 图片数组
@property (nonatomic, strong) NSMutableArray *imgArray;


@end

@implementation ScoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imgArray = [NSMutableArray array];
        
        [self initCell];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getImg:)
                                                     name:@"GetImage"
                                                   object:nil];
    }
    
    return self;
}

- (void)initCell {
    
    _contextString = @"";
    _scoreString = @"5";
    _isAnonymous = @"1";
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"您的评价:";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .heightIs(15);
    
    // 评分按钮
    for (int i = 0; i < 5; i++) {
        
        UIImage *img = IMAGE(@"选择星形");
        UIImage *selectImg = IMAGE(@"空星星");
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 10;
        [btn setImage:img forState:UIControlStateNormal];
        [btn setImage:selectImg forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(score:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        btn.sd_layout
        .leftSpaceToView(titleLabel, 15 + (img.size.width + 5) * i)
        .centerYEqualToView(titleLabel)
        .widthIs(img.size.width)
        .heightIs(img.size.height);
    }
    
    // 文本框
    self.textViwe = [UITextView new];
    self.textViwe.font = [UIFont systemFontOfSize:14];
    self.textViwe.delegate = self;
    self.textViwe.layer.borderColor = [UIColor colorWithHexString:@"0xf0f0f0"].CGColor;
    self.textViwe.layer.borderWidth = 0.5;
    [self.contentView addSubview:self.textViwe];
    
    self.textViwe.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(titleLabel, 15)
    .heightIs(80);
    
    // 文本提示
    UILabel *tipLabel = [UILabel new];
    tipLabel.tag = 5;
    tipLabel.text = @"请输入您对商品质量或者服务态度的评价，以便我们为您提供更好的服务!";
    tipLabel.font = [UIFont boldSystemFontOfSize:13];
    tipLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    tipLabel.numberOfLines = 0;
    [self.textViwe addSubview:tipLabel];
    
    tipLabel.sd_layout
    .leftSpaceToView(self.textViwe, 5)
    .rightSpaceToView(self.textViwe, 5)
    .topSpaceToView(self.textViwe, 5)
    .autoHeightRatio(0);
    
    // 上传的图片
    CGFloat widthFloat = (ScreenWidth - 15 * 6) / 5;
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.tag = 50;
    [imgBtn setBackgroundImage:IMAGE(@"add") forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imgBtn];

    imgBtn.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.textViwe, 15)
    .widthIs(widthFloat)
    .heightEqualToWidth();
    
    // 是否匿名
    UIImage *img = IMAGE(@"匿名未勾选");
    UIButton *isAnonymousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    isAnonymousBtn.selected = YES;
    isAnonymousBtn.frame = CGRectMake(20, CGRectGetMaxY(self.textViwe.frame) + 10, img.size.width, img.size.height);
    [isAnonymousBtn setImage:img forState:UIControlStateNormal];
    [isAnonymousBtn setImage:IMAGE(@"匿名勾选") forState:UIControlStateSelected];
    [isAnonymousBtn addTarget:self action:@selector(isAnonymous:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:isAnonymousBtn];
    
    isAnonymousBtn.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(imgBtn, 15)
    .widthIs(img.size.width)
    .heightIs(img.size.height);
    
    // 匿名标题
    UILabel *anonymousLabel = [UILabel new];
    anonymousLabel.text = @"匿名评价";
    anonymousLabel.font = [UIFont systemFontOfSize:13];
    anonymousLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
    [anonymousLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:anonymousLabel];
    
    anonymousLabel.sd_layout
    .leftSpaceToView(isAnonymousBtn, 5)
    .centerYEqualToView(isAnonymousBtn)
    .heightIs(15);
    
    // 提交按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    sendBtn.layer.borderColor = Color.CGColor;
    sendBtn.layer.borderWidth = 1;
    [sendBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [sendBtn setTitleColor:Color forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sendBtn];
    
    sendBtn.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(anonymousLabel, 15)
    .widthIs(ScreenWidth / 5 * 3)
    .heightIs(45);
    
    [self setupAutoHeightWithBottomView:sendBtn bottomMargin:30];
}

#pragma mark 是否匿名
- (void)isAnonymous:(UIButton *)btn {
    btn.selected = !btn.selected;
    _isAnonymous = [NSString stringWithFormat:@"%zd",btn.selected];
}

#pragma mark 分享
- (void)score:(UIButton *)btn {
    
    for (int i = 0; i < 5; i++) {
        
        [(UIButton *)[self viewWithTag:i + 10] setSelected:NO];
        
        if (i > btn.tag - 10) {
            [(UIButton *)[self viewWithTag:i + 10] setSelected:YES];
        }
    }
    
    _scoreString = [NSString stringWithFormat:@"%zd",btn.tag - 9];
}

#pragma mark - UITextViewDelegates
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        [(UILabel *)[self viewWithTag:5] setHidden:NO];
    }
    else {
        [(UILabel *)[self viewWithTag:5] setHidden:YES];
    }
    
    _contextString = textView.text;
}

- (void)btnClick {
    _evaluationBlock(_contextString,_scoreString,_isAnonymous);
}

- (void)imgBtnClick {
    _selectImg();
}

- (void)getImg:(NSNotification *)notification {
    
    if (self.imgArray.count > 5) {
        return;
    }
    else [self.imgArray addObject:[notification object]];
    
    CGFloat widthFloat = (ScreenWidth - 15 * 6) / 5;
    UIButton *imgBtn = [self viewWithTag:self.imgArray.count + 50];
    
    if (imgBtn == nil) {
        
        imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.tag = self.imgArray.count + 50;
        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imgBtn.imageView.clipsToBounds = YES;
        [imgBtn setImage:[notification object] forState:UIControlStateNormal];
        [self.contentView addSubview:imgBtn];
        
        imgBtn.sd_layout
        .leftSpaceToView(self.contentView, 15 + (widthFloat + 15) * (self.imgArray.count - 1))
        .centerYEqualToView([self viewWithTag:50])
        .widthIs(widthFloat)
        .heightEqualToWidth();
        
        [(UIButton *)self viewWithTag:50].sd_layout.leftSpaceToView(self.contentView, 15 + (15 + widthFloat) * self.imgArray.count);
    }
    else if (self.imgArray.count == 5) {
        
        UIButton *imgBtn = [self viewWithTag:50];
        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imgBtn.imageView.clipsToBounds = YES;
        [imgBtn setImage:[notification object] forState:UIControlStateNormal];
        [imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    self.setImage(self.imgArray);
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
