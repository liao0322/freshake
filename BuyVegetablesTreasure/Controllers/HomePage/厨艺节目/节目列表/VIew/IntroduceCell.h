//
//  IntroduceCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/4/26.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookingProgramListModel.h"

@interface IntroduceCell : UITableViewCell

@property (nonatomic, copy) CookingProgramListModel *model;
@property (nonatomic, copy) void(^isCollect)(NSString *idString, NSString *nameString,BOOL isCollect);

- (void)setModel:(CookingProgramListModel *)model;

@end
