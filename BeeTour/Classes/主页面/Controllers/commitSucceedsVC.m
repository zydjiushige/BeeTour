//
//  commitSucceedsVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/30.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "commitSucceedsVC.h"
#import "paymentVC.h"
@interface commitSucceedsVC ()

@end

@implementation commitSucceedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- 返回
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -------- 付款
- (IBAction)payAction:(id)sender {
    paymentVC *payVC = [[paymentVC alloc] initWithNibName:@"paymentVC" bundle:nil];
    [self presentViewController:payVC animated:YES completion:nil];
    
    
}
#pragma mark -------- goToOtherProjectAction
- (IBAction)goToOtherProjectAction:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the n ew view controller.
}
*/

@end
