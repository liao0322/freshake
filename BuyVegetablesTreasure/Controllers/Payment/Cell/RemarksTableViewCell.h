//
//  RemarksTableViewCell.h
//  BuyVegetablesTreasure
//
//  Created by ky on 15/11/4.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemarksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *remarkText;

@property (nonatomic, copy) void(^remarkBlock)(NSString *remarkText);

@end
