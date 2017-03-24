//
//  FSMyQRCodeViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/3/24.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSMyQRCodeViewController.h"
#import "NSString+Extension.h"

@interface FSMyQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FSMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)requestData {
    [super requestData];
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareUrl"];
    if (!urlString) {
        return;
    }
    
    urlString = [[urlString clearAllSpace] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    [self.imageView sd_setImageWithURL:URL];
    
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
