//
//  detailVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/23.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "detailVC.h"
#import "scollViewHeadView.h"
#import "goodsCell.h"
#import "detailInfoCell.h"
#import "detailIntrodutionCell.h"
#import "Tools.h"
#import "catetoryModel.h"
#import "contentDetailVC.h"
#import "mainInfoModel.h"
@interface detailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    scollViewHeadView *_view;
    int _page;  //计算上拉加载页面
    int _count; //计算滚动视图
    NSMutableArray *_scDataArr; // 轮播图数组
    NSMutableArray *_dataArr;
    BOOL _isOpen; // 是否展开
    UIWebView *_contentLable; // 简介Lable
    UIView *_contentLine; // 简介分割线
    CGFloat _clientheight;
    
    NSString *_contentStr;
    NSArray *_detailVCItemsIDArr;
    
    NSString *headPicUrl; //顶部图片
    
    NSString *_BTID;
    
     int cellRefreshCount;
    NSMutableArray *_contentInfoArr; // 存放详情页面的信息
    NSMutableArray *_userFavArr; // 用户收藏存放数组
    NSString *_userID;  // 用户名
    NSString *_userOnlyID; // 用户Id
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation detailVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
      _view=[[NSBundle mainBundle]loadNibNamed:@"scollViewHeadView" owner:self options:0][0];
        _scDataArr=[[NSMutableArray alloc] init];
        _page=0;
        _count=0;
        _dataArr=[[NSMutableArray alloc] init];
        _isOpen = NO;
       
        _contentLine = [[UIView alloc] initWithFrame:CGRectZero];
        _contentStr = [[NSString alloc] init];
        _detailVCItemsIDArr = [[NSArray alloc] init];
        _contentInfoArr = [[NSMutableArray alloc] init];
        _userFavArr = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    _titleLable.text = self.ntitle;
    _BTID = _catetoryID;
    
