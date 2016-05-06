//
//  mainVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/17.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "mainVC.h"
#import "scollViewHeadView.h"
#import "goodsCell.h"
#import "helpMainVC.h"
#import "detailVC.h"
#import "userInfoVC.h"
#import "contentDetailVC.h"
#import "myOrderVC.h"
#import "messagesCenterVC.h"
#import "settingsVC.h"
#import "mainInfoModel.h"
#import "catetoryModel.h"
#import "bannerModel.h"
#import "favoriteVC.h"
#import "loginInVC.h"
#import <ProgressHUD.h>
#import <MJRefresh.h>
#import "goodsDetailModel.h"
//#import <AFNetworking.h>
@interface mainVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    scollViewHeadView *_view;
    NSInteger _page;  //计算上下拉加载页面
    int _count; //计算滚动视图
    NSMutableArray *_scDataArr; // 轮播图数组
    NSMutableArray *_dataCatetoryArr;
//    NSMutableArray *_itemArrData;
    NSMutableArray *_itemIDArr;
    NSString *_firstItemID;
    
//    UIView * _leftView;
    
    UIImageView *headImgView;
    UILabel *nameLable;
    UILabel *ageLable;
    UIImageView *iconImgView;
    UILabel *cityLable;
    
 
    
    NSString *_whichView; // 判断是否是侧滑页面
    
    UIView *_orderView;
    UIView *_centerView;
    UIView *_favoriteView;
    UIView *_settingsView;
    UIView *_feedBackView;
    
    UIImageView *_orderImg;
    UIImageView *_centerImg;
    UIImageView *_favoriteImg;
    UIImageView *_settingsImg;
    UIImageView *_feedBackImg;
    
    UILabel *_orderLable;
    UILabel *_centerLable;
    UILabel *_favoriteLable;
    UILabel *_settingsLable;
    UILabel *_feedBackLable;

    
    
    
    UIButton *_clickInfoButton; // 点击个人信息
    
    NSString *_userID;  // 用户名
    NSString *_userOnlyID; // 用户Id
    NSString *_userName; // 用户名字
    NSString *_userAddress; // 用户所在地
    NSString *_userAge; // 用户年龄
    NSString *_userHeadUrl; // 用户头像url
    
    NSMutableArray *_contentInfoArr; // 存放详情页面的信息
    
    NSMutableDictionary *_infoDic;
    
     MJRefreshHeader * _headerRefresh;
    BOOL isRefresh;
    
    NSMutableArray *_userFavArr; // 用户收藏存放数组
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (atomic,strong)NSMutableArray * itemArrData;
@end

@implementation mainVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _view=[[NSBundle mainBundle]loadNibNamed:@"scollViewHeadView" owner:self options:0][0];
        _scDataArr=[[NSMutableArray alloc] init];
        _page=0;
        _count=0;
        _dataCatetoryArr=[[NSMutableArray alloc] init];
        _whichView = @"main";
        _clickInfoButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _itemArrData = [[NSMutableArray alloc] init];
        _firstItemID = [[NSString alloc] init];
        _itemIDArr = [[NSMutableArray alloc] init];
        _infoDic = [NSMutableDictionary new];
        _userFavArr = [[NSMutableArray alloc] init];
        _contentInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}
// 再次进入页面刷新数据
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    _userID = [myDefault objectForKey:@"用户名"];
    _userOnlyID = [myDefault objectForKey:@"userId"];
    if(_userID.length != 0){
        
        NJLog(@"用户名%@",_userID);
        
        
        [self loadUserInfoFromNetWithUserID:_userID]; // 获取用户信息
        [self getUserHeadImageFromNetWithID:_userOnlyID]; // 获取用户头像
        [self getFavoriteInfoWithUserID:_userOnlyID]; // 获取用户收藏信息
        
    }else{
        cityLable.text = @"click me";
        nameLable.text = @"click me can sign in";
        ageLable.text  = @"click me";
        headImgView.image = [UIImage imageNamed:@"icon"];
    }


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self creatView];
    
   
    
    [self loadMainCatetoryInfoData];// 加载主页面 类别 数据

