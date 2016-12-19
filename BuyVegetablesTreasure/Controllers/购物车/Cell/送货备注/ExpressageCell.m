//
//  ExpressageCell.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/15.
//  Copyright (c) 2015年 c521xiong. All rights reserved.
//

#import "ExpressageCell.h"

@implementation ExpressageCell

- (void)awakeFromNib {
    [_nameText addTarget:self action:@selector(wordDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_mobile addTarget:self action:@selector(wordDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_remarkText addTarget:self action:@selector(wordDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setData:(UserModel *)model
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _nameText.text = model.username;
    _mobile.text = model.tel;
    
    [userDefaults setObject:_nameText.text forKey:@"userName"];
    [userDefaults setObject:_mobile.text forKey:@"userTel"];
    
    [_nameText addTarget:self action:@selector(wordDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_mobile addTarget:self action:@selector(wordDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)wordDidChange:(UITextField *)textField {
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (textField == (UITextField *)[self viewWithTag:1000]) {
        
        [userDefaults setObject:textField.text forKey:@"userName"];
    }
    else if (textField.tag == 1100) {
        
        [userDefaults setObject:textField.text forKey:@"userRemark"];
    }
    else {
        
        [userDefaults setObject:textField.text forKey:@"userTel"];
    }
    
    _editTextField();
}

- (IBAction)goPayment:(id)sender
{
    NSArray *arr;
    _goPayment(arr);
}

@end
