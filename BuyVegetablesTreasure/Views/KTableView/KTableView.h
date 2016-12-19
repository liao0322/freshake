//
//  KTableView.h
//  BuyVegetablesTreasure
//
//  Created by M on 16/9/8.
//
//

#import <UIKit/UIKit.h>

@interface KTableView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