//      NJLog(@"_itemArrData.count TT %lu",(unsigned long)_itemArrData.count);
    
    [self creatRefresh];
   
    
}
#pragma mark ----- 加载主页面UI
-(void)creatView
{
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeImgV:) userInfo:_view.myScrollView repeats:YES];
    _view.myScrollView.delegate = self;
    _view.myScrollView.tag = 100 ;
    
    _view.pageCon=[[UIPageControl alloc] initWithFrame:CGRectMake(90, 100, 136, 20)];
    _view.pageCon.currentPageIndicatorTintColor=[UIColor grayColor];
    _view.pageCon.pageIndicatorTintColor=[UIColor whiteColor];
    _view.pageCon.tag=101;
    
    [_view addSubview:_view.pageCon];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"goodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
    
    
    // 侧滑手势
    UISwipeGestureRecognizer *swipeGr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGr.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGr.direction = UISwipeGestureRecognizerDirectionRight;
    [_myTableView addGestureRecognizer:swipeGr];
    swipeGr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGr.direction = UISwipeGestureRecognizerDirectionLeft;
    [_fatherView addGestureRecognizer:swipeGr];
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(- ([UIScreen mainScreen].bounds.size.width - 100), 0, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height)];
    NJLog(@"_leftView%@",_leftView);
    _leftView.backgroundColor = [UIColor whiteColor];
    _leftView.alpha = 0.8;
    [self.view addSubview:_leftView];
    
    
    // 个人资料
    headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 70, 60, 60)];
    headImgView.backgroundColor = [UIColor redColor];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 30;
    headImgView.image = [UIImage imageNamed:@"icon"];
    [_leftView addSubview:headImgView];
    
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 70 + 60 + 20, 200, 20)];
    nameLable.text = @"Name";
    
    nameLable.font = [UIFont systemFontOfSize:15];
    [_leftView addSubview:nameLable];
    
