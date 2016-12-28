//
//  SiteLocationCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/16.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "SiteLocationCell.h"

@implementation SiteLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    self.imageView.image = [IMAGE(@"地标") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView.tintColor = [UIColor colorDomina];
    self.textLabel.text = @"查询提货点";
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = Color;
}

- (void)updateName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *titleString = [userDefaults objectForKey:@"topAdree"];
    
    if ([Tools isBlankString:titleString]) {
        self.textLabel.text = @"查询提货点";
    }
    else {
        self.textLabel.text = titleString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
