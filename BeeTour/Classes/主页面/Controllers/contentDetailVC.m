//
//  contentDetailVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/28.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "contentDetailVC.h"
#import "orderInfoVC.h"
#import "detailHeadPicCell.h"
#import <UMSocial.h>
#import <MessageUI/MessageUI.h>
#import "costCell.h"
#import "abstractCell.h"
#import "detailsCell.h"
#import "goodsDetailModel.h"
#import "helpMainVC.h"
#import <AFNetworking/AFNetworking.h>
#import <ProgressHUD.h>
#import "RequirementCell.h"
#import "HarvestCell.h"
#import "timeCell.h"
@interface contentDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    UIView *_backView; // 半透明背景
    UIView *_shareView; // 分享背景
    UIView *_otherView;
    UILabel *_shareTitleLable; // 分享title
    NSArray *_shareIconArr;
    NSMutableArray *_dataArr;
 
    NSString *_userID;
    CGFloat _clientheight;
    CGFloat _clientContentH;
    CGFloat _clientRequirtH;
    CGFloat _clientHarvestH;
    
    int cellRefreshCount;
    BOOL _isFavorite;
    MJRefreshHeader *_refreshHeader;
    BOOL _isRefresh;
    
    UIWebView *_oneWeb;
    UIWebView *_twoWeb;
    UIWebView *_threeWeb;
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation contentDetailVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _shareView = [[UIView alloc] initWithFrame:CGRectZero];
        _shareTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _shareIconArr = [[NSArray alloc] init];
        _dataArr = [[NSMutableArray alloc] init];
//        _webHeight = [[NSString alloc] init];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [_dataArr removeAllObjects];
//    [self loadDataFromNetWithProjectId:_Did];
//    NJLog(@"-------获取详情信息----%ld",_getInfoArr.count);
//    NJLog(@"详情页面获取的收藏信息----%@",_ContentfavArr);
//    NJLog(@"获取主页面的req%@----=-=-=-content%@",self.requirmentString,self.contentString);
    
        if([_ContentfavArr containsObject:_Did]){
        
            _isFavorite = YES;
        }else{
        
            _isFavorite = NO;
        }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_myTableView registerNib:[UINib nibWithNibName:@"detailHeadPicCell" bundle:nil] forCellReuseIdentifier:@"detailHeadPicCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"costCell" bundle:nil] forCellReuseIdentifier:@"costCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"abstractCell" bundle:nil] forCellReuseIdentifier:@"abstractCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"detailsCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"RequirementCell" bundle:nil] forCellReuseIdentifier:@"RequirementCell"];
     [_myTableView registerNib:[UINib nibWithNibName:@"HarvestCell" bundle:nil] forCellReuseIdentifier:@"HarvestCell"];
     [_myTableView registerNib:[UINib nibWithNibName:@"timeCell" bundle:nil] forCellReuseIdentifier:@"timeCell"];
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shareIconArr = @[@"login_icon_face",@"share_ico_twitter",@"share_ico_email",@"share_ico_google",@"share_ico_line",@"share_ico_linked",@"",@""];
    
   
    
    cellRefreshCount = 0;
    [self creatShareView];
    [self createRefresh];
    
    [self loadWebGetHeight];
    
    
}
#pragma mark -------- 加载webview获取高度
-(void)loadWebGetHeight
{
    _oneWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _twoWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _threeWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    _oneWeb.delegate = self;
    [_oneWeb loadHTMLString:_sysString baseURL:nil];

    _twoWeb.delegate = self;
    [_twoWeb loadHTMLString:_contentString baseURL:nil];

    _threeWeb.delegate = self;
    [_threeWeb loadHTMLString:_requirmentString baseURL:nil];

}
#pragma mark ------ 创建下拉刷新
-(void)createRefresh
{
//    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self loadDataFromNet];
//       
//        _isRefresh = YES;
//        
//    }];

}
#pragma mark -------- 获取获取
-(void)loadDataFromNetWithProjectId:(NSString *)ID
{
//    if(_isRefresh){
//        
//     [_dataArr removeAllObjects];
//        _isRefresh = !_refreshHeader;
//    
//    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@project/item/%@",HostUrl,ID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NJLog(@"detail------responseObject%@",responseObject);
                NSDictionary *dic = responseObject;
        goodsDetailModel *model = [[goodsDetailModel alloc] init];
        model.destinationCity = dic[@"destination"];
        model.synopsis = dic[@"synopsis"];
//        model.entityContext = dic[@"entityContext"];
//        model.requirement = dic[@"requirement"];
        model.harvest = dic[@"harvest"];
        model.beginTime = dic[@"time"][@"startime"];
        model.endTime = dic[@"time"][@"endtime"];
        model.perPrice = dic[@"price"][@"baseTotalAmount"];
        model.include = dic[@"include"];
        model.notInclude = dic[@"notInclude"];
        model.picUrl = dic[@"pic"][@"subTpic"];
//        NJLog(@"entityContext-=-=-=-=-=-=-%@",model.entityContext);
//        NJLog(@"requirement$$$$$$$===-=-=-=-=-=%@",model.requirement);
        [_dataArr addObject:model];
        [_myTableView reloadData];
//        [_refreshHeader endRefreshing];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"error%@",error);
    }];


}
#pragma mark -------   <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
    detailHeadPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailHeadPicCell"];
