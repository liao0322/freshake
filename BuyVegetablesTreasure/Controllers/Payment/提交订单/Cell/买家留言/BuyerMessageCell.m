//
//  BuyerMessageCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/10/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "BuyerMessageCell.h"

@implementation BuyerMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"买家留言:";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = Color;
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [self.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;;
    textField.placeholder = @"可输入100字以内特殊要求";
    [textField addTarget:self
                  action:@selector(wordDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:textField];
    
    textField.sd_layout
    .leftSpaceToView(titleLabel, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 7.5)
    .bottomSpaceToView(self.contentView, 7.5);
    
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
    line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
}

- (void)wordDidChange:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"userRemark"];
}

@end
