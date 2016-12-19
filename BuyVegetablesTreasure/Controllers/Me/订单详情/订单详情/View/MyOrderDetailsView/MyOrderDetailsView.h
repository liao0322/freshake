//
//  MyOrderDetailsView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/5.
//
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailsModel.h"
#import "EvaluationModel.h"

@interface MyOrderDetailsView : UIView

// 订单详情
@property (nonatomic, strong) MyOrderDetailsModel *orderDetailsModel;
// 评价数组
@property (nonatomic, strong) NSArray *evaluationArray;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 订单结束
@property (nonatomic, strong) void(^overdue)();

@end
