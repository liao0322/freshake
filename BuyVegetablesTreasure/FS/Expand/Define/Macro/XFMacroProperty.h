//
//  XFMacroProperty.h
//  XFiOSKitDemo
//
//  Created by DamonLiao on 2016/12/5.
//  Copyright © 2016年 DamonLiao. All rights reserved.
//

#ifndef XFMacroProperty_h
#define XFMacroProperty_h

#define String(__param__) @property (copy, nonatomic) NSString *__param__
#define Label(__param__) @property (strong, nonatomic) UILabel *__param__
#define ImageView(__param__) @property (strong, nonatomic) UIImageView *__param__
#define Button(__param__) @property (strong, nonatomic) UIButton *__param__
#define Delegate(__param__) @property (weak, nonatomic) id<__param__> delegate
#define View(__param__) @property (strong, nonatomic) UIView *__param__
#define TextField(__param__) @property (strong, nonatomic) UITextField *__param__

#define dictionary(__param__)  @property(nonatomic,copy)NSDictionary *__param__
#define Bool(__param__)    @property(nonatomic,assign)BOOL __param__
#define FLOAT(__param__)   @property(nonatomic,assign)CGFloat __param__
#define tableView(__param__) @property(nonatomic,strong)UITableView *__param__
#define muArray(__param__) @property(nonatomic,strong)NSMutableArray *__param__
#define number(__param__) @property(nonatomic,copy)NSNumber *__param__

#endif /* XFMacroProperty_h */