//    ageLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 70 + 60 + 20 + 50, 300, 20)];
//    ageLable.text = @"1 years old";
//    ageLable.font = [UIFont systemFontOfSize:14];
//    [_leftView addSubview:ageLable];
    
    iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70 + 60 + 20 + 50 +30, 20, 20)];
    iconImgView.image = [UIImage imageNamed:@"edit_ico_add"];
    [_leftView addSubview:iconImgView];
    
    cityLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 70 + 60 + 20 + 50 +30, _leftView.frame.size.width - 30, 20)];
    cityLable.text = @"Japan";
    cityLable.font = [UIFont systemFontOfSize:14];
    [_leftView addSubview:cityLable];
    
    // 点击个人中心
    _clickInfoButton.frame = CGRectMake(0, 0, _leftView.bounds.size.width, 70 + 60 + 20 + 50 +30 + 50);
    [_leftView addSubview:_clickInfoButton];
    [_clickInfoButton addTarget:self action:@selector(clickInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 60 + 20 + 50 +30 + 50,[UIScreen mainScreen].bounds.size.width - 100, 50)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_orderView];
    
    // 点击订单中心
    UITapGestureRecognizer *tapOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderAction)];
    [_orderView addGestureRecognizer:tapOrder];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 60 + 20 + 50 +30 + 50 +50, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_centerView];
 
    _favoriteView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 60 + 20 + 50 +30 + 50 +50 +50, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_favoriteView];
    
    UITapGestureRecognizer *tapFav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FavoriteAction)];
    [_favoriteView addGestureRecognizer:tapFav];
    
    _favoriteImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _favoriteImg.image = [UIImage imageNamed:@"nav_icon_orde"];
    _favoriteImg.center = CGPointMake(25, _favoriteView.frame.size.height/2);
    [_favoriteView addSubview:_favoriteImg];
    
    _favoriteLable = [[UILabel alloc] initWithFrame:CGRectMake(_favoriteImg.frame.origin.x + 30, _favoriteImg.frame.origin.y, 200, 30)];
    _favoriteLable.text = @"Favorite";
    
    [_favoriteView addSubview:_favoriteLable];
    
    // 点击消息中心
    UITapGestureRecognizer *tapCenter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerAction)];
    [_centerView addGestureRecognizer:tapCenter];
    
    _settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 60 + 20 + 50 +30 + 50 +50 +50 +50 + 50, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    _settingsView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_settingsView];
    
    
    _feedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 60 + 20 + 50 +30 + 50 +50 +50 +50, [UIScreen mainScreen].bounds.size.width - 100, 50)];
    _feedBackView.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_feedBackView];
    
    _feedBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _feedBackImg.image = [UIImage imageNamed:@"nav_icon_orde"];
    _feedBackImg.center = CGPointMake(25, _feedBackView.frame.size.height/2);
    [_feedBackView addSubview:_feedBackImg];
    
    _feedBackLable = [[UILabel alloc] initWithFrame:CGRectMake(_feedBackImg.frame.origin.x + 30, _feedBackImg.frame.origin.y, 200, 30)];
    _feedBackLable.text = @"FeedBack";
    [_feedBackView addSubview:_feedBackLable];
    
    _orderImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _orderImg.image = [UIImage imageNamed:@"nav_icon_orde"];
    _orderImg.center = CGPointMake(25, _orderView.frame.size.height/2);
    [_orderView addSubview:_orderImg];
    
    _orderLable = [[UILabel alloc] initWithFrame:CGRectMake(_orderImg.frame.origin.x + 30, _orderImg.frame.origin.y, 200, 30)];
    _orderLable.text = @"My Order";
    
    [_orderView addSubview:_orderLable];
    
    
    _centerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _centerImg.image = [UIImage imageNamed:@"nav_icon_mes"];
    _centerImg.center = CGPointMake(25, _centerView.frame.size.height/2);
    [_centerView addSubview:_centerImg];
    
    
    _centerLable = [[UILabel alloc] initWithFrame:CGRectMake(_centerImg.frame.origin.x + 30, _centerImg.frame.origin.y, 200, 30)];
    _centerLable.text = @"Message center";
    
    [_centerView addSubview:_centerLable];
    
    _settingsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _settingsImg.image = [UIImage imageNamed:@"nav_icon_set"];
    _settingsImg.center = CGPointMake(25, _settingsView.frame.size.height/2);
    [_settingsView addSubview:_settingsImg];
    
    // 点击消息中心
    UITapGestureRecognizer *tapSettings = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsAction)];
    [_settingsView addGestureRecognizer:tapSettings];
    
    _settingsLable = [[UILabel alloc] initWithFrame:CGRectMake(_settingsImg.frame.origin.x + 30, _settingsImg.frame.origin.y, 200, 30)];
    _settingsLable.text = @"Settings";
    
    [_settingsView addSubview:_settingsLable];

}
#pragma mark -----监听网络状态
-(void)NetworkReachability
{
    //监测网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //有网络的情况下
                //获取网络数据
               [self loadMainCatetoryInfoData];
                
            } break;
                
            default:
            {
                //没有网络 或者 未知网络情况下
                //从数据库缓冲中获取本地数据
               
                
            }  break;
        }
        
    }];
    
    //开启监听
    [manager startMonitoring];
}
#pragma mark -----下拉刷新
-(void)creatRefresh
{
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadBannerDataFromNet];
        [self loadMainCatetoryInfoData];
        isRefresh = YES;
        
    }];
}
#pragma mark -------- 获取收藏信息
-(void)getFavoriteInfoWithUserID:(NSString*)userID
{
    [_userFavArr removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //  manager.requestSerializer=[AFJSONRequestSerializer serializer];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager GET:[NSString stringWithFormat:@"%@%zd",getAllFavInfoUrl,userID.integerValue] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
     
        NJLog(@"获取收藏成功-------%@",responseObject);
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
            NSArray *arr = dic[@"data"];
            for (NSDictionary *dicData in arr) {
               
            
                [_userFavArr addObject:dicData[@"sharePath"]];
               
            }
          
        }else{
            
           
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"获取收藏失败------%@",error);
       
    }];


}
#pragma mark -------- 加载banner数据
-(void)loadBannerDataFromNet
{
    if(isRefresh){
    
     
        [_scDataArr removeAllObjects];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@banner",HostUrl] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [_scDataArr removeAllObjects];
        
        NSArray *arr = responseObject;
       // NJLog(@"banner----responseObject%@",responseObject);
        for (NSDictionary *dic in arr) {
            bannerModel *model = [[bannerModel alloc] init];
            model.bannerPicUrl = dic[@"pic"];
            model.isShow = [NSString stringWithFormat:@"%@",dic[@"show"]];
            [_scDataArr addObject:model];
            NJLog(@"数据图片%@model存储图片%@",dic[@"pic"],model.bannerPicUrl);
            _view.myScrollView.contentSize=CGSizeMake(self.view.frame.size.width*_scDataArr.count, 0);
            
            UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*(_scDataArr.count-1), 0 , self.view.frame.size.width, self.view.frame.size.width / 2.5)];
            [_view.myScrollView addSubview:imgV];
            [imgV sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]]];
            imgV.tag= 103+_scDataArr.count;
            imgV.userInteractionEnabled=YES;
            [_view.myScrollView addSubview:imgV];
            
            //添加手势
