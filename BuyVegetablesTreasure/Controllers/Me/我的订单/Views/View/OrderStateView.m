//
//  OrderStateView.m
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "OrderStateView.h"

@interface OrderStateView ()

@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSArray *selectImgArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation OrderStateView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initOrderStateView];
    }
    return self;
}

- (void)initOrderStateView {
    
    _imgArray = @[@"Myorder_所有订单-灰色",@"Myorder_待付款-灰色",@"Myorder_待提货-灰色",@"Myorder_已提货-灰色",@"Myorder_待评价-灰色"];
    _selectImgArray = @[@"Myorder_所有订单",@"Myorder_待付款",@"Myorder_待提货",@"Myorder_已提货",@"Myorder_待评价"];
    _titleArray = @[@"所有订单",@"待付款",@"待提货",@"已提货",@"待评价"];
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        int btnWidth = SCREEN_WIDTH / _titleArray.count;
        
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.tag = i + 100;
        bgBtn.frame = CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height);
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        float bgBtnWidth = bgBtn.frame.size.width;
        float bgBtnHeight = bgBtn.frame.size.height;
        
        UIImage *img = IMAGE(_imgArray[i]);
        UIImage *selectImg = IMAGE(_selectImgArray[i]);
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:i == 0 ? selectImg : img];
        iconImageView.frame = CGRectMake(bgBtnWidth / 2 - img.size.width / 2,
                                          bgBtnHeight / 2 - img.size.height / 2 - 10,
                                          img.size.width,
                                          img.size.height);
        iconImageView.tag = i + 50;
        [bgBtn addSubview:iconImageView];
        
        UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgBtnHeight - 25, bgBtnWidth, 15)];
        orderStateLabel.tag = i + 60;
        orderStateLabel.text = _titleArray[i];
        orderStateLabel.font = [UIFont systemFontOfSize:12];
        orderStateLabel.textColor = i == 0 ? Color : [UIColor colorWithHexString:@"0x999999"];
        orderStateLabel.textAlignment = NSTextAlignmentCenter;
        [bgBtn addSubview:orderStateLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) - 5, 6, 15, 15)];
        countLabel.tag = i + 70;
        countLabel.font = [UIFont systemFontOfSize:7];
        countLabel.backgroundColor = [UIColor whiteColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = i == 0 ? Color : [UIColor colorWithHexString:@"0x999999"];
        countLabel.layer.borderColor = i == 0 ? Color.CGColor : [UIColor colorWithHexString:@"0xCECECE"].CGColor;
        countLabel.layer.borderWidth = 1;
        countLabel.layer.masksToBounds = YES;
        countLabel.layer.cornerRadius = countLabel.frame.size.width / 2;
        [bgBtn addSubview:countLabel];
    }
}

- (void)btnClick:(UIButton *)btn {

    for (int i = 0; i < _imgArray.count; i++) {
        
        UIImage *img = IMAGE(_imgArray[i]);
        [(UIImageView *)[self viewWithTag:i + 50] setImage:img];
        [(UILabel *)[self viewWithTag:i + 60] setTextColor:[UIColor colorWithHexString:@"0x999999"]];
        [(UILabel *)[self viewWithTag:i + 70] setTextColor:[UIColor colorWithHexString:@"0x999999"]];
        [[(UILabel *)[self viewWithTag:i + 70] layer] setBorderColor:[UIColor colorWithHexString:@"0xCECECE"].CGColor];
    }
    
    UIImage *selectImg = IMAGE(_selectImgArray[btn.tag - 100]);
    [(UIImageView *)[self viewWithTag:btn.tag - 100 + 50] setImage:selectImg];
    [(UILabel *)[self viewWithTag:btn.tag - 100 + 60] setTextColor:Color];
    [(UILabel *)[self viewWithTag:btn.tag - 100 + 70] setTextColor:Color];
    [[(UILabel *)[self viewWithTag:btn.tag - 100 + 70] layer] setBorderColor:Color.CGColor];
    
    if (btn.tag == 100) {
        _stateUrl = ORDER;
    }
    else if (btn.tag == 101) {
        _stateUrl = WAITPAY;
    }
    else if (btn.tag == 102) {
        _stateUrl = SHIPED;
    }
    else if (btn.tag == 103) {
        _stateUrl = FINISHED;
    }
    else if (btn.tag == 104) {
        _stateUrl = WAITCOMMENT;
    }
    
    NSString *midString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UID"];
    NSString *urlString = [NSString stringWithFormat:_stateUrl,1,1000,midString];
    NSLog(@"%@",urlString);
    _requestOrder(urlString);
}

- (void)setCountLabelWithModel:(MyOrderModel *)model {
    
    NSArray *arr = @[model.OrderCount,model.NoPaymentCount,model.NoPickupCount,model.CompleteCount,model.EvaluateCount];
    
    for (int i = 0; i < 5; i++) {
        
        NSString *countString = [NSString stringWithFormat:@"%zd",[arr[i] integerValue]];
        if ([arr[i] integerValue] > 99) {
            countString = @"99+";
        }
        
        [(UILabel *)[self viewWithTag:i + 70] setText:countString];
        [(UILabel *)[self viewWithTag:i + 70] setHidden:[countString isEqualToString:@"0"] ? YES : NO];
    }
}


@end
