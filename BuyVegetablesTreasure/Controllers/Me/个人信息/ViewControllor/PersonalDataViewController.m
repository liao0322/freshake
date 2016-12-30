//
//  PersonalDataViewController.m
//  BuyVegetablesTreasure
//
//  Created by sc on 15/10/30.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "IconInfoCell.h"
#import "SexOrBirthdayView.h"
#import "DateScrollView.h"

@interface PersonalDataViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>{
    
    SexOrBirthdayView *sexView;
    SexOrBirthdayView *birthDayView;
    SexOrBirthdayView *headView;
    DateScrollView *dateScrollView;
    UITextField *nametext;
    
    NSString *_nameString;
    NSString *_sexString;
    NSString *_dateString;
    //储存图片
    NSData *imageData;
}
@end

@implementation PersonalDataViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imageData=[NSData data];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageData=[NSData data];

    //self.navigationItem.titleView = [Utillity customNavToTitle:@"个人信息"];
    self.title = @"个人信息";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xf5f6f8"];
    self.navigationItem.leftBarButtonItem = [UIFactory createBackBBIWithTarget:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserName)];
    
    
    _nameString = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick_name"];
    _sexString=[[NSUserDefaults standardUserDefaults]objectForKey:@"sex"];
    _dateString=[[NSUserDefaults standardUserDefaults]objectForKey:@"birthday"];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[IconInfoCell class] forCellReuseIdentifier:@"MeUITTableViewCell"];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else {
        
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        IconInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MeUITTableViewCell"];
        [cell setDataSource];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pushLogin = ^() {
            [self editHeadImageView];
        };
        return cell;
    }
    
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NickCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NickCell"];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag:60] == nil) {
            nametext = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 15, 140, 20)];
            nametext.textAlignment = NSTextAlignmentRight;
            nametext.delegate = self;
            nametext.font = [UIFont systemFontOfSize:15.0];
            nametext.textColor = [UIColor colorWithHexString:@"0x999999"];
            nametext.tag = 60;
            
            [cell addSubview:nametext];

        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"昵称";
        UITextField *text = (UITextField *)[cell viewWithTag:60];
        text.text = _nameString == nil ? @"鲜摇派" : _nameString;
        return cell;
    }
    
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
        }
        

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag:80] == nil || [cell viewWithTag:70] == nil ) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 180, 15, 140, 20)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor colorWithHexString:@"0x999999"];
            label.tag = indexPath.row == 0 ? 70 : 80;
            
            [cell addSubview:label];
            
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"0xD9D9D9"];
            if (indexPath.row == 0) {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
                line.backgroundColor = [UIColor colorWithHexString:@"0xD9D9D9"];
                [cell addSubview:line];
            }
            
            [cell addSubview:line];
        }
       
        
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
            UILabel *label = ( UILabel * )[cell viewWithTag:70];
            label.text = _sexString==nil ? @"男" : _sexString;
        }
        
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"生日";
            UILabel *label = ( UILabel * )[cell viewWithTag:80];
            label.text = _dateString == nil ? @"1990-01-01" : _dateString;

        }
        
        return cell;
        
    }
}

