//
//  changePasswordVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/22.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "changePasswordVC.h"
@interface changePasswordVC ()
{
    NSString *_userID;
}
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@end

@implementation changePasswordVC
-(void)viewWillAppear:(BOOL)animated
{
    if([Common isSignIn]){
    
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        _userID = [myDefault objectForKey:@"userId"];
    }else{
    
        [ProgressHUD showError:@"Not logged in" Interaction:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneAction:(id)sender {
    
    
    if(_passwordTF.text.length == 0){
    
     [ProgressHUD showError:@"passwordIsNull" Interaction:YES];
        return;
    }else if(_confirmPasswordTF.text.length == 0){
    
    [ProgressHUD showError:@"confirmpasswordIsNull" Interaction:YES];
        return;
    }else if(_passwordTF.text != _confirmPasswordTF.text){
    
        [ProgressHUD showError:@"passworddifferent please check again" Interaction:YES];
        return;
    }else{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"%@?id=%@&passwd=%@",changePasswordUrl,_userID,_passwordTF.text] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
        
            [ProgressHUD showSuccess:@"change success,please sign out then sign in again " Interaction:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
         [ProgressHUD showSuccess:@"change failed " Interaction:YES];
        
    }];
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
