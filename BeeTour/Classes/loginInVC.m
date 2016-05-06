//
//  loginInVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/17.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//
// 登录
#import "loginInVC.h"
#import <UMSocial.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ProgressHUD/ProgressHUD.h>
#import "mainVC.h"
#import "signUpVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
@interface loginInVC ()<UITextFieldDelegate,UMSocialUIDelegate>
{
    NSString *_userNum; // 账号
    NSString *_userPassward; // 密码
    NSString *_thirdPartyUserID; // 第三方登录用户ID
}

@property (weak, nonatomic) IBOutlet UITextField *phoneOrNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwardTF;
@end

@implementation loginInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [_myTableView registerNib:[UINib nibWithNibName:@"loginCell" bundle:nil] forCellReuseIdentifier:@"loginCell"];
//    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --------去注册页面
- (IBAction)GoToSignUpAction:(id)sender {
    signUpVC *signUp = [[signUpVC alloc] initWithNibName:@"signUpVC" bundle:nil];
    [self presentViewController:signUp animated:YES completion:nil];
}
#pragma mark --------登录
- (IBAction)signInAction:(id)sender {
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    if(_phoneOrNumTF.text.length ==0 ){
        [ProgressHUD showError:@"Email or User name can not empty" Interaction:YES];
        return;
    }else if(_passwardTF.text.length == 0){
    
        [ProgressHUD showError:@"Password can not empty" Interaction:YES];
        return;
    }else{
        [ProgressHUD show:@"wating"];
        [manager POST: signInUrl parameters:@{@"userName":_phoneOrNumTF.text,@"passWord":_passwardTF.text}success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [ProgressHUD dismiss];
            NJLog(@"测试登录成功------%@",responseObject);
            NSDictionary *dic = responseObject;
            
            // 登录返回SUCCESS
            if(dic[@"success"]){
                NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
                [myDefaults setObject:@"已登录" forKey:@"登录状态"];
                [myDefaults setObject:_phoneOrNumTF.text forKey:@"用户名"];
                [myDefaults synchronize];
                NJLog(@"沙盒路径-------%@",NSHomeDirectory());
                //       [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"登录成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    //            mainVC *main =[[NSBundle mainBundle] loadNibNamed:@"mainVC" owner:self options:nil].lastObject;
                    mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
                    [self presentViewController:main animated:YES completion:nil];
                    NJLog(@"123");
                }];
                
                // 添加操作
                [alertDialog addAction:okAction];
                
                
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
            }else{
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"SIGNIN FAILED" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // 操作具体内容
                    // Nothing to do.
                }];
                
                // 添加操作
                [alertDialog addAction:okAction];
                [self presentViewController:alertDialog animated:YES completion:nil];
                
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [ProgressHUD dismiss];
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"login failed" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 操作具体内容
                // Nothing to do.
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
          
            
        }];
    
    }
    
    
}
/**
 *  第三方登录
 *
 *  @return
 */
#pragma mark ------------ Twitter登录
- (IBAction)twitterLoginAction:(id)sender {
    
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeTwitter
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NJLog(@"dd%@",user.rawData);
                                       NJLog(@"dd%@",user.credential.uid);
                                       _thirdPartyUserID = user.uid;
                                       NJLog(@"获得的twitter的用户id---%@",_thirdPartyUserID);
                                       
                                       _thirdPartyUserID = [NSString stringWithFormat:@"tw_id:%@",_thirdPartyUserID];
                                       
                                       [self signInWithThirdParty];
                                       NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
                                         [myDefault setObject:_thirdPartyUserID forKey:@"userId"];
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                      
                                    }else{
                                        NSLog(@"Twitter登录错误----%@",error);
                                    }
                                }];


}
#pragma mark ------------ FaceBook登录
- (IBAction)faceBookLoginAction:(id)sender {
   
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeFacebook
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NJLog(@"dd%@",user.uid);
//                                       NJLog(@"dd---%@",user.credential);
                                   
                                       _thirdPartyUserID = user.uid;
                                       
                                       _thirdPartyUserID = [NSString stringWithFormat:@"fb_id:%@",_thirdPartyUserID];
                                       
                                        [self signInWithThirdParty];
                                       NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
                                         [myDefault setObject:_thirdPartyUserID forKey:@"userId"];
//
                                       
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                        
                                    }else{
                                    NSLog(@"登录错误----%@",error);
                                    }
                                }];
    
}
#pragma mark ------------ LINKEDIN登录
- (IBAction)linkerInLoginAction:(id)sender {
    
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeLinkedIn
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       _thirdPartyUserID = user.uid;
                                       NJLog(@"获得的twitter的用户id---%@",_thirdPartyUserID);
                                       
                                       _thirdPartyUserID = [NSString stringWithFormat:@"in_id:%@",_thirdPartyUserID];
                                       
                                       [self signInWithThirdParty];
                                       NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
                                       [myDefault setObject:_thirdPartyUserID forKey:@"userId"];
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }else{
                                        NSLog(@"Twitter登录错误----%@",error);
                                    }
                                }];
    
    
}
/**
 *  第三方登录转注册或者登录
 *
 *  @return
 */
#pragma mark --------- 第三方登录转注册或者登录
-(void)signInWithThirdParty
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NJLog(@"获得fbid------%@",_thirdPartyUserID);
    
//    NSString *thirdUserName = [NSString stringWithFormat:@"fb_id:%@",_thirdPartyUserID];
    
    NSDictionary *parameters = @{
                                 @"userName": _thirdPartyUserID,
                                 @"lgnPwd": @"password",
                                 @"userType": @0,
                                 @"regGnl": @1
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager POST: signUpNameUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NJLog(@"测试注册成功------%@",responseObject);
        
        
      
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        [myDefault setObject:@"已登录" forKey:@"登录状态"];
       [myDefault setObject:dic[@"data"][@"newUserId"] forKey:@"userId"];
        [myDefault setObject:_thirdPartyUserID forKey:@"用户名"];

        NJLog(@"沙盒路径%@",NSHomeDirectory());
        [ProgressHUD show:@"Please wait"];
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"SIGN IN SUCCESS" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [ProgressHUD dismiss];
            mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
            [self presentViewController:main animated:YES completion:nil];
        }];
        
        // 添加操作
        [alertDialog addAction:okAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        }else{
        
            NJLog(@"第三方登录注册失败----");
        }
        //
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
      
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         AFHTTPRequestOperationManager *managerSignIn = [AFHTTPRequestOperationManager manager];
        
//        NSString *ytstUserNameStr = [NSString stringWithFormat:@"fb_id:%@",_thirdPartyUserID];
        [managerSignIn POST:thirdSignInUrl parameters:@{@"ytstUserName":_thirdPartyUserID} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            NJLog(@"登录成功");
           
            
            NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
            [myDefaults setObject:@"已登录" forKey:@"登录状态"];
            [myDefaults setObject:_thirdPartyUserID forKey:@"用户名"];
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"sign in success" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
                [self presentViewController:main animated:YES completion:nil];
                NJLog(@"123");
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            
            
            // 呈现警告视图
            [self presentViewController:alertDialog animated:YES completion:nil];
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            NJLog(@"登录失败");
            
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"SIGNIN FAILED" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 操作具体内容
                // Nothing to do.
            }];
            
            // 添加操作
            [alertDialog addAction:okAction];
            [self presentViewController:alertDialog animated:YES completion:nil];
        }];

    }];
}


//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
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