//    NJLog(@"---123%@",self.ntitle);
    
    
//    NJLog(@"_catetoryID%@",_BTID);
      [self loadDataFromNet];
    
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    _userOnlyID = [myDefault objectForKey:@"userId"];
        [self getFavoriteInfoWithUserID:_userOnlyID]; // 获取用户收藏信息

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  
     _contentLable = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) ];
    _contentLable.scrollView.scrollEnabled = NO;
    _contentLable.delegate = self;
   
    [_myTableView registerNib:[UINib nibWithNibName:@"goodsCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"detailInfoCell" bundle:nil] forCellReuseIdentifier:@"detailInfoCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"detailIntrodutionCell" bundle:nil] forCellReuseIdentifier:@"detailIntrodutionCell"];
    
    // 测试图片
    NSArray *TestImgArr = @[@"0",@"1",@"2"];
    
    [_scDataArr addObjectsFromArray:TestImgArr];

    
    // 定时器
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeImgV:) userInfo:_view.myScrollView repeats:YES];
    _view.myScrollView.delegate = self;
    _view.myScrollView.tag = 100 ;
    
    _view.pageCon=[[UIPageControl alloc] initWithFrame:CGRectMake(90, 100, 136, 20)];
    _view.pageCon.currentPageIndicatorTintColor=[UIColor grayColor];
    _view.pageCon.pageIndicatorTintColor=[UIColor whiteColor];
    _view.pageCon.tag=101;
    
    [_view addSubview:_view.pageCon];
    
    
    
    
    
    
    _view.myScrollView.contentSize=CGSizeMake(self.view.frame.size.width*_scDataArr.count, 0);
    
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*(_scDataArr.count-1), 0 , [UIScreen mainScreen].bounds.size.width, 128)];

    
    
    [_view.myScrollView addSubview:imgV];
    //    [imgV setImageWithURL:[NSURL URLWithString:value[@"img"]]];
    imgV.image = [UIImage imageNamed:_scDataArr[0]];
    imgV.tag= 103+_scDataArr.count;
    imgV.userInteractionEnabled=YES;
    imgV.backgroundColor = [UIColor redColor];
    [imgV addSubview:_view.titleLable];
    [_view.myScrollView addSubview:imgV];
    
    //添加手势 (轮播图点击图片)
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDetail:)];
//    
//    [imgV addGestureRecognizer:tap];
    
    _view.pageCon.numberOfPages=3;
  
    cellRefreshCount = 0;
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
#pragma mark -------- 返回
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --------定时改变图片
-(void)changeImgV:(NSTimer *)timer
{
    
    _count++;
    UIScrollView *scroll=timer.userInfo;
    
    if(_count>=_scDataArr.count)
    {
        _count=0;
        _view.myScrollView.contentOffset=CGPointMake(0, 0);
    }
    
    [scroll setContentOffset:CGPointMake(_count*self.view.frame.size.width, 0) animated:YES];
    
    UIPageControl *page=(UIPageControl *)[self.view viewWithTag:101];
    page.currentPage=_count;
    
    
//    [self loadDataFromNet];
}
#pragma mark ------- 加载数据
-(void)loadDataFromNet
{
    //
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@project/itemgp/%@",HostUrl,_BTID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        catetoryModel *model = [catetoryModel new];
        model.itemIds = responseObject[@"itemIds"];
        model.introduction = responseObject[@"introduction"];
//         [_contentLable loadHTMLString:model.introduction baseURL:nil];
        headPicUrl = responseObject[@"pic"][@"subTpic"];
       // _detailVCItemsIDArr = model.itemIds;
        [_dataArr addObject:model];
        [_myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"error%@",error);
    }];
}
#pragma mark -------<UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    catetoryModel * model = [[catetoryModel alloc]init];
    if(_dataArr.count>0){
        
        model = _dataArr[0];
        
        return model.itemIds.count+3;
    }else{
    
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    catetoryModel * model = [[catetoryModel alloc]init];
    if(_dataArr.count>0){
        
        model = _dataArr[0];
    }else{
    
        
    }
    
    if(indexPath.row %2 == 1){
        
        if(indexPath.row == 1){
        
            detailIntrodutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailIntrodutionCell"];
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
          
            [_contentLable loadHTMLString:model.introduction baseURL:nil];
            
//            _contentLable.frame = CGRectMake(cell.titleLable.frame.origin.x, cell.titleLable.frame.origin.y+50 , self.view.frame.size.width - (cell.titleLable.frame.origin.x), 1);
            
            [cell addSubview:_contentLable];
            
            // 分割线
            _contentLine.frame = CGRectMake( cell.titleLable.frame.origin.x, cell.titleLable.frame.origin.y+ 40, self.view.frame.size.width - (cell.titleLable.frame.origin.x), 1);
            _contentLine.backgroundColor = gray;
            [cell addSubview:_contentLine];
            
            if(_isOpen){
        
                
            [cell.openUpButton setImage:[UIImage imageNamed:@"ico_arrow_spread"] forState:UIControlStateNormal];
                _contentLine.hidden = NO;
                _contentLable.hidden = NO;
               
                
                
            }else{
            
                [cell.openUpButton setImage:[UIImage imageNamed:@
                                             "ico_Arr"] forState:UIControlStateNormal];
                _contentLine.hidden = YES;
                _contentLable.hidden = YES;
            }
            
            
            // 详情展开
            [cell.openUpButton addTarget:self action:@selector(openUpAction) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            return cell;
        
        }else{
        
        // 这个地方是子详情的开始
        detailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailInfoCell"];
        cell.backgroundColor = [UIColor clearColor];//就是要透明 然后两边变为透明 要的就是这个效果

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                   [manager GET:[NSString stringWithFormat:@"%@project/item/%@",HostUrl,model.itemIds[indexPath.row-3]] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
                      NJLog(@"%@",responseObject);
            
                     
                       cell.addressLable.text = responseObject[@"destination"];
                       cell.titleLable.text = responseObject[@"entity"][@"entityName"];
                       [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"pic"][@"subTpic"]]];
            
                       NSDictionary *dic = responseObject;
                        mainInfoModel *model = [[mainInfoModel alloc] init];
                       model.title = dic[@"entity"][@"entityName"];
                       model.PicUrl = dic[@"pic"][@"subTpic"];
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
                       model.title = dic[@"entity"][@"entityName"];
                           model.InfoId = dic[@"id"];
                       [_contentInfoArr addObject:model];
                       
                  } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                     NJLog(@"error%@",error);
                  }];
        return cell;
        }
    }else{
        
        static NSString *reusedID=@"reusedID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
       
        if(!cell)/////cell==nil
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
            
            
        }
        cell.backgroundColor = gray;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    
    
    if(indexPath.row %2 == 1){
        
        if(indexPath.row == 1){
            
            if(_isOpen){
            
                return 100.0f + _clientheight;
            
            }else
            return 44.0f;
        
        }else{
        
        
        return 190.0f;
        }
    }else{
        
        return 10.0f;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:view.frame];
    [image sd_setImageWithURL:[NSURL URLWithString:headPicUrl]];
    [view addSubview:image];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 120.0f ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    contentDetailVC *contentDeVC = [[contentDetailVC alloc] initWithNibName:@"contentDetailVC" bundle:nil];
    NSIndexPath *dindexPath = [_myTableView indexPathForSelectedRow];
    if(indexPath.row == 0 || indexPath.row == 1){
    
    
    }else{
      
        mainInfoModel *model1  = _contentInfoArr[dindexPath.row-3];
        
        contentDeVC.requirmentString = model1.requirement;
        contentDeVC.contentString = model1.contentS;
        contentDeVC.sysString = model1.synopsis;
        contentDeVC.destinationCity = model1.destination;
        contentDeVC.perPrice = model1.perPrice;
        contentDeVC.include = model1.include;
        contentDeVC.notInclude = model1.notInclude;
        contentDeVC.beginTime = model1.beginTime;
        contentDeVC.endTime = model1.endTime;
        contentDeVC.picUrl = model1.PicUrl;
        contentDeVC.harvest = model1.harvest;
        contentDeVC.Did = model1.InfoId;
        contentDeVC.ContentfavArr = _userFavArr;

    NJLog(@"在收藏页面上的ID%@",contentDeVC.Did);
    [self presentViewController:contentDeVC animated:YES completion:nil];
    }
}
#pragma mark ---------webViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    cellRefreshCount ++;
    if(cellRefreshCount == 1){
//    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    NJLog(@"clientheight_str------%@",clientheight_str);
//    _clientheight= [[_contentLable stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
 
  _clientheight = webView.scrollView.contentSize.height;

    NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:0];
    detailIntrodutionCell *cell = [_myTableView cellForRowAtIndexPath:path];
    _contentLable.frame =  _contentLable.frame = CGRectMake(cell.titleLable.frame.origin.x, cell.titleLable.frame.origin.y+50 , self.view.frame.size.width - (cell.titleLable.frame.origin.x),  _clientheight + 30);
    [_myTableView reloadData];
    }else{
    
        return;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------- 详情展开事件
-(void)openUpAction
{
    _isOpen = !_isOpen;
    [_myTableView reloadData];
    
}


@end
