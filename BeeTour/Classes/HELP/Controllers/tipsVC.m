//
//  tipsVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/19.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "tipsVC.h"

@interface tipsVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *tipsWebView;
@end

@implementation tipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadFile];
    
    
}
- (void)loadFile
{
    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"menu.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [_tipsWebView loadRequest:request];
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- <UIWebViewDelegate>
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NJLog(@"request------%@",request);
    if(navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        //浏览下一页
//        NSString *str=[NSString stringWithFormat:@"%@",request];
//        NSRange range=[str rangeOfString:@"http"];
//        NSString *str1=[str substringFromIndex:range.location];
//        NSString *newURL=[[str1 componentsSeparatedByString:@" "]firstObject];
        
//        NSURLRequest *request=[NSURLRequest requestWithURL:request];
         NJLog(@"request2------%@",request);
//        [_tipsWebView loadRequest:request];
        
        
    }
    return YES;
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
