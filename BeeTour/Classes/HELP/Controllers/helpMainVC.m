//
//  helpMainVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/18.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "helpMainVC.h"
#import "HelpCollectionViewCell.h"
#import "tipsVC.h"
#import "VisaVC.h"
#import "lawVC.h"
@interface helpMainVC ()
{
    NSTimer *_timer;
}
@end

@implementation helpMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
   
    
}
- (IBAction)visaAction:(id)sender {
    VisaVC *visa = [[VisaVC alloc] initWithNibName:@"VisaVC" bundle:nil];
    [self presentViewController:visa animated:YES completion:nil];
}
- (IBAction)tipsAction:(id)sender {
    
    tipsVC *tips = [[tipsVC alloc] initWithNibName:@"tipsVC" bundle:nil];
    [self presentViewController:tips animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mapAction:(id)sender {
    [ProgressHUD show:@"Coming soon" Interaction:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}
- (IBAction)QAAction:(id)sender {
    [ProgressHUD show:@"Coming soon" Interaction:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}
- (IBAction)lawsAction:(id)sender {
    lawVC *laws = [[lawVC alloc] initWithNibName:@"lawVC" bundle:nil];
    [self presentViewController:laws animated:YES completion:nil];
    
}
-(void)hide
{
    [ProgressHUD dismiss];
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
