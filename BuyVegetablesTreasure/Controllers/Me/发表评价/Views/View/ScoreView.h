//
//  ScoreView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface ScoreView : UIView<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *orderStatusLabel;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) Order *model;

@property (nonatomic, strong) void(^evaluationBlock)(NSString *contextString,NSString *scoreString,NSString *isAnonymous);
@property (nonatomic, strong) void(^selectImg)(NSInteger type);
@property (nonatomic, strong) void(^setImage)(NSArray *imgArray);

- (void)refreshTableView;

@end
