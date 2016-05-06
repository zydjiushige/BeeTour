//
//  aboutUsVc.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/25.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "aboutUsVc.h"

@interface aboutUsVc ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation aboutUsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self removeBlank];
    [self loadFile];
}
-(void)removeBlank
{
    _myWebView.opaque = NO;
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _myWebView.backgroundColor = [UIColor clearColor];
    for (UIView *subView in [_myWebView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    [(UIScrollView *)[[_myWebView subviews] objectAtIndex:0] setBounces:NO];
}
- (void)loadFile
{
    // 应用场景:加载从服务器上下载的文件,例如pdf,或者word,图片等等文件
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"aboutUs_frm_com_en.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [_myWebView loadRequest:request];
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[ request URL ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL  ];
    }
   
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.x > 0) {
        scrollView.contentOffset = CGPointMake(0, point.y);//这里不要设置为CGPointMake(0, point.y)，这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
    }
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
