//
//  RecordTableViewCell.m
//  BuyVegetablesTreasure
//
//  Created by Song on 16/3/14.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell
{
    UILabel *line1;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2, 40)];
    _numLabel.font = [UIFont systemFontOfSize:15];
    _numLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_numLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, 0, 190, 40)];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    _timeLabel.textColor = [UIColor colorWithHexString:@"0x9999999"];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_numLabel.frame), SCREEN_WIDTH-30, 40)];
    _detailLabel.font = [UIFont systemFontOfSize:13];
    _detailLabel.textColor = [UIColor colorWithHexString:@"0x9999999"];
    _detailLabel.numberOfLines = 0;
    [self addSubview:_detailLabel];
    
    
    
   
    
}
-(void)setData:(RechardModel *)model
{
    if (model)
    {
        if (line1 == nil)
        {
            line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            line1.backgroundColor = [UIColor colorWithHexString:@"0xe8e8e8"];
            [self addSubview:line1];
        }
    }
    
    if (model.isPoint) {
        
        if ([model.value integerValue] >= 0) {
            _numLabel.text = [NSString stringWithFormat:@"+%@",model.value];
            _numLabel.textColor = [UIColor colorWithHexString:@"0xff5f3e"];
        }
        else {
            _numLabel.text = [NSString stringWithFormat:@"%@",model.value];
            _numLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        }

        _detailLabel.text = model.remark;
    }
    else {
    
        if ([model.status integerValue] > 0) {
            
            if ([model.value integerValue] >= 0)
            {
                _numLabel.text = [NSString stringWithFormat:@"+%@",model.value];
                _numLabel.textColor = [UIColor colorWithHexString:@"0xff5f3e"];
            }
            else {
                _numLabel.text = [NSString stringWithFormat:@"%@",model.value];
                _numLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
            }
            
            _detailLabel.text = [NSString stringWithFormat:@"%@成功",model.remark];
        }
        else {
            
            _numLabel.text = [NSString stringWithFormat:@"%@",model.value];
            _numLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            
            _detailLabel.text = [NSString stringWithFormat:@"%@失败",model.remark];
        }
    }
    
    _timeLabel.text = model.add_time;
    
    CGRect frame = _detailLabel.frame;
    frame.size.height = model.contHeight + 15;
    _detailLabel.frame = frame;
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_detailLabel.frame)+9, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"0xe8e8e8"];
    [self addSubview:line2];
    
}

@end