//            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetail:)];
//            
//            [imgV addGestureRecognizer:tap];
        }
        
        
       NJLog(@"_scDataArr.count2%lu",(unsigned long)_scDataArr.count);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"轮播图请求数据失败---------error%@",error);
    }];


}
#pragma mark -------- 加载主页面 类别 数据
-(void)loadMainCatetoryInfoData
{
   
    
    if(isRefresh){
    
     _page =1;
        [_dataCatetoryArr removeAllObjects];
    
    }
    isRefresh =! isRefresh;
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:HostUrl@"project/itemgp/all" parameters:@{@"page":@(_page),@"rows":@10} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       
       
        NSArray *arr = responseObject;
        for ( NSDictionary *dic in arr) {
            
           // NSArray *itemsArr = [NSArray new];
            
            catetoryModel *model = [[catetoryModel alloc] init];
            model.categoryName = dic[@"catetoryName"];
            //NJLog(@"categoryName:::%@",model.categoryName);
            
            model.categoryID = dic[@"id"];
            model.itemIds = dic[@"itemIds"];
            
            if([dic[@"itemIds"] isKindOfClass:[NSNull class]]){
                // 此处分割线
                
                NJLog(@"_firstItemID.length----%lu",(unsigned long)_firstItemID.length);
                
            }else{
                
                [_dataCatetoryArr addObject:model];
                
            
            }
            

        }
       
        [_myTableView reloadData];
        
        
       // NJLog(@"_itemArrData.count OO%ld",_itemArrData.count);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"error%@",error);
         [_headerRefresh endRefreshing];
    }];
    
    
 }

