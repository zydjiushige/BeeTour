//
//  VisaVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/22.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "VisaVC.h"

@interface VisaVC ()
@property (weak, nonatomic) IBOutlet UIWebView *visaWebView;

@end

@implementation VisaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadFile];
}
- (void)loadFile
{
    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"visa_index.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [_visaWebView loadRequest:request];
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
