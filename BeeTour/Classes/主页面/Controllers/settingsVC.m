//
//  settingsVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/5.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "settingsVC.h"
#import "myOrderCell.h"
#import <ProgressHUD.h>
#import "changePasswordVC.h"
#import "aboutUsVc.h"
@interface settingsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_leftArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@end

@implementation settingsVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
      _leftArr = [[NSArray alloc] init];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_myTableView registerNib:[UINib nibWithNibName:@"myOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
    _leftArr = @[@"Change Password",@"",@"About us"];
    
    if([Common isSignIn]){
        
        _bottomButton.hidden = NO;
//    [_bottomButton setTitle:@"SIGN OUT" forState:UIControlStateNormal];
    
    }else{
    
        _bottomButton.hidden = YES;
    }
    
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------- <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
    
        static NSString *reusedID=@"reusedID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
        if(!cell)/////cell==nil
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
            
            
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
    
    
    myOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myOrderCell"];
        cell.contentLable.hidden  = YES;
        cell.titleLable.text = _leftArr[indexPath.row];
    return cell;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
        return 20.0f;
    }else{
        return 44.0f;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
        if([Common isSignIn]){
        changePasswordVC *changeVC = [[changePasswordVC alloc] initWithNibName:@"changePasswordVC" bundle:nil];
        [self presentViewController:changeVC animated:YES completion:nil];
    
        }else{
        
            [ProgressHUD showError:@"Not logged in" Interaction:YES];
            
        }
    }else if (indexPath.row == 2){
        aboutUsVc *about = [[aboutUsVc alloc] initWithNibName:@"aboutUsVc" bundle:nil];
        [self presentViewController:about animated:YES completion:nil];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -------- 注销登录
- (IBAction)SignUpAction:(id)sender {
    
    
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
       
       UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"确定退出登录?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          
           NJLog(@"123");
           NSInteger userID = [Common getUserSpecialID].integerValue;
           [manager POST:[NSString stringWithFormat:@"%@?userId=%ld",SIGNUPUrl,userID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              
               
               
               [ProgressHUD showSuccess:@"注销登录成功" Interaction:YES];
               NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
               [myDefault setObject:@"" forKey:@"用户名"];
               [myDefault setObject:@"" forKey:@"userId"];
               [myDefault setObject:@"未登录" forKey:@"登录状态"];
                _bottomButton.hidden = YES;
           } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
               
           }];
       }];
       UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       
       // 添加操作
       [alertDialog addAction:okAction];
       [alertDialog addAction:cancel];
    
       // 呈现警告视图
       [self presentViewController:alertDialog animated:YES completion:nil];
    
   
//    [_bottomButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
    
    
      
 

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
