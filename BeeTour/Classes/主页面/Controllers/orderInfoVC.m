//
//  orderInfoVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/30.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "orderInfoVC.h"
#import "orderInfoCell.h"
#import "orderInfoSexCell.h"
#import "orderInfoInputCell.h"
#import "orderInfoPhoneCell.h"
#import "orderInfoReserveCell.h"
#import "orderInfoContinueCell.h"
#import "orderInfoAdressCell.h"
#import "confirmOrderVC.h"
@interface orderInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSString *_whichSex; // 选择性别

}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation orderInfoVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _whichSex = [[NSString alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registerTb];
    
}
-(void)registerTb
{
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoCell" bundle:nil] forCellReuseIdentifier:@"orderInfoCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoSexCell" bundle:nil] forCellReuseIdentifier:@"orderInfoSexCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoInputCell" bundle:nil] forCellReuseIdentifier:@"orderInfoInputCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoPhoneCell" bundle:nil] forCellReuseIdentifier:@"orderInfoPhoneCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoReserveCell" bundle:nil] forCellReuseIdentifier:@"orderInfoReserveCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoContinueCell" bundle:nil] forCellReuseIdentifier:@"orderInfoContinueCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"orderInfoAdressCell" bundle:nil] forCellReuseIdentifier:@"orderInfoAdressCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark ---------- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row == 0){
    
        orderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoCell"];
        return cell;
    }else if(indexPath.row == 1){
    
        orderInfoSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoSexCell"];
        [cell.maleButton addTarget:self action:@selector(chooseMale) forControlEvents:UIControlEventTouchUpInside];
        [cell.femaleButton addTarget:self action:@selector(chooseFemale) forControlEvents:UIControlEventTouchUpInside];
        if([_whichSex isEqualToString:@"male"]){
//            confirm_check
            [cell.maleButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
            [cell.femaleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
        }else{
        
            [cell.maleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
            [cell.femaleButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
        
        }
        
        return cell;
    }else if(indexPath.row == 3){
    
        orderInfoPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoPhoneCell"];
        return cell;
    }else if(indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7){
    
        orderInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoInputCell"];
        
        if(indexPath.row == 7){
        
            cell.titleLable.text = @"note";
        
        }
        return cell;
    
    }else if (indexPath.row == 5){
    
        orderInfoAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoAdressCell"];
        
        return cell;
    
    }else if (indexPath.row == 6){
        orderInfoReserveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoReserveCell"];
        
        return  cell;
    }else if (indexPath.row == 8){
    
    static NSString *reusedID=@"reusedID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
    if(!cell)/////cell==nil
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        
        
    }
        cell.backgroundColor = [UIColor clearColor];
    return cell;
    }else if(indexPath.row == 9){
    
        orderInfoContinueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoContinueCell"];
        [cell.continueButton addTarget:self action:@selector(goOn) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 5){
    
        return 100.0f;
    
    }
    return 50.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN.size.width, 30)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 20)];
    lable.text = @"Travel Informations";
    lable.font = [UIFont systemFontOfSize:10];
    [view addSubview:lable];
    return view;

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self.view endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight =40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset =UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0,0);
    } else {
        if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset =UIEdgeInsetsMake(-sectionHeaderHeight,0, 0,0);
        }
    }
}
-(void)chooseMale
{
    _whichSex = @"male";
    [_myTableView reloadData];

}
-(void)chooseFemale
{
    _whichSex = @"female";
    [_myTableView reloadData];
}
#pragma mark ---------  继续
-(void)goOn{

    confirmOrderVC *confirmVC = [[confirmOrderVC alloc] initWithNibName:@"confirmOrderVC" bundle:nil];
    [self presentViewController:confirmVC  animated:YES completion:nil];
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
