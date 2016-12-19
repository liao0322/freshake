//
//  SexOrBirthdayView.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/11/2.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "SexOrBirthdayView.h"

@implementation SexOrBirthdayView


- (void)awakeFromNib
{
    _RectY=_editFaceView.frame.origin.y;
    _photoView.tag=100;
    _cameraView.tag=200;
//    UITapGestureRecognizer *_tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch:)];
//    [_photoView addGestureRecognizer:_tap1];
//    UITapGestureRecognizer *_tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch:)];
//    [_cameraView addGestureRecognizer:_tap2];
    _tf.delegate=self;
    
    [_CameraBtn setBackgroundImage:IMAGE(@"绑定按钮框") forState:UIControlStateHighlighted];
    [_ptotoBtn setBackgroundImage:IMAGE(@"绑定按钮框") forState:UIControlStateHighlighted];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"nick_name"]) {
        _tf.placeholder=[[NSUserDefaults standardUserDefaults] objectForKey:@"nick_name"];
        
    }
}
-(void)tapTouch:(UITapGestureRecognizer *)sender{
    _photoOrCameraBlock(sender.view.tag);
}


// 触摸屏幕进行隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tf resignFirstResponder];
    self.hidden = YES;
     _tf.text=@"";
}


- (IBAction)CameraBtn:(UIButton *)sender {
    _photoOrCameraBlock(sender.tag);

}
- (IBAction)photoBtn:(UIButton *)sender {
    _photoOrCameraBlock(sender.tag);
   
    
}
// 点击取消隐藏视图
- (IBAction)off:(id)sender {
    self.hidden = YES;
    [_tf resignFirstResponder];
    _tf.text=@"";
}

- (IBAction)ok:(id)sender {
    self.hidden=YES;
    [_tf resignFirstResponder];
    if (_tf.text.length!=0) {
      _nameBlock(_tf.text);
    } 
     _tf.text=@"";
}

// 选择性别
- (IBAction)selectSex:(UIButton *)sender{
    _sexBlock(sender.tag == 10 ? @"男" : @"女");
    self.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect rect = _editFaceView.frame;
    rect.origin.y =SCREEN_HEIGHT-keyboardRect.size.height-rect.size.height-60;
    _editFaceView.frame=rect;
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect rect = _editFaceView.frame;
    rect.origin.y =_RectY;
    _editFaceView.frame=rect;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
