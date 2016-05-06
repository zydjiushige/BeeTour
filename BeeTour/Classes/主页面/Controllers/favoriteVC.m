//
//  favoriteVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/20.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "favoriteVC.h"
#import "favModel.h"
#import "detailInfoCell.h"
#import "mainInfoModel.h"
#import "contentDetailVC.h"
@interface favoriteVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCellEditingStyle _editingStyle;
    NSMutableArray *_favDataArr;
    NSMutableArray *_contentInfoArr; // 存放详情页面的信息
    NSMutableArray *_userFavArr; // 用户收藏存放数组
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@end

@implementation favoriteVC
/**
 *  每次进入收藏页面都需要判断用户是否登录,然后再获取收藏信息
 *
 *  @param animated 
 */
-(void)viewWillAppear:(BOOL)animated
{
    if([Common isSignIn]){
        [_favDataArr removeAllObjects];
        _bigView.hidden = YES;
         NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        NSString *userID = [myDefault objectForKey:@"userId"];
        [self loadAllFavDataFromNetWith:userID];
        
    }else{
        
        _bigView.hidden = NO;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _favDataArr = [[NSMutableArray alloc] init];
    _contentInfoArr = [[NSMutableArray alloc] init];
    _userFavArr = [[NSMutableArray alloc] init];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"detailInfoCell" bundle:nil] forCellReuseIdentifier:@"detailInfoCell"];
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}
- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------ 获取所有收藏信息
-(void)loadAllFavDataFromNetWith:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //  manager.requestSerializer=[AFJSONRequestSerializer serializer];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    
    [manager GET:[NSString stringWithFormat:@"%@%zd",getAllFavInfoUrl,userID.integerValue] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _bigView.hidden = YES;
        NJLog(@"获取收藏成功-------%@",responseObject);
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
            NSArray *arr = dic[@"data"];
            for (NSDictionary *dicData in arr) {
                favModel *model = [favModel new];
                model.favID = [NSString stringWithFormat:@"%@",dicData[@"faId"]];
                model.favGoodsID = dicData[@"sharePath"];
                [_favDataArr addObject:model];
                [_userFavArr addObject: dicData[@"sharePath"]];
            }
            [_myTableView reloadData];
        }else{
        
         [ProgressHUD showSuccess:@"sorry,获取收藏失败" Interaction:YES];
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"获取收藏失败------%@",error);
        [ProgressHUD showSuccess:@"sorry,获取收藏失败" Interaction:YES];
        _bigView.hidden = NO;
    }];


}
#pragma mark ----------<UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favDataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    detailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailInfoCell"];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    favModel *model = _favDataArr[indexPath.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@project/item/%@",HostUrl,model.favGoodsID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NJLog(@"%@",responseObject);
        
        
        cell.addressLable.text = responseObject[@"destination"];
        cell.titleLable.text = responseObject[@"entity"][@"entityName"];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"pic"][@"subTpic"]]];
        
        NSDictionary *dic = responseObject;
        mainInfoModel *model = [[mainInfoModel alloc] init];
        model.title = dic[@"entity"][@"entityName"];
        model.PicUrl = dic[@"pic"][@"subTpic"];
        model.InfoId = dic[@"id"];
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
    
        
        [_contentInfoArr addObject:model];
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"error%@",error);
    }];

    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 175.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentDetailVC *contentDeVC = [[contentDetailVC alloc] initWithNibName:@"contentDetailVC" bundle:nil];
    NSIndexPath *dindexPath = [_myTableView indexPathForSelectedRow];
    mainInfoModel *model = _contentInfoArr[dindexPath.row];

//    contentDeVC.ContentfavArr = _userFavArr;
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
    contentDeVC.ContentfavArr = _userFavArr;
    contentDeVC.Did = model.InfoId;
    [self presentViewController:contentDeVC animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  删除收藏
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        favModel *model = _favDataArr[indexPath.row];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager DELETE:[NSString stringWithFormat:@"%@%@",deleteFavInfoUrl,model.favID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *dic = responseObject;
            if(dic[@"success"]){
            
                 [ProgressHUD showSuccess:@"Delete Success" Interaction:YES];
            
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
             [ProgressHUD showSuccess:@"Delete failed" Interaction:YES];
        }];
        
        [_favDataArr removeObjectAtIndex:indexPath.row];
        if(_favDataArr.count == 0){
            
            _bigView.hidden = NO;
        }
        [_myTableView reloadData];
        
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