//        goodsDetailModel *model = _dataArr.lastObject;
    [cell.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;

        [cell.loveButton addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
        [cell.headPicImgView sd_setImageWithURL:[NSURL URLWithString:_picUrl]];
        cell.cityLable.text = _destinationCity;
        if(_isFavorite){
            
            [cell.loveButton setImage:[UIImage imageNamed:@"info_icon_favo_pre"] forState:UIControlStateNormal];
        }else{
            
        [cell.loveButton setImage:[UIImage imageNamed:@"info_icon_favo"] forState:UIControlStateNormal];
        }
    return cell;
    }else if (indexPath.row == 2){
        abstractCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abstractCell"];
//        goodsDetailModel *model = _dataArr.lastObject;
        cell.addressLable.text = _destinationCity;
         [cell.synopsisWebView loadHTMLString:_sysString baseURL:nil];
//        cell.synopsisWebView.delegate = self;
        cell.synopsisWebView.scrollView.scrollEnabled = NO;
         cell.synopsisWebView.opaque = NO;
        cell.synopsisWebView.backgroundColor = [UIColor clearColor];
        for (UIView *subView in [cell.synopsisWebView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
        
         [(UIScrollView *)[[cell.synopsisWebView subviews] objectAtIndex:0] setBounces:NO];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
        
        
    }else if (indexPath.row == 4){
        detailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell"];
//        goodsDetailModel *model = _dataArr.lastObject;
//        cell.contentWeb.delegate = self;
        [cell.contentWeb loadHTMLString:_contentString baseURL:nil];
        cell.contentWeb.scrollView.scrollEnabled = NO;
        cell.contentWeb.opaque = NO;
        cell.contentWeb.backgroundColor = [UIColor clearColor];
        for (UIView *subView in [cell.contentWeb subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
        
        [(UIScrollView *)[[cell.contentWeb subviews] objectAtIndex:0] setBounces:NO];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
        
        
        
    }else if (indexPath.row ==5){
        RequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequirementCell"];
//          goodsDetailModel *model = _dataArr.lastObject;
//        cell.requirementWeb.delegate = self;
        cell.requirementWeb.scrollView.scrollEnabled = NO;
        cell.requirementWeb.backgroundColor = [UIColor clearColor];
        cell.requirementWeb.opaque = NO;
//        [cell.requirementWeb sizeToFit];
        cell.requirementWeb.backgroundColor = [UIColor clearColor];
        for (UIView *subView in [cell.requirementWeb subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
        
        [(UIScrollView *)[[cell.requirementWeb subviews] objectAtIndex:0] setBounces:NO];

        [cell.requirementWeb loadHTMLString:_requirmentString baseURL:nil];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
  

        
        return cell;
        
        
    }else if (indexPath.row == 6){
        HarvestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HarvestCell"];
//        goodsDetailModel *model = _dataArr.lastObject;
//        cell.harvestWeb.delegate = self;
        cell.harvestWeb.scrollView.scrollEnabled = NO;
        cell.harvestWeb.opaque = NO;
        cell.harvestWeb.backgroundColor = [UIColor clearColor];
        for (UIView *subView in [cell.harvestWeb subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
        
        [(UIScrollView *)[[cell.harvestWeb subviews] objectAtIndex:0] setBounces:NO];
        [cell.harvestWeb loadHTMLString:_harvest baseURL:nil];
         cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    
    
    }else if(indexPath.row == 7){
    
        timeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
//         goodsDetailModel *model = _dataArr.lastObject;
        // 毫秒转成时间
                long long time=[_endTime floatValue];
                NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time/1000];
        
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormat stringFromDate:nd];
        
                long long timeBegin=[_beginTime floatValue];
                NSDate *ndBegin = [NSDate dateWithTimeIntervalSince1970:timeBegin/1000];
        
                NSDateFormatter *dateFormatBegin = [[NSDateFormatter alloc] init];
                [dateFormatBegin setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStringBegin = [dateFormatBegin stringFromDate:ndBegin];
        
        
        
                cell.timeLable.text = [NSString stringWithFormat:@"%@———%@",dateStringBegin,dateString];

         cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return  cell;
    }
    
    
    
    
    else if (indexPath.row == 9){
        costCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costCell"];
//        goodsDetailModel *model = _dataArr.lastObject;
        cell.priceLable.text = [NSString stringWithFormat:@"%@ USD",_perPrice];
//        cell.includeWeb.delegate = self;
//        cell.notIncludeWeb.delegate = self;
        [cell.includeWeb loadHTMLString:_include baseURL:nil];
        cell.includeWeb.scrollView.scrollEnabled = NO;
        [cell.notIncludeWeb loadHTMLString:_notInclude baseURL:nil];
        cell.notIncludeWeb.scrollView.scrollEnabled = NO;
         cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setNeedsLayout];
        return cell;
    }else{
            static NSString *reusedID=@"reusedID";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
            if(!cell)/////cell==nil
            {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        
                
            }
        cell.backgroundColor = gray;
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
      
    
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 166.0f;
    }else if (indexPath.row == 2){
        return 360.0f + _clientheight - 200.0f;
    
    }else if (indexPath.row == 4){
    
        return 217.0f + _clientContentH - 80.0f;
        
        
    }else if (indexPath.row == 5){
    
        return  176.0f + _clientRequirtH - 98.0f ;
    }else if (indexPath.row == 6){
        
        return  162.0f + _clientHarvestH - 20.0f;
    }else if (indexPath.row == 7){
        
        return  50.0f;
    }
    else if (indexPath.row == 9){
    
        return 370.0f;
    }else{
    
        return 15.0f;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------- 创建分享页面
-(void)creatShareView
{
    _backView.frame = CGRectMake(0,  0, UISCREEN.size.width, UISCREEN.size.height);
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.6;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.view addSubview:_backView];
    [self.view bringSubviewToFront:_backView];
    //    [_backView addGestureRecognizer:tap];
    
    
    _otherView = [[UIView alloc] initWithFrame:_backView.frame];
    _otherView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_otherView];
    [_otherView addGestureRecognizer:tap];
    
    // 分享背景图
    _shareView.frame = CGRectMake(20, 100, UISCREEN.size.width - 40, 200);
    _shareView.backgroundColor = [UIColor whiteColor];
    [_otherView addSubview:_shareView];
    
    // 分享title
    _shareTitleLable.frame = CGRectMake(0, 0, 100, 20);
    _shareView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _shareTitleLable.center =  CGPointMake(_shareView.frame.size.width / 2, 20);
    _shareTitleLable.text = @"Share";
    _shareTitleLable.textAlignment = NSTextAlignmentCenter;
    [_shareView addSubview:_shareTitleLable];
    
    // 添加分享模块
    int  num;
    num = 6;
    for (NSInteger j = 0; j < 2; j ++) {
        for (NSInteger k = 0; k < 4; k ++) {
            UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            faceBtn.frame = CGRectMake(20 + k * ((_shareView.frame.size.width - 5 * 20)/4 + 20)  ,(_shareView.frame.size.width - 5 * 20)/4 + j*60,(_shareView.frame.size.width - 5 * 20)/4 , (_shareView.frame.size.width - 5 * 20)/4);
            [faceBtn setImage:[UIImage imageNamed:_shareIconArr[j*4+k]] forState:UIControlStateNormal];
            faceBtn.tag = 200 + j*4+k;
            faceBtn.backgroundColor = [UIColor whiteColor];
            [faceBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
            [_shareView addSubview:faceBtn];
            if((j==0&&k==0) || (j==0 && k==1)){
                
                faceBtn.hidden = NO;
                
            }else{
                faceBtn.hidden = YES;
            }
            
        }
    }
    _backView.hidden = YES;
    _otherView.hidden = YES;
}
#pragma mark ------ 分享
-(void)shareAction
{
    NJLog(@"我是分享");

    // 半透明背景图
    _backView.hidden = NO;
    _otherView.hidden = NO;
    
}
#pragma mark ------ 点击分享
-(void)shareTo:(UIButton *)button
{
    NJLog(@"button.tag%ld",button.tag);
    if(button.tag == 200){
    // faceBook
        // 分享API
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToFacebook] content:@"请输入你想要分享的内容" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NJLog(@"分享成功！");
            }
        }];
    
    }else if (button.tag == 201){
    // twitter
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToTwitter] content:@"分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        
            if (response.responseCode == UMSResponseCodeSuccess) {
                NJLog(@"分享成功！");
            }else{
            
            }
        }];

        
    }else if(button.tag == 202){
    // E-Mail
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:@"分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NJLog(@"分享成功！");
            }
        }];
    
    }else if (button.tag == 203){
    // Google+
    
    
    }else if (button.tag == 204){
    // Line

    
    }else if (button.tag == 205){
    // LinkedIn
    
    }
    
}
#pragma mark ------ 收藏
-(void)addFavorite
{
    
   
    if([Common isSignIn])  {
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        _userID = [myDefault objectForKey:@"userId"];
        NJLog(@"收藏页面的ID------%@---%@",_userID,_Did);
        
    }else{
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"SIGNIN" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            loginInVC *inVC = [[loginInVC alloc] initWithNibName:@"loginInVC" bundle:nil];
            [self presentViewController:inVC animated:YES completion:nil];
        }];
        // 添加操作
        [alertDialog addAction:okAction];
        [alertDialog addAction:cancelAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        return;
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     //  manager.requestSerializer=[AFJSONRequestSerializer serializer];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"http://192.168.0.238:8080/ytst-api-framework/app/user/collection/V1?userId=%zd&projectId=%@",_userID.integerValue,_Did] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [ProgressHUD showSuccess:@"收藏成功" Interaction:YES];
        _isFavorite = YES;
        [_myTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [ProgressHUD showSuccess:@"已收藏" Interaction:YES];
        NJLog(@"收藏失败------%@",error);
        _isFavorite = NO;
    }];

    
    
 
}
#pragma mark ------ 分享回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
#pragma mark ------ 下单
- (IBAction)buyNowAction:(id)sender {
    
   
    orderInfoVC *order = [[orderInfoVC alloc] initWithNibName:@"orderInfoVC" bundle:nil];
    [self presentViewController:order animated:YES completion:nil];
}
-(void)click
{
    _backView.hidden = YES;
    _otherView.hidden = YES;
}

