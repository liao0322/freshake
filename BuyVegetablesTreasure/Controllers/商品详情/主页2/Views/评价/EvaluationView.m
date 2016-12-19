//
//  EvaluationView.m
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/1/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "EvaluationView.h"
#import "EvaluationViewCell.h"
#import "ReviewImagesView.h"

@interface EvaluationView ()

@property (nonatomic, strong) ReviewImagesView *reviewImagesView;

@end

@implementation EvaluationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initReviewImagesView];
        [self initEvaluationTableView];
    }
    return self;
}

- (void)initReviewImagesView {
    
    self.reviewImagesView = [ReviewImagesView new];
    self.reviewImagesView.hidden = YES;
    self.reviewImagesView.backgroundColor = [UIColor blackColor];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.reviewImagesView];
    
    self.reviewImagesView.sd_layout
    .leftEqualToView([[UIApplication sharedApplication].delegate window])
    .rightEqualToView([[UIApplication sharedApplication].delegate window])
    .topEqualToView([[UIApplication sharedApplication].delegate window])
    .bottomEqualToView([[UIApplication sharedApplication].delegate window]);
}

- (void)initEvaluationTableView {
    
    NSArray *arr = @[@"全部评价",@"好评",@"中评",@"差评"];
    for (int i = 0; i < arr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 10;
        btn.selected = [Single sharedInstance].level == i ? YES : NO;
        btn.frame = CGRectMake(ScreenWidth / 4 * i, 0, ScreenWidth / 4, 39);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x606060"] forState:UIControlStateNormal];
        [btn setTitleColor:Color forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        UIButton *evalutationCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        evalutationCountButton.tag = i + 20;
        evalutationCountButton.frame = CGRectMake(ScreenWidth / 4 * i, CGRectGetMaxY(btn.frame), ScreenWidth / 4, 10);
        evalutationCountButton.selected = [Single sharedInstance].level == i ? YES : NO;
        evalutationCountButton.titleLabel.font = [UIFont systemFontOfSize:11];
        evalutationCountButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [evalutationCountButton setTitleColor:[UIColor colorWithHexString:@"0x606060"] forState:UIControlStateNormal];
        [evalutationCountButton setTitleColor:Color forState:UIControlStateSelected];
        [self addSubview:evalutationCountButton];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xE1E1E1"];
    [self addSubview:line];
    
    _evaluationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, ScreenWidth, ScreenHeight - 55 - 64 - 50 - 53)];
    _evaluationTableView.backgroundColor = [UIColor whiteColor];
    _evaluationTableView.delegate = self;
    _evaluationTableView.dataSource = self;
    _evaluationTableView.tableFooterView = [[UIView alloc] init];
    _evaluationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_evaluationTableView];
    
    [_evaluationTableView registerClass:[EvaluationViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)btnClick:(UIButton *)btn {
    
    [Single sharedInstance].level = btn.tag - 10;
    _scoreBlock([NSString stringWithFormat:@"%zd",btn.tag - 10]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    for (int i = 0; i < 4; i++) {
        
        UIButton *evalutationCountButton = (UIButton *)[self viewWithTag:i + 20];
        [evalutationCountButton setTitle:[NSString stringWithFormat:@"(%@)",_evalutationCountArray[i]] forState:UIControlStateNormal];
    }
    
    return _evalutationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setModel:_evalutationArray[indexPath.row]];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [cell setImgClickBlock:^(EvaluationModel *model, NSInteger index) {
        self.reviewImagesView.model = model;
        self.reviewImagesView.index = index;
        self.reviewImagesView.hidden = NO;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView cellHeightForIndexPath:indexPath
                                       model:self.evalutationArray[indexPath.row]
                                     keyPath:@"model"
                                   cellClass:[EvaluationViewCell class]
                            contentViewWidth:ScreenWidth];
}

@end
