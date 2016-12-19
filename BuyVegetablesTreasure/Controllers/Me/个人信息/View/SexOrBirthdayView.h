//
//  SexOrBirthdayView.h
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/2.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexOrBirthdayView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *editFaceView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (nonatomic, copy) void(^sexBlock)(NSString *sexString);
@property (nonatomic, copy) void(^nameBlock)(NSString *nameString);
@property (nonatomic, copy) void(^photoOrCameraBlock)(NSInteger viewTag);

- (IBAction)photoBtn:(UIButton *)sender;
- (IBAction)CameraBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *ptotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *CameraBtn;
@property(nonatomic,assign)CGFloat RectY;


- (IBAction)off:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)selectSex:(UIButton *)sender;

@end
