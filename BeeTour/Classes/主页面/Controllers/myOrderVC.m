//
//  myOrderVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/1.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "myOrderVC.h"
#import "myOrderCell.h"
#import "payButtonCell.h"
#import "paymentVC.h"
@interface myOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_leftLableArr;
    NSArray *_rightLableArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation myOrderVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
      _leftLableArr = [[NSArray alloc] init];
      _rightLableArr = [[NSArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_myTableView registerNib:[UINib nibWithNibName:@"myOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"payButtonCell" bundle:nil] forCellReuseIdentifier:@"payButtonCell"];
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _leftLableArr = @[@"Order generation date",@"Order number",@"Travel person",@"Contact",@"Travel date",@"Order amount",@"",@"Remaining payment time:"];
    _myTableView.backgroundColor = gray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ----------- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leftLableArr.count + 1 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row == 6){
            static NSString *reusedID=@"reusedID";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
            if(!cell)/////cell==nil
            {
                cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        
        
            }
        cell.backgroundColor = [UIColor clearColor];
            return cell;
    
    }else if(indexPath.row == 8){
        payButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payButtonCell"];
        [cell.payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
    myOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myOrderCell"];
    cell.titleLable.text = _leftLableArr[indexPath.row];
    return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 6){
    
        return 10.0f;
    }else if(indexPath.row == 8){
        return 77.0f;
    
    }
    return 44.0f;
}
#pragma mark --------- payAction
-(void)pay
{
    paymentVC *payVC = [[paymentVC alloc] initWithNibName:@"paymentVC" bundle:nil];
    [self presentViewController:payVC animated:YES completion:nil];

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
