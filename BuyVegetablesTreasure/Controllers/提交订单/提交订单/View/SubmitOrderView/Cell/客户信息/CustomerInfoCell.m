//
//  CustomerInfoCell.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/12.
//
//

#import "CustomerInfoCell.h"

@implementation CustomerInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderColor = LineColor.CGColor;
        self.layer.borderWidth = 0.5;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
//    NSArray *titles = @[@"提货人:",@"电话:",@"买家留言:"];
    NSArray *titles = @[@"提货人:",@"电话:"];

//    NSArray *placeholders = @[@"输入提货人",@"输入电话",@"可输入100字以内的特殊要求"];
    NSArray *placeholders = @[@"输入提货人",@"输入电话"];

    for (int i = 0; i < 2; i++) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titles[i];
        titleLabel.font = TextFontSize;
        titleLabel.textColor = Color;
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 10 + 40 * i)
        .heightIs(35)
        .widthIs(65);
        
        UITextField *textField = [UITextField new];
        textField.tag = i + 90;
        textField.font = [UIFont systemFontOfSize:14];;
        textField.placeholder = placeholders[i];
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
    }
}

- (void)textFieldEditChanged:(UITextField *)textField {

    if (textField.tag == 90) {
        [Single sharedInstance].userName = textField.text;
    }
    else if (textField.tag == 91) {
        [Single sharedInstance].userTel = textField.text;
    
    }
//    else if (textField.tag == 92) {
//        [Single sharedInstance].remark = textField.text;
//    }
}

- (void)setData {
    
    for (int i = 0; i < 2; i++) {
        
        NSString *string = @"";
        if (i == 0) {
            string = [Single sharedInstance].userName;
        }
        else {
            string = [Single sharedInstance].userTel;
        }
//        else {
////            string = [Single sharedInstance].remark;
//            string = @"";
//        }
        
        if (isBlankString(string)) {
            string = @"";
        }
        
        [(UITextField *)[self viewWithTag:i + 90] setText:string];
//        [(UITextField *)[self viewWithTag:i + 90] setText:@""];
    }
}

@end
