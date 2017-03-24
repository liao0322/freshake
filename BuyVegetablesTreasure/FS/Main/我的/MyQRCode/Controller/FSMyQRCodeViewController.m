//
//  FSMyQRCodeViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyQRCodeViewController.h"

@interface FSMyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FSMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)requestData {
    [super requestData];
    
    NSString *urlString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shareUrl"] stringValue];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    //NSString *filePath = [self filePathWithImageName:imageName];
    
    /*
    if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
        [self deleteOldImage];

        
    } else {
        NSLog(@"保存启动图片失败");
    }
     */
    
}


- (void)initialize {
    [super initialize];
    self.title = @"我的二维码";
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
