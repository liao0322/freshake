//
//  GroupMidNameCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 16/4/5.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "GroupMidNameCell.h"

@implementation GroupMidNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell {
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantsName"];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
    [self.contentView addSubview:line];
}

@end
