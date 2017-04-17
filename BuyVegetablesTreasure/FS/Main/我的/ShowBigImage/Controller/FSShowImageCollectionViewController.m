//
//  FSShowImageCollectionViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/17.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowImageCollectionViewController.h"
#import "FSShowImageCVCell.h"
#import "FSMyShareModel.h"
#import <UShareUI/UShareUI.h>

@interface FSShowImageCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) FSMyShareModel *shareModel;
@end

@implementation FSShowImageCollectionViewController

static NSString * const FSShowImageCVCellID = @"FSShowImageCVCellID";

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setupViews {
    [super setupViews];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
}

- (void)registerViews {
    [super registerViews];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSShowImageCVCell class]) bundle:nil] forCellWithReuseIdentifier:FSShowImageCVCellID];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.shareModel = self.imageDataArray[self.ImageRow];
    FSShowImageCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSShowImageCVCellID forIndexPath:indexPath];
    cell.model = _shareModel;
    cell.ToShareBlock = ^{
        [self UMSocialShare];
    };
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 友盟图片分享
- (void)UMSocialShare {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_Qzone)]];
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:_shareModel.productImg_url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        // 显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            messageObject.text = @"我在测试";
            
            //创建图片内容对象
            UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
            
            [imageObject setShareImage:image];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = imageObject;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                //            [self alertWithError:error];
            }];
            
        }];
        
        
    }];

}

- (void)setImageDataArray:(NSMutableArray *)imageDataArray {
    _imageDataArray = imageDataArray;
    [self.collectionView reloadData];
}
@end
