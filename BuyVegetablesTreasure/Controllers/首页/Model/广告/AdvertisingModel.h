//
//  AdvertisingModel.h
//  VegetablesApp
//
//  Created by M on 16/5/27.
//  Copyright © 2016年 M. All rights reserved.
//

#import "ParentModel.h"

@interface AdvertisingModel : ParentModel

@property (nonatomic, strong) NSArray *AdRList;
@property (nonatomic, strong) NSArray *AdSList;
@property (nonatomic, strong) NSArray *AdXList;
@property (nonatomic, strong) NSArray *AdSTList;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *ImgUrl;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Url;
@property (nonatomic, strong) NSString *ObjectId;
@property (nonatomic, strong) NSString *ObjectType;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) UIImage *defaultImg;

@end
