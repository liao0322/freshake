//
//  GoodsDetailViewController.h
//  BuyVegetablesTreasure
//
//  Created by sc on 16/1/21.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationView.h"
#import "GoodsDetailsView.h"
#import "FSBaseViewController.h"

@interface GoodsDetailViewController : FSBaseViewController

@property (nonatomic, assign) NSInteger ProductId;  // 商品ID
@property (nonatomic, assign) NSInteger wid;        // 用户ID
@property (nonatomic, assign) NSInteger wtotPrice;  // 价格
@property (nonatomic, assign) NSInteger productNum; // 数量
@property (nonatomic, assign) NSInteger stork;      // 库存
@property (nonatomic, assign) BOOL   isUpselling;   // 是否下架

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *telphone;     // 联系电话
@property (nonatomic, copy) NSString *address;      // 地址

@property (nonatomic, copy) NSString *isCollect;    //是否是收藏的立即购买
@property (nonatomic, copy) NSString *goodsStoreID;
@property (nonatomic, copy) NSString *Gaddress;
@property (nonatomic, copy) NSString *fendianName;  // 提货点名称
@property (nonatomic, copy) NSString *midStr;       // 商家ID
@property (nonatomic, copy) NSString *pickTime;     // 提货点时间
@property (nonatomic, copy) NSString *pickJuli;     // 提货点距离
@property (nonatomic, copy) NSString *isCollectStr;

@property (nonatomic, copy) NSMutableArray *dataSourse;     // 保存数据
@property (nonatomic, copy) NSMutableArray *evalutationArray;
@property (nonatomic, copy) NSMutableArray *evalutationCountArray;

@property (nonatomic, copy) UIView *bottomview;             // 底部按钮
@property (nonatomic, copy) UILabel *emblem;                // 购物车数量
@property (nonatomic, copy) UIButton *addbutton;            // 加入购物车
@property (nonatomic, copy) UIButton *buybutton;            // 立即购买
@property (nonatomic, copy) UIButton *soldOutButton;        // 下架中
@property (nonatomic, copy) UIBarButtonItem *collectBBI;    // 收藏按钮
@property (nonatomic, copy) UITableView *evaluationTableView;           
@property (nonatomic, copy) UITableView *goodsDetailTableView;          // 商品详情
@property (nonatomic, copy) UIScrollView *bottomScrollView;             // 底部滚动视图
@property (nonatomic, copy) UIScrollView *goodsImageDetailsScrollView;  // 商品图文详情
@property (nonatomic, copy) UIScrollView *detailsScrollView;
@property (nonatomic, copy) UIImageView *imageView;

@property (nonatomic, copy) EvaluationView *evalutationView;
@property (nonatomic, copy) GoodsDetailsView *goodsDetailsView;

@end
