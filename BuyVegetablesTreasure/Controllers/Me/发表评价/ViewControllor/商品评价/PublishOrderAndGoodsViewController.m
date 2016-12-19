//
//  PublishOrderAndGoodsViewController.m
//  BuyVegetablesTreasure
//
//  Created by XiaoBeiMAC on 15/11/30.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "PublishOrderAndGoodsViewController.h"
#import "MyGoodsModel.h"
#import "ScoreView.h"

@interface PublishOrderAndGoodsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *goodsIDStr;
@property (nonatomic, strong) NSArray *goodsImageArray;

@end

@implementation PublishOrderAndGoodsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNav];

    for (int i = 0; i < _orderModel.List.count; i++) {
        
        NSDictionary *dic = _orderModel.List[i];
        if ([dic[@"evaluation"] isEqualToString:@"false"]) {
            
            MyGoodsModel *model = [[MyGoodsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            if (_goodsIDStr.length == 0) {
                
                _goodsIDStr = [model.goods_id stringValue];
            }
            else {
                
                _goodsIDStr = [NSString stringWithFormat:@"%@,%@",_goodsIDStr,[model.goods_id stringValue]];
            }
        }
    }

    [self initScoreView];
}

- (void)setNav {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
    self.navigationItem.titleView = [Utillity customNavToTitle:@"商品评价"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
}

- (void)initScoreView {

    ScoreView *scoreView = [[ScoreView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    scoreView.model = _orderModel;
    [scoreView refreshTableView];
    [self.view addSubview:scoreView];
    
    scoreView.evaluationBlock = ^(NSString *contextString,NSString *scoreString,NSString *isAnonymous) {
        [self addProductReviewWithContext:contextString score:scoreString isAnonymous:isAnonymous];
    };
    
    [scoreView setSelectImg:^(NSInteger type) {
        [self getImageFromIpcWithType:type];
    }];
    
    [scoreView setSetImage:^(NSArray *imgArray) {
        self.goodsImageArray = imgArray;
    }];
}

- (void)back {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  添加评论
 *
 *  @param contextString 内容
 *  @param scoreString   评分
 *  @param isAnonymous   是否匿名
 */
- (void)addProductReviewWithContext:(NSString *)contextString
                              score:(NSString *)scoreString
                        isAnonymous:(NSString *)isAnonymous
{
    if (isBlankString(contextString)) {
        return [Tools myHud:@"请输入您的评价"];
    }
    
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    NSString *reviewType = _orderModel.List.count == 1 ? @"1" : @"0";
    NSDictionary *strJsons = @{@"orderId":[NSString stringWithFormat:@"%@",_orderModel.Id],
                               @"ProductId":_goodsIDStr,
                               @"IsShow":isAnonymous,
                               @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"],
                               @"level":scoreString,
                               @"Context":contextString,
                               @"reviewType":reviewType};

    NSString *urlString = [NSString stringWithFormat:PUBLISHCOMMENT,[Utillity DataTOjsonString:strJsons]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (self.goodsImageArray.count > 0) {
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.goodsImageArray[0], 0.1)
                                        name:@"image"
                                    fileName:@"image.jpeg"
                                    mimeType:@"image/jpeg"];
            
            for (int i = 1; i < self.goodsImageArray.count; i++) {
                
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.goodsImageArray[i], 0.1)
                                            name:[NSString stringWithFormat:@"image%zd",i]
                                        fileName:@"imgge.jpeg"
                                        mimeType:@"image/jpeg"];
            }
        }

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        if ([responseObject[@"issuccess"] boolValue]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [Tools myHud:responseObject[@"context"] inView:self.view];
        [hud hide:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
    }];
}

- (void)getImageFromIpcWithType:(NSInteger)type {
    
    if (self.goodsImageArray.count > 5) {
        return [Tools myHud:@"最多只能添加五张图片"];
    }
    
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    // 2. 创建图片选择控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.allowsEditing = NO;
    
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    
    // 设置打开照片相册类型(显示所有相簿)
    if (type == 1) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 设置代理
    imagePickerController.delegate = self;
    
    // modal出这个控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetImage" object:info[UIImagePickerControllerOriginalImage]];
}

@end