#pragma mark ------- webviewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    if(webView == _oneWeb){
    _clientheight= [_oneWeb stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"].floatValue;
    }else if (webView == _twoWeb){
    _clientContentH= [_twoWeb stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"].floatValue;
    }else if (webView == _threeWeb){
    _clientRequirtH= [_threeWeb stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"].floatValue;
    }
   
    if(_clientContentH>0 && _clientRequirtH>0 && _clientheight>0){
    
        NJLog(@"获取的高度%f---%f---%f",_clientheight,_clientContentH,_clientRequirtH);

     [_myTableView reloadData];
    
    }

}
#pragma mark -------- 进入help页面
- (IBAction)HELPAction:(id)sender {
    helpMainVC *help = [[helpMainVC alloc] initWithNibName:@"helpMainVC" bundle:nil];
    [self presentViewController:help animated:YES completion:nil];
}
#pragma mark -------- 滚动TB,TopView实现渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"offset---scroll:%f",self.myTableView.contentOffset.y);
    UIColor *color = mainOrange;
    CGFloat offset=scrollView.contentOffset.y;
    if (offset<0) {
        _topView.backgroundColor= [color colorWithAlphaComponent:0];
    }else {
        CGFloat alpha=1-((64-offset)/64);
        _topView.backgroundColor=[color colorWithAlphaComponent:alpha];
    }
}

@end