#pragma mark --------- 点击进入个人信息页面
-(void)clickInfo
{
    if([Common isSignIn] == NO){
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
            
            return ;
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
    }else{
        userInfoVC *user = [[userInfoVC alloc] initWithNibName:@"userInfoVC" bundle:nil];
        user.userInfoDic = _infoDic;
        user.getUserUrlFromMain = _userHeadUrl;
        [self presentViewController:user animated:YES completion:nil];
    }
  
    
}
#pragma mark --------- 获取个人信息
-(void)loadUserInfoFromNetWithUserID :(NSString *)userID
{
    NJLog(@"返回时获取个人信息%@",userID);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getInfoUrl parameters:@{@"common":userID} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
//        NJLog(@"个人信息-----%@",responseObject);
        
        NSDictionary *dic = responseObject;
        _infoDic = dic[@"data"];
        cityLable.text = [NSString stringWithFormat:@"%@-%@", dic[@"data"][@"userCity"],dic[@"data"][@"userCountry"] ];
        nameLable.text = dic[@"data"][@"firstName"];
       
        NJLog(@"name--------%@",dic[@"data"][@"firstName"]);
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        [myDefault setObject:dic[@"data"][@"userId"] forKey:@"userId"];
        NJLog(@"获取的ID----%@",dic[@"data"][@"userId"]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"error%@",error);
        [ProgressHUD showSuccess:@"get info failed" Interaction:YES];
    }];


}
-(void)getUserHeadImageFromNetWithID:(NSString *)userID
{
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
      [manager GET:[NSString stringWithFormat:@"%@%@",getUserHeadImageURL,userID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          
          NSDictionary *dic = responseObject;
          
          NSString *avatarID = dic[@"data"][@"aratarID"];
          NJLog(@"获取用户头像-----%@--%@--%@",dic,userID,avatarID);
          NSString *headUrl = [NSString stringWithFormat:@"%@%@",qiniuURL,avatarID];
          [headImgView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
          
          _userHeadUrl = headUrl;
          
      } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
          NJLog(@"获取头像失败----%@",error);
      }];

}
#pragma mark ------ my order
-(void)orderAction
{
    if([Common isSignIn])  {
        myOrderVC *orderVC = [[myOrderVC alloc] initWithNibName:@"myOrderVC" bundle:nil];
        [self presentViewController:orderVC animated:YES completion:nil];
        
    }else{
    
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
            return ;
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
    NJLog(@"llll");
   
}
#pragma mark -------- 消息中心
-(void)centerAction
{
    if([Common isSignIn])  {
        messagesCenterVC *CenterVC = [[messagesCenterVC alloc] initWithNibName:@"messagesCenterVC" bundle:nil];
        [self presentViewController:CenterVC animated:YES completion:nil];
        
    }else{
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
            return ;
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
    
    
}
#pragma mark -------- 收藏
-(void)FavoriteAction
{
    if([Common isSignIn])  {
        favoriteVC *favVC = [[favoriteVC alloc] initWithNibName:@"favoriteVC" bundle:nil];
        [self presentViewController:favVC animated:YES completion:nil];
        
    }else{
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 操作具体内容
            // Nothing to do.
            return ;
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
    
    

}
#pragma mark -------- 设置
-(void)settingsAction
{
    settingsVC *settingVC = [[settingsVC alloc] initWithNibName:@"settingsVC" bundle:nil];
    [self presentViewController:settingVC animated:YES completion:nil];
}
#pragma mark -------- 列表
- (IBAction)listAction:(id)sender {
    
    _fatherView.hidden = NO;
    _fatherView.backgroundColor = [UIColor blackColor];
    _fatherView.alpha = 0.6;
    
    [UIView animateWithDuration:1.0 animations:^{
        _leftView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height) ;
        
    }];
    UISwipeGestureRecognizer *swipeGr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGr.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    swipeGr.direction = UISwipeGestureRecognizerDirectionLeft;
    [_myTableView addGestureRecognizer:swipeGr];

    
}
- (void)swipe:(UISwipeGestureRecognizer *)swipeGr
{
    if (swipeGr.direction == UISwipeGestureRecognizerDirectionRight) {
    NJLog(@"--向右滑动--");
        
        [UIView animateWithDuration:1.0 animations:^{
            _leftView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height) ;
            
        }];
        _fatherView.hidden = NO;
        _fatherView.backgroundColor = [UIColor blackColor];
        _fatherView.alpha = 0.6;
        
        _whichView = @"left";
        
//        _myTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }else if (swipeGr.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NJLog(@"--向左滑动--");
        [UIView animateWithDuration:1.0 animations:^{
            _leftView.frame = CGRectMake(- ([UIScreen mainScreen].bounds.size.width - 100), 0, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height);
        }];
        _whichView = @"main";
        _fatherView .hidden = YES;
    }
  
    
    
}
#pragma mark --------定时改变图片
-(void)changeImgV:(NSTimer *)timer
{
    
    _count++;
    UIScrollView *scroll=timer.userInfo;
//    NJLog(@"midscdataArr%ld",_scDataArr.count);
    if(_count>=_scDataArr.count)
    {
        _count=0;
        _view.myScrollView.contentOffset=CGPointMake(0, 0);
    }
    
    [scroll setContentOffset:CGPointMake(_count*self.view.frame.size.width, 0) animated:YES];
    
    UIPageControl *page=(UIPageControl *)[self.view viewWithTag:101];
    page.currentPage=_count;
}
#pragma mark --------<UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NJLog(@"_dataArr.count%lu",(unsigned long)_dataCatetoryArr.count);
    return _dataCatetoryArr.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if(indexPath.row %2 == 1){
    
        goodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell.moreGoodsButton addTarget:self action:@selector(moreGoods:) forControlEvents:UIControlEventTouchUpInside];
    [cell.titleBigButton addTarget:self action:@selector(moreGoodsAllAction:) forControlEvents:UIControlEventTouchUpInside];
        catetoryModel *model = _dataCatetoryArr[indexPath.row];
   
    cell.titleLable.text = model.categoryName;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@project/item/%@",HostUrl,model.itemIds[0]] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = responseObject;
        mainInfoModel *model = [[mainInfoModel alloc] init];
        model.title = dic[@"entity"][@"entityName"];
       // model.destination = ;
        model.PicUrl = dic[@"pic"][@"subTpic"];
        model.InfoId = dic[@"id"];
        cell.addressLable.text = dic[@"destination"];
        cell.secondTitleLable.text = dic[@"entity"][@"entityName"];
        
//        model1.destinationCity = dic[@"destination"];
        model.synopsis = dic[@"synopsis"];
        model.contentS = dic[@"entityContext"];
        model.requirement = dic[@"requirement"];
        model.harvest = dic[@"harvest"];
        model.beginTime = dic[@"time"][@"startime"];
        model.endTime = dic[@"time"][@"endtime"];
        model.perPrice = dic[@"price"][@"baseTotalAmount"];
        model.include = dic[@"include"];
        model.notInclude = dic[@"notInclude"];
        model.destination = dic[@"destination"];
//        model.picUrl = dic[@"pic"][@"subTpic"];

        [_contentInfoArr addObject:model];
        
        NJLog(@"-------------=-=-=-=-=%ld",_contentInfoArr.count);
        
        [_itemIDArr addObject:model];
        
         [cell.mainImgView sd_setImageWithURL:[NSURL URLWithString:model.PicUrl]];
           [_myTableView.mj_header endRefreshing];
       
    
    }
     
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NJLog(@"error%@",error);
             [_headerRefresh endRefreshing];
         }];
    
    
        return cell;

        return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row %2 == 1){
    
        return 247.0f;
    
//    }else{
//    
//        return 10.0f;
//    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _view.pageCon.numberOfPages=_scDataArr.count;
    [self loadBannerDataFromNet];

    return _view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 120.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    contentDetailVC *contentDeVC = [[contentDetailVC alloc] initWithNibName:@"contentDetailVC" bundle:nil];
    NSIndexPath *dindexPath = [_myTableView indexPathForSelectedRow];
    mainInfoModel *model = _itemIDArr[dindexPath.row];
    contentDeVC.Did = model.InfoId;
    contentDeVC.ContentfavArr = _userFavArr;
    contentDeVC.requirmentString = model.requirement;
    contentDeVC.contentString = model.contentS;
    contentDeVC.sysString = model.synopsis;
    contentDeVC.destinationCity = model.destination;
    contentDeVC.perPrice = model.perPrice;
    contentDeVC.include = model.include;
    contentDeVC.notInclude = model.notInclude;
    contentDeVC.beginTime = model.beginTime;
    contentDeVC.endTime = model.endTime;
    contentDeVC.picUrl = model.PicUrl;
    contentDeVC.harvest = model.harvest;
//    contentDeVC.getInfoArr = [[NSMutableArray alloc] init];
//    [contentDeVC.getInfoArr addObject:_contentInfoArr[indexPath.row]];
    
    NJLog(@"在主页面的ID%@",model.InfoId);
    [self presentViewController:contentDeVC animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------- 进入HELP页面
- (IBAction)helpAction:(id)sender {
    
    helpMainVC *helpVC = [[helpMainVC alloc] initWithNibName:@"helpMainVC" bundle:nil];
    [self presentViewController:helpVC animated:YES completion:nil];
    
    
}
#pragma mark ---------- 加载更多项目
-(void)moreGoodsAllAction:(id)sender
{
    goodsCell * cell = (goodsCell *)[[sender superview] superview];
    NSIndexPath * path = [self.myTableView indexPathForCell:cell];
    NJLog(@"index row%zd", path.row);
    detailVC *deVC = [[detailVC alloc] initWithNibName:@"detailVC" bundle:nil];
   
    catetoryModel *model = _dataCatetoryArr[path.row];
    NJLog(@"点击的row-----%ld",(long)path.row);
//    NSUserDefaults *my = [NSUserDefaults standardUserDefaults];
//    [my setObject:model.categoryID forKey:@"123"];
//    [my setObject:model.categoryName forKey:@"456"];

    deVC.catetoryID = model.categoryID;
    deVC.ntitle = model.categoryName;
    NJLog(@"在主页面传之前%@--%@----%@",model.categoryID,deVC.catetoryID,model.categoryName);
    [self presentViewController:deVC animated:YES completion:nil];
}
#pragma mark-----<UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:100];
    if (scrollView == scroll) {
        int index=scrollView.contentOffset.x/self.view.frame.size.width;
        UIPageControl *page=(UIPageControl *)[self.view viewWithTag:101];
        page.currentPage=index;
        
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
