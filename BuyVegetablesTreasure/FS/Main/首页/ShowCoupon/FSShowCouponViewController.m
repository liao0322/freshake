//
//  FSShowCouponViewController.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2017/4/5.
//  Copyright © 2017年 c521xiong. All rights reserved.
//

#import "FSShowCouponViewController.h"

@interface FSShowCouponViewController ()

@end

@implementation FSShowCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)mainViewTapped:(id)sender {
    NSLog(@"a");
}
- (IBAction)aaa:(id)sender {
    NSLog(@"a");
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
