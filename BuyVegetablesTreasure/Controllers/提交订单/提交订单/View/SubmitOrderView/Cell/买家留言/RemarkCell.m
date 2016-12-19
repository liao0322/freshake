//
//  RemarkCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/23.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RemarkCell.h"

@implementation RemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"买家留言:";
    titleLabel.font = TextFontSize;
    titleLabel.textColor = Color;
    titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 5)
    .heightIs(35)
    .widthIs(65);
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:14];;
    textField.placeholder = @"可输入100字以内的特殊要求";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField addTarget:self
                  action:@selector(textFieldEditChanged:)
        forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:textField];
    
    textField.sd_layout
    .leftSpaceToView(titleLabel, 10)
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(titleLabel)
    .heightIs(30);
    
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(0.5);
}

- (void)textFieldEditChanged:(UITextField *)textField {
    [Single sharedInstance].remark = textField.text;
}


@end
