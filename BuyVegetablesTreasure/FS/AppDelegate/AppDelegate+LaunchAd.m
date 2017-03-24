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

        NSString *newImgUrl = [NSString stringWithFormat:@"%@%@", adModel.imgUrl, [self imageSizeSuffixString]];
        
        // 拼接图片名字
        NSString *imageName = [newImgUrl componentsSeparatedByString:@"/"].lastObject;
        NSString *filePath = [self filePathWithImageName:imageName];
        
        BOOL isExist = [JDFile isFileExist:filePath];
        if (!isExist) { // 不存在
            [self downloadImageWithUrl:newImgUrl imageName:imageName adModel:adModel];
        } else {
            BOOL usable = [adModel.usable boolValue];
            if (!usable) {
                [self deleteOldImage];
                [XFKVCPersistence remove:KEY_EVENT_TYPE_ID];
                [XFKVCPersistence remove:KEY_EVENT_ID];
                [XFKVCPersistence remove:KEY_AD_IMAGE_NAME];
                [XFKVCPersistence remove:KEY_AD_END_TIME];
            }
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];

}

- (void)downloadImageWithUrl:(NSString *)urlString
                   imageName:(NSString *)imageName
                     adModel:(FSAdModel *)adModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *URL = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self filePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            [self deleteOldImage];
            [XFKVCPersistence setValue:imageName forKey:KEY_AD_IMAGE_NAME];
            [XFKVCPersistence setValue:adModel.eventTypeId forKey:KEY_EVENT_TYPE_ID];
            [XFKVCPersistence setValue:adModel.eventId forKey:KEY_EVENT_ID];
            [XFKVCPersistence setValue:adModel.endTime forKey:KEY_AD_END_TIME];
            
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

- (NSString *)imageSizeSuffixString {
    NSString *str = nil;
    if (SCREEN_WIDTH == 320.0f) {
        str = @"_640x1136.jpg";
    } else if (SCREEN_WIDTH == 375.0f) {
        str = @"_750x1334.jpg";
    } else if (SCREEN_WIDTH == 414.0f) {
        str = @"_1242x2208.jpg";
    }
    return str;
}
@end
