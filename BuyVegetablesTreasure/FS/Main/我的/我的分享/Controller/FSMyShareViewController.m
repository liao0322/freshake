//
//  FSMyShareViewController.m
//  BuyVegetablesTreasure
//
//  Created by 江玉元 on 2017/4/11.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyShareViewController.h"
#import "FSMyShareCollectionViewCell.h"
#import "FSMyShareModel.h"
#import <MJExtension.h>
#import <UShareUI/UShareUI.h>

@interface FSMyShareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) NSString *uidString;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UIImage *iconImage;

@end

@implementation FSMyShareViewController

static NSString * const MyShareCollectionCellID = @"MyShareCollectionCellID";

static NSInteger const cols = 3;
static CGFloat const margin = 2.5;
#define itemW ((SCREEN_WIDTH - 10) - (cols - 1) * margin) / cols
#define itemH 175


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDataFromNet];
}

- (void)initialize {
    [super initialize];
    self.title = @"我的分享";
    self.view.backgroundColor = [UIColor colorViewBG];
}

- (void)setupViews {
    [super setupViews];
    [self.view addSubview:self.collectionView];
}

- (void)registerViews {
    [super registerViews];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSMyShareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:MyShareCollectionCellID];
}

- (void)requestDataFromNet {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.uidString = [userDefaults objectForKey:@"UID"];
    
    NSString *urlString = [NSString stringWithFormat:GetProShareImg,self.uidString];

    [XFNetworking GET:urlString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!dicArray.count) {
            return;
        }
        
        NSMutableArray *dataArr = [FSMyShareModel mj_objectArrayWithKeyValuesArray:dicArray];
        if (!dataArr.count) {
            return;
        }
        
        self.dataArray = dataArr;
        NSLog(@"%@", self.dataArray);
        [self.collectionView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showInfoWidthError:error];

    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSMyShareModel *model = self.dataArray[indexPath.row];
    FSMyShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyShareCollectionCellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FSMyShareModel *model = self.dataArray[indexPath.row];
    
    /// 弹出大图 视图
        // 1.在view上添加tableView
        // 2.tableViewcell设置与tableView的frame 同等大小
        // 3.tableView的pagingEnabled打开
    UIViewController *vc = [UIViewController new];
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:^{
        vc.view.backgroundColor = [UIColor clearColor];
        vc.view.alpha = 0.3f;
    }];
    

    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:model.productImg_url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.iconImage = image;
    }];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_Qzone)]];
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        messageObject.text = @"我在测试";
        
        //创建图片内容对象
        UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
        
        [imageObject setShareImage:self.iconImage];
        
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
}



#pragma mark - LazyLoad

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, SCREEN_HEIGHT - 5) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorViewBG];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        _flowLayout.minimumInteritemSpacing = margin;
        _flowLayout.minimumLineSpacing = margin;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
