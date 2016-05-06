//
//  confirmOrderVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/30.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "confirmOrderVC.h"
#import "confirmInfoCell.h"
#import "confirmPriceCell.h"
#import "confirEndCell.h"
#import "confirmCouponsCell.h"
#import "commitSucceedsVC.h"
@interface confirmOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation confirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_myTableView registerNib:[UINib nibWithNibName:@"confirmInfoCell" bundle:nil] forCellReuseIdentifier:@"confirmInfoCell"];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"confirmPriceCell" bundle:nil] forCellReuseIdentifier:@"confirmPriceCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"confirEndCell" bundle:nil] forCellReuseIdentifier:@"confirEndCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"confirmCouponsCell" bundle:nil] forCellReuseIdentifier:@"confirmCouponsCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = gray;
}
- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
#pragma mark ---------- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 ){
        
        static NSString *reusedID=@"reusedID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
        if(!cell)/////cell==nil
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
            
            
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    
    }else if (indexPath.row == 1){
        confirmInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"confirmInfoCell"];
        return cell;
    }else if(indexPath.row == 3){
        confirmCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCouponsCell"];
        return cell;
    }else if (indexPath.row == 5){
    
        confirmPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmPriceCell"];
        return cell;
    }else if (indexPath.row == 6){
    
        confirEndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirEndCell"];
        cell.backgroundColor = [UIColor clearColor];
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
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 ){
        return 15.0f;
    }else if (indexPath.row == 1){
        return 110.0f;
    }else if(indexPath.row == 3){
        return 44.0f;
    }else if (indexPath.row == 5){
        return 161.0f;
    }else if (indexPath.row == 6){
        return 132.0f;
    }

    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    commitSucceedsVC *commitSucceedVC = [[commitSucceedsVC alloc] initWithNibName:@"commitSucceedsVC" bundle:nil];
//    [self presentViewController:commitSucceedVC animated:YES completion:nil];

}
- (IBAction)placeOrderAction:(id)sender {
        commitSucceedsVC *commitSucceedVC = [[commitSucceedsVC alloc] initWithNibName:@"commitSucceedsVC" bundle:nil];
        [self presentViewController:commitSucceedVC animated:YES completion:nil];

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
