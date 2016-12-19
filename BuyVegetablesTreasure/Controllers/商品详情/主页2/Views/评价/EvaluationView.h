//
//  EvaluationView.h
//  BuyVegetablesTreasure
//
//  Created by Kai on 16/1/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, copy) UITableView *evaluationTableView;
@property (nonatomic, copy) NSArray *evalutationArray;
@property (nonatomic, copy) NSArray *evalutationCountArray;

@property (nonatomic, copy) void(^scoreBlock)(NSString *string);

@end
