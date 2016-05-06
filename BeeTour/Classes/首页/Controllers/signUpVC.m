//
//  signUpVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/18.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "signUpVC.h"
#import "signUpCell.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <ProgressHUD.h>
#import "mainVC.h"
#import "roleVC.h"
#import "loginInVC.h"
@interface signUpVC ()
{
    BOOL _isChoose;
}
@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmLable;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@end

@implementation signUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    [_myTableView registerNib:[UINib nibWithNibName:@"signUpCell" bundle:nil] forCellReuseIdentifier:@"signUpCell"];
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _isChoose  = NO;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(down)];
    [self.view addGestureRecognizer:tap];
}
-(void)down
{
    [self.view endEditing:YES];
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---------- 注册
- (IBAction)signUpAction:(id)sender {
    
    
    if(_telTF.text.length == 0){
        [ProgressHUD showError:@"Email or User name can not empty" Interaction:YES];
        return;
    }else if(_passwordTF.text.length == 0){
        
    [ProgressHUD showError:@"Password can not empty" Interaction:YES];
        return;
    }else if(_confirmLable.text.length == 0){
    
    [ProgressHUD showError:@"Please Confirm Password" Interaction:YES];
        return;
    }if(_isChoose == YES){
        
      
         [ProgressHUD showError:@"You do not agree to the Conditions" Interaction:YES];
        return;
    }
    else{
    
    
    // 邮箱注册
    if([Helper justEmail:_telTF.text]){
          NJLog(@"%@,%@",_passwordTF.text,_confirmLable.text);
        if([_passwordTF.text isEqualToString: _confirmLable.text]){
          
        // 密码两次输入一样
            NSDictionary *parameters = @{
                                    
                                         @"userEml": _telTF.text,
                                        @"lgnPwd":_passwordTF.text,
                                         @"userType": @0,
                                      
                                         @"regGnl": @1


                                         };
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            //    int a = 1;
            [manager POST: signUpEmailUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                //
                NJLog(@"测试注册成功------%@",responseObject);
                
                NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
                [myDefault setObject:@"已登录" forKey:@"登录状态"];
                [myDefault setObject:_telTF.text forKey:@"用户名"];
                NJLog(@"沙盒路径%@",NSHomeDirectory());
                [ProgressHUD show:@"Please wait"];
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"SIGN UP SUCCESS" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [ProgressHUD dismiss];
                    mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
                    [self presentViewController:main animated:YES completion:nil];
                }];
                
                // 添加操作
                [alertDialog addAction:okAction];
                [self presentViewController:alertDialog animated:YES completion:nil];
                
                //
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                //
                NJLog(@"测试注册失败-----%@",error);
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"E-Mail is exist" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // 操作具体内容
                    // Nothing to do.
                }];
                
                // 添加操作
                [alertDialog addAction:okAction];
                [self presentViewController:alertDialog animated:YES completion:nil];
                return ;
                
                //
            }];
        
        }else{
        // 密码两次输入不一样
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"password is different,please check again" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 操作具体内容
                // Nothing to do.
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
            return;
        }
        
    }
    // 用户名
    else{
        //用户名注册
        
        
        // 用户名不允许存在 @":"
        if([_telTF.text rangeOfString:@":"].location == NSNotFound){
        
    if([_passwordTF.text isEqualToString: _confirmLable.text]){
        NSDictionary *parameters = @{
                                     @"userName": _telTF.text,
                                    
                                     @"lgnPwd":_passwordTF.text,
                                  
                                     @"userType": @0,
                                   
                                     @"regGnl": @1
                                                                        };
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        //    int a = 1;
        [manager POST: signUpNameUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //
            NJLog(@"测试注册成功------%@",responseObject);
            
            NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
            [myDefault setObject:@"已登录" forKey:@"登录状态"];
            [myDefault setObject:_telTF.text forKey:@"用户名"];
            NJLog(@"沙盒路径%@",NSHomeDirectory());
            [ProgressHUD show:@"Please wait"];
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"SIGN UP SUCCESS" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [ProgressHUD dismiss];
                mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
                [self presentViewController:main animated:YES completion:nil];
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
            
            //
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            //
            
            NJLog(@"测试注册失败-----%@",error);
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Email Address already in use" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 操作具体内容
                // Nothing to do.
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
            return ;
            
            //
        }];
    
    }else{
        // 密码两次输入不一样
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"password is different,please check again" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
        }];
        
        // 添加操作
        [alertDialog addAction:okAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        return;
    }

    
        }else{
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"user name should not exist ':' " message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 操作具体内容
                // Nothing to do.
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
            return;
        
        }
        
        
    }
   
    
    
   
    }

    
}
- (IBAction)readRoleAction:(id)sender {
    roleVC *role = [[roleVC alloc] initWithNibName:@"roleVC" bundle:nil];
    [self presentViewController:role animated:YES completion:nil];
}
#pragma mark -------点击同意条约
- (IBAction)signinAction:(id)sender {
    
    loginInVC *login = [[loginInVC alloc] initWithNibName:@"loginInVC" bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
}
- (IBAction)chooseRoleAction:(id)sender {
    _isChoose =! _isChoose;
     NJLog(@"%@",_isChoose?@"yes":@"no");
    if(_isChoose){
    
        [_chooseButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    
    }else{
     [_chooseButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
    
    }
    
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