- (void)editHeadImageView{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
       
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger sourceType = 0;
        sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction *confirm2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger sourceType = 0;
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    [alertVC addAction:cancle];
    [alertVC addAction:confirm];
    [alertVC addAction:confirm2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
//    if (headView == nil) {
//        headView = [[NSBundle mainBundle] loadNibNamed:@"SexOrBirthdayView" owner:self options:nil][0];
//        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//        [self.view addSubview:headView];
//    }
//    else {
//        headView.hidden = NO;
//    }
//    __weak typeof(self)weakSelf = self;
//    __weak typeof(headView)weakheadView = headView;
//    headView.nameBlock=^(NSString *nameStr){
//        NSLog(@"===昵称==%@",nameStr);
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [ defaults setObject:nameStr forKey:@"nick_name"];
//        [ defaults synchronize];
//        //更新昵称
//        [weakSelf requestDataFromNetKey:@"nick_name" Value:[nameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        weakheadView.tf.placeholder=[defaults objectForKey:@"nick_name"];
//        
//        [weakSelf.tableView reloadData];
//    };
//    
//    headView.photoOrCameraBlock=^(NSInteger viewtag){
//        NSUInteger sourceType = 0;
//        if (viewtag==100) {
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }else{
//            sourceType = UIImagePickerControllerSourceTypeCamera;
//        }
//        weakheadView.hidden=YES;
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.sourceType = sourceType;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.delegate = weakSelf;
//        [weakSelf presentViewController:imagePickerController animated:YES completion:^{}];
//    };
    dateScrollView.hidden = YES;
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - 保存更新用户昵称
- (void)saveUserName {
    [nametext resignFirstResponder];
    _nameString = nametext.text;
    
    NSLog(@"====昵称====%@",_nameString);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_nameString forKey:@"nick_name"];
    [defaults synchronize];
    
    // 更新昵称
    [self requestDataFromNetKey:@"nick_name" Value:[_nameString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    nametext.placeholder = [defaults objectForKey:@"nick_name"];
    
    [self.tableView reloadData];

}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    [self.tableView reloadData];
    [self requestDataFromNetUserFace];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dateScrollView.hidden = YES;
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            if (sexView == nil) {
                sexView = [[NSBundle mainBundle] loadNibNamed:@"SexOrBirthdayView" owner:self options:nil][1];
                sexView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
                [self.view addSubview:sexView];
            }
            else {
                sexView.hidden = NO;
            }
            
            __weak typeof(self)weakSelf = self;
            sexView.sexBlock = ^(NSString *sexString){
                _sexString = sexString;
                [ [NSUserDefaults standardUserDefaults] setObject:sexString forKey:@"sex"];
                [ [NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf.tableView reloadData];
                //更新性别
                [weakSelf requestDataFromNetKey:@"sex" Value:[sexString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            };

        }
        else if (indexPath.row == 1) {
            if (dateScrollView == nil) {
                
                dateScrollView = [[DateScrollView alloc] init];
                dateScrollView.frame = CGRectMake(0, SCREEN_HEIGHT - 160 - 64, SCREEN_WIDTH, 160);
                dateScrollView.backgroundColor = [UIColor whiteColor];
                
                __weak typeof(self)weakSelf = self;
                dateScrollView.dateBlock = ^(NSString *dateString){
                    _dateString = dateString;
                    [ [NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"birthday"];
                    [ [NSUserDefaults standardUserDefaults] synchronize];
                    //更新生日
                    [weakSelf requestDataFromNetKey:@"birthday" Value:dateString];
                    [weakSelf.tableView reloadData];
                };
                
                [self.view addSubview:dateScrollView];

                   }
    
            else {
                
                dateScrollView.hidden = NO;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 190;
    }else
    return 50;
}
#pragma mark 上传个人信息
-(void)requestDataFromNetKey:(NSString *)key Value:(NSString *)value
{
    NSString *urlString = [NSString stringWithFormat:UPDATEUSER,[[NSUserDefaults standardUserDefaults]objectForKey:@"UID"],key,value];
    [HttpRequest sendGetOrPostRequest:urlString param:nil requestStyle:Get setSerializer:Date isShowLoading:YES success:^(id data)
     {
   
     } failure:nil];
}

#pragma mark 上传用户头像
-(void)requestDataFromNetUserFace {
    
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.labelText = @"加载中...";
    [hud show:YES];
    
    
    
    if (imageData) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*"]];
        
        NSDictionary *parameters = @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UID"]};
        
        [manager POST:UPDATEUSERIMAGE parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
        {
            NSLog(@"^^^^^^^^^%@********", formData);

            [formData appendPartWithFileData:imageData name:@"img" fileName:@"img.png" mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if (responseObject[@"order_no"] && ![responseObject[@"order_no"] isEqualToString:@""]) {

                // 保存用户头像
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"order_no"] forKey:@"avatar"];
                [[NSUserDefaults standardUserDefaults] synchronize];
               // _changeImage();
            }
            
            [self.tableView reloadData];
            [Tools myHud:@"修改成功" inView:self.view];
            
            [hud hide:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [Tools myHud:@"修改失败" inView:self.view];
            [hud hide:YES];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [nametext resignFirstResponder];
   }
@end
