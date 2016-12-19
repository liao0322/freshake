//
//  UserStatusCell.m
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/4/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "UserStatusCell.h"
#import "GroupDetailListModel.h"

@interface UserStatusCell ()

@property (nonatomic, copy) UILabel *titleLabel;

@end

@implementation UserStatusCell

- (void)setModel:(GroupDetailModel *)model {
    
    if (_titleLabel == nil) {
        
        int width = (ScreenWidth - 60) / 5;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width + 30, ScreenWidth, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 2; i++) {
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, (width + 70) * i, ScreenWidth, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xE2E2E2"];
            [self.contentView addSubview:line];
        }
        
        GroupDetailListModel *listModel = model.listArray[0];
        if ([model.UStatus isEqualToString:@"4"]) {
            
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - width / 2, (width + 70) / 2 - width / 2, width, width)];
            bgImageView.image = [UIImage imageNamed:@"小椭圆"];
            bgImageView.clipsToBounds = YES;
            [self.contentView addSubview:bgImageView];
            
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width - 2, width - 2)];
            headImageView.layer.cornerRadius = width / 2;
            headImageView.layer.masksToBounds = YES;
            [headImageView sd_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:IMAGE(@"头像三")];
            [bgImageView addSubview:headImageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - width / 2, CGRectGetMaxY(bgImageView.frame), width, 20)];
            nameLabel.text = listModel.mobile;
            nameLabel.font = [UIFont systemFontOfSize:13];
            nameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:nameLabel];
        }
        else {
            
            for (int i = 0; i < [model.ActivityUserNum integerValue]; i++) {
                
                UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (10 + width) * i, 10, width, width)];
                bgImageView.image = [UIImage imageNamed:@"小椭圆"];
                bgImageView.clipsToBounds = YES;
                [self.contentView addSubview:bgImageView];
                
                UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, width - 2, width - 2)];
                headImageView.layer.cornerRadius = width / 2;
                headImageView.layer.masksToBounds = YES;
                headImageView.image = [UIImage imageNamed:@"头像三"];
                [bgImageView addSubview:headImageView];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (10 + width) * i, CGRectGetMaxY(bgImageView.frame), width, 20)];
                nameLabel.text = @"等待加入";
                nameLabel.font = [UIFont systemFontOfSize:13];
                nameLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
                nameLabel.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:nameLabel];
                
                if (i < model.listArray.count) {
                    
                    GroupDetailListModel *listModel = model.listArray[i];
                    nameLabel.text = listModel.mobile;
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:IMAGE(@"头像三")];
                }
            }
        }
    }
    
    if (![model.UStatus isEqualToString:@"4"]) {
        
        NSString *string = [NSString stringWithFormat:@"%zd",[model.ActivityUserNum integerValue] - model.listArray.count];
        if ([string integerValue] < 0) {
            string = @"0";
        }
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还差%@人，盼你如南方人盼暖气。",string]];
        [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0xfc9d15"], NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, 4)];
        
        _titleLabel.attributedText = attributeString;
        
        if ([string isEqualToString:@"0"]) {
            _titleLabel.hidden = YES;
        }
        else {
            _titleLabel.hidden = NO;
        }
    }
}

@end
