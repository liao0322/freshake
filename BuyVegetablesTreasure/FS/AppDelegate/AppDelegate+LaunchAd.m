//
//  AppDelegate+LaunchAd.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/15.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "AppDelegate+LaunchAd.h"
#import "FSRequestAppDelegate.h"
#import "FSAdModel.h"
#import "XFKVCPersistence.h"
#import "JDFile.h"
//#import <MJExtension.h>

@implementation AppDelegate (LaunchAd)

- (void)requestLunachAd {
    
    [FSRequestAppDelegate adListWithTypeId:@"0" success:^(FSAdModel *adModel) {
        
        NSString *imageName = [adModel.imgUrl componentsSeparatedByString:@"/"].lastObject;
        NSString *filePath = [self filePathWithImageName:imageName];
        BOOL isExist = [JDFile isFileExist:filePath];
        if (!isExist) {
            [XFKVCPersistence setValue:adModel.eventTypeId forKey:KEY_EVENT_TYPE_ID];
            [XFKVCPersistence setValue:adModel.eventId forKey:KEY_EVENT_ID];
            [self downloadImageWithUrl:adModel.imgUrl imageName:imageName];
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];

}


- (void)downloadImageWithUrl:(NSString *)urlString
                   imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self filePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            [self deleteOldImage];
            [XFKVCPersistence setValue:imageName forKey:KEY_AD_IMAGE_NAME];
            
        } else {
            NSLog(@"保存启动图片失败");
        }
        
    });
}

- (NSString *)filePathWithImageName:(NSString *)imageName {
    NSString *filePath = nil;
    if (imageName) {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        filePath = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:imageName];
    }
    return filePath;
}

- (void)deleteOldImage {
    NSString *imageName = [XFKVCPersistence get:KEY_AD_IMAGE_NAME];
    if (imageName) {
        NSString *filePath = [self filePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
@end
