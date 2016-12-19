//
//  ScoreCell.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/5/11.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCell : UITableViewCell

@property (nonatomic, strong) void(^evaluationBlock)(NSString *contextString,NSString *scoreString,NSString *isAnonymous);
@property (nonatomic, strong) void(^selectImg)();
@property (nonatomic, strong) void(^setImage)(NSArray *imgArray);

@end
