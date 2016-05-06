//
//  startVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/17.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "startVC.h"
#import "mainVC.h"
#import "loginInVC.h"
#import "signUpVC.h"
@interface startVC ()
{
    UIView *_backView;
    UIImageView *_backImgViewOne;
    UIImageView *_backImgViewTwo;
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

@implementation startVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
       
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    _skipButton.layer.masksToBounds = YES;
    _skipButton.layer.cornerRadius = 50/2;
    _skipButton.layer.borderWidth = 2;
    _skipButton.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9].CGColor;

     _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake((-[UIScreen mainScreen].bounds.size.width + 200)* 49 ,0,([UIScreen mainScreen].bounds.size.width + 200)* 50,  [UIScreen mainScreen].bounds.size.height - _signInButton.frame.size.height);
    
    [self.view addSubview:_backView];
//    _backImgViewOne = [[UIImageView alloc] initWithFrame:CGRectMake( 0 , 0 , [UIScreen mainScreen].bounds.size.width + 200 , _backView.bounds.size.height)];
//    [_backView addSubview:_backImgViewOne];
//   
//    _backImgViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(_backView.frame.size.width/2, 0, [UIScreen mainScreen].bounds.size.width + 200, [UIScreen mainScreen].bounds.size.height)];
//     [_backView addSubview:_backImgViewTwo];
    for(int i = 0 ; i< 50 ; i++){
    
        UIImageView *kankan = [[UIImageView alloc] init];
        kankan.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width + 200, 0, [UIScreen mainScreen].bounds.size.width + 200, [UIScreen mainScreen].bounds.size.height);
        kankan.image = [UIImage imageNamed:@"进入ios"];
        [_backView addSubview:kankan];
    }
    
    _backImgViewOne.image = [UIImage imageNamed:@"进入ios"];
    _backImgViewTwo.image = [UIImage imageNamed:@"进入ios"];
//    _backImgViewTwo.contentMode = UIViewContentModeRedraw;
//    _backImgViewOne.contentMode = UIViewContentModeScaleAspectFit;
        [self.view sendSubviewToBack:_backView];
    
        [self.view bringSubviewToFront:_logoImgView];
        [self.view bringSubviewToFront:_skipButton];

    // 开始页面动画
    [UIView animateWithDuration:50.0 animations:^{
        _backView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width *2 ,20,([UIScreen mainScreen].bounds.size.width + 200)* 50,  [UIScreen mainScreen].bounds.size.height - _signInButton.frame.size.height);
    }];
    // 开启定时器,5秒后自动跳转到主页面
    myTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];

    
}
#pragma mark -------- 定时器方法
-(void)scrollTimer
{
    mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
    [self presentViewController:main animated:YES completion:nil];
}
#pragma mark -------登录
- (IBAction)signInAction:(id)sender {
    
    loginInVC *loginIn  = [[loginInVC alloc] initWithNibName:@"loginInVC" bundle:nil];
    
    [self presentViewController:loginIn animated:YES completion:nil];
}
#pragma mark -------注册
- (IBAction)loginUpAction:(id)sender {
    
    signUpVC *SignUp  = [[signUpVC alloc] initWithNibName:@"signUpVC" bundle:nil];
    
    [self presentViewController:SignUp animated:YES completion:nil];
    
    
}
#pragma mark -----------忽略--------------
- (IBAction)skipAction:(id)sender {
    mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
    
    [self presentViewController:main animated:YES completion:nil];
    
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
