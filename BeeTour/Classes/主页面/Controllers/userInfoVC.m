//
//  userInfoVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/29.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "userInfoVC.h"
#import "infoOneCell.h"
#import "infoTwoCell.h"
#import "infoThreeCell.h"

@interface userInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,infoOneCelldel,infotwoCelldel,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSData *_headImage; //照片的data
    BOOL _isChooseDown; // 判断是否点击下拉选择页面
    UITableView *_chooseTableView; // 下拉选择页面内的tableview;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_userID;
    
    
    NSString *_country;
    NSString *_address;
    NSString *_Email;
    NSString *_Tel;
    NSString *_birthday;
    int _sex;
    NSString *_userHeadImage;
    
    NSString *_tokenNiu;
    
    int _nowYear; // 现在的年份
    int _getYear;
    
    UIDatePicker *_date; //生日选择器
    UIPickerView *_sexPickerView; // 性别选择器
    
    NSArray *_sexArr;
    NSString *_chooseSexStr;
    NSString *_chooseBirthdayStr;
    
    NSString *_isSelectBirthday;
    NSString *_ageString;  // 生日里的年份
    NSString *_back1970Str; // 更新个人信息的毫秒
}
@property(weak,nonatomic)infoOneCell * inCell;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *fatherTitleLable;
@end

@implementation userInfoVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        _chooseTableView = [[UITableView alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    if([Common isSignIn]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        //        [self loadUserImageFromNet];
        //        [self getInfoDataWith:[myDefault objectForKey:@"用户名"]];
        [self getInfoFromMainVCWith:_userInfoDic]; //获得主页面传来的个人信息
        
    }else {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"Not Logged" message:@"Please SIGN IN" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"SIGN IN" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            loginInVC *inVC = [[loginInVC alloc] initWithNibName:@"loginInVC" bundle:nil];
            [self presentViewController:inVC animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return ;
        }];
        // 添加操作
        [alertDialog addAction:okAction];
        [alertDialog addAction:cancelAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        return;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NJLog(@"个人信息面板收到的dic----------%@",_userInfoDic);
    
    [_myTableView registerNib:[UINib nibWithNibName:@"infoOneCell" bundle:nil] forCellReuseIdentifier:@"infoOneCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"infoTwoCell" bundle:nil] forCellReuseIdentifier:@"infoTwoCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"infoThreeCell" bundle:nil] forCellReuseIdentifier:@"infoThreeCell"];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_myTableView addGestureRecognizer:tableViewGesture];
    
    _isChooseDown = NO; // 默认下拉选择页面收起
    
    _myTableView.delegate = self;
    _myTableView.dataSource= self;
    
    _chooseTableView.delegate = self;
    _chooseTableView.dataSource = self;
    
    
    
    // 选择页面开始隐藏
    _fatherView.hidden = YES;
    
    // 添加datePickerView
    _date= [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, _fatherView.frame.size.height - 44)];
    _date.datePickerMode = UIDatePickerModeDate;
    [_fatherView addSubview:_date];
    _date.hidden = YES;
    
    _isSelectBirthday = @"";
    _sexArr = @[@"保密",@"男",@"女"];
    // 婚姻状况选择页面
    _sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, _fatherView.frame.size.height - 44)];
    _sexPickerView.delegate = self;
    [_fatherView addSubview:_sexPickerView];
    _sexPickerView.hidden = YES;
}
#pragma mark --------- 点击tableview,收起键盘
- (void)commentTableViewTouchInSide{
    
    [self.view endEditing:YES];
}


#pragma mark --------- 返回(自动更新个人信息)
- (IBAction)goBack:(id)sender {
    
    
    
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath * path1 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    infoOneCell *cell = [_myTableView cellForRowAtIndexPath:path];
    infoTwoCell *cell2 = [_myTableView cellForRowAtIndexPath:path1];
    NJLog(@"%@========%@",cell.userNameLable.text,cell.userLastName.text);
    NJLog(@"%@========%@",cell2.userCoutryLable.text,cell2.userAddressLable.text);
    // }
    //infoTwoCell *cellB = (infoTwoCell *)[[textField superview] superview];
    
    // 判断是否登录
    
    [self.view endEditing:YES];
    
    
    //    NSString *userID = _userInfoDic[@"userId"];
    
    if([_birthday rangeOfString:@"-"].location != NSNotFound){
        
        NJLog(@"更新信息的生日----%@",_birthday);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate* date = [formatter dateFromString:_birthday]; //------------将字符串按formatter转成nsdate
        
        //    时间转时间戳的方法:
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970] * 1000];
        _back1970Str = timeSp;
    }else{
        
        _back1970Str = _birthday;
        
    }
    //
    NSDictionary *parameters = @{
                                 @"firstName": cell.userNameLable.text, // firstname
                                 @"lastName": cell.userLastName.text,    // lastname
                                 @"userCountry": cell2.userCoutryLable.text, //   country
                                 @"userCity": cell2.userAddressLable.text, // address
                                 @"sex" : @(_sex),
                                 @"birthday" : _back1970Str
                                 //
                                 };
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager PUT:[NSString stringWithFormat:@"%@%@",updateInfoUrl,userid] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NJLog(@"更新成功----%@",responseObject);
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
            
            [ProgressHUD showSuccess:@"Update info success" Interaction:YES];
        }else{
            
            
            [ProgressHUD showError:dic[@"message"] Interaction:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NJLog(@"更新失败----%@",error);
        [ProgressHUD showError:@"Update info failed" Interaction:YES];
    }];
    
    if(_headImage  == nil){
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[HttpRequestManager shareInstance]getQiniuTokenFromNetSuccess:^(id responseObject) {
            
            
            _tokenNiu = responseObject[@"uptoken"];
            NJLog(@"获得骑牛token------%@",_tokenNiu);
            [self upLoadUserHeadPicToNet];
        } failure:^(NSError *error) {
            
        }];
        
    }
    
    
    
    
}
#pragma mark -------- 上传头像
-(void)upLoadUserHeadPicToNet
{
    NJLog(@"上传头像时的token-00000----%@",_tokenNiu);
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    [ upManager putData:_headImage key:nil token:_tokenNiu
               complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                   NJLog(@"骑牛的回调----%@", info);
                   NJLog(@"骑牛的回调-----resp----%@", resp);
                   [self putUserHeadImageToNetWithID:resp[@"hash"]];
                   
                   
               } option:nil];
    
}
#pragma mark -------- 上传获取骑牛图片ID到服务器
-(void)putUserHeadImageToNetWithID:(NSString *)qiniuID
{
    
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [myDefault objectForKey:@"userId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"%@avatar/V1",upLoadUrl] parameters:@{@"id":userID,@"avatarId":qiniuID} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NJLog(@"头像上传到服务器成功-----%@",responseObject);
        NSDictionary *dic = responseObject;
        if(dic[@"success"]){
            [ProgressHUD showSuccess:@"upload avatar success" Interaction:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [ProgressHUD showSuccess:@"upload avatar failed" Interaction:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NJLog(@"头像上传到服务器失败-----%@",error);
        [ProgressHUD showSuccess:@"upload avatar failed" Interaction:YES];
    }];
    
}
#pragma mark -------- 接收从主页面传来的个人信息
-(void)getInfoFromMainVCWith:(NSMutableDictionary *)dic
{
    _address= dic[@"userCity"];
    _country = dic[@"userCountry"];
    _firstName = dic[@"firstName"];
    _lastName = dic[@"lastName"];
    _Email = dic[@"userEml"];
    _Tel = dic[@"userMbl"];
    _userHeadImage = dic[@"avatar"];
    _birthday = dic[@"birthday"];
    NSString *sexStr = dic[@"sex"];
    _sex = sexStr.intValue;
    //    NJLog(@"年龄%@",dic[@"sex"]);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark -------- <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _myTableView){
        return 3;
    }else{
        return 3;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJLog(@"%zd=====%zd",indexPath.row,indexPath.section);
    
    if(tableView == _myTableView){
        if(indexPath.row == 0){
            
            infoOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoOneCell" forIndexPath:indexPath];
            [cell.editHeadButton  addTarget:self action:@selector(changeHeadImgView) forControlEvents:UIControlEventTouchUpInside];
            cell.headImgView.layer.masksToBounds = YES;
            cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height /2;
            cell.headImgView.image = [UIImage imageWithData:_headImage];
            cell.headImgView.contentMode = UIViewContentModeScaleToFill;
            // 选择国家编号
            [cell.downChooseButton addTarget:self action:@selector(chooseCountryNum) forControlEvents:UIControlEventTouchUpInside];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.userLastName.text = _lastName;
            cell.userNameLable.text = _firstName;
            cell.userEmailLable.text = _Email;
            cell.userTelLable.text = _Tel;
            
            // 服务器获得毫秒生日转成年月日格式
            
            if([_isSelectBirthday isEqualToString:@"birthday"]){
                
                cell.birthdayLable.text = _birthday;
            }else if ([_isSelectBirthday isEqualToString:@"sex"]){
                
                if( [_birthday rangeOfString:@"-"].location != NSNotFound){
                    
                    cell.birthdayLable.text = _birthday;
                    
                    
                    
                }else{
                    
                    
                    long long time=[_birthday floatValue];
                    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time/1000];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    
                    
                    _ageString = [dateFormat stringFromDate:nd];
                    
                    // 分割出从服务器获取生日中的年份
                    NSArray *birthdayArr  = [_ageString componentsSeparatedByString:@"-"];
                    NSString *getYearStr = birthdayArr[0];
                    _getYear = getYearStr.intValue;
                    
                    cell.birthdayLable.text = _ageString;
                    
                    
                }
                
                
            }
            else{
                long long time=[_birthday floatValue];
                NSDate *nd = [NSDate dateWithTimeIntervalSince1970:time/1000];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                
                
                _ageString = [dateFormat stringFromDate:nd];
                
                // 分割出从服务器获取生日中的年份
                NSArray *birthdayArr  = [_ageString componentsSeparatedByString:@"-"];
                NSString *getYearStr = birthdayArr[0];
                _getYear = getYearStr.intValue;
                
                cell.birthdayLable.text = _ageString;
            }
            
            // 性别
            if(_sex == 0){
                
                cell.sexLable.text = @"保密";
            }else if(_sex == 1){
                
                cell.sexLable.text = @"男";
            }else if (_sex == 2){
                
                cell.sexLable.text = @"女";
            }
            
            //获取当前年份
            NSDate *  senddate=[NSDate date];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"YYYY"];
            
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            _nowYear = locationString.intValue;
            NJLog(@"获取系统当前时间------%@",locationString);
            //计算获得用户年龄
            
            if([_isSelectBirthday isEqualToString:@"birthday"]){
                
                
                NSArray *selectBirthdayArr = [_birthday componentsSeparatedByString:@"-"];
                NSString *selectYearStr = selectBirthdayArr[0];
                int seletYear = selectYearStr.intValue;
                cell.ageLable.text = [NSString stringWithFormat:@"%d",_nowYear-seletYear];
                
            }else if ([_isSelectBirthday isEqualToString:@"sex"]){
                
                if([_birthday rangeOfString:@"-"].location != NSNotFound){
                    
                    NSArray *selectBirthdayArr = [_birthday componentsSeparatedByString:@"-"];
                    NSString *selectYearStr = selectBirthdayArr[0];
                    int seletYear = selectYearStr.intValue;
                    cell.ageLable.text = [NSString stringWithFormat:@"%d",_nowYear-seletYear];
                }else{
                    
                    
                    
                    cell.ageLable.text = [NSString stringWithFormat:@"%d",_nowYear-_getYear];
                    
                }
                
            }
            else{
                
                cell.ageLable.text = [NSString stringWithFormat:@"%d",_nowYear-_getYear];
                
            }
            cell.birthdayLable.userInteractionEnabled = YES;
            
            // 点击生日Lable出现日期选择器
            UITapGestureRecognizer *BirthDayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBirthday)];
            [cell.birthdayLable addGestureRecognizer:BirthDayTap];
            
            UITapGestureRecognizer *sexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSex)];
            cell.sexLable.userInteractionEnabled = YES;
            [cell.sexLable addGestureRecognizer:sexTap];
            
            
            if(_headImage == nil){
                
                [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:_getUserUrlFromMain] placeholderImage:[UIImage imageNamed:@"icon"]];
                
            }else{
                
                
                
                cell.headImgView.image = [UIImage imageWithData:_headImage];
                
            }
            
            cell.delegile = self;
            
            
            // 添加下拉选择页面
            _chooseTableView.frame = CGRectMake(cell.downChooseButton.frame.origin.x, cell.downChooseButton.frame.origin.y + cell.downChooseButton.frame.size.height, 50, 0);
            _chooseTableView.hidden = YES;
            [_myTableView addSubview:_chooseTableView];
            if(_isChooseDown){
                
                _chooseTableView.hidden = NO;
                
                [UIView animateWithDuration:1.5 animations:^{
                    _chooseTableView.frame = CGRectMake(cell.downChooseButton.frame.origin.x, cell.downChooseButton.frame.origin.y + cell.downChooseButton.frame.size.height, 50, 200);
                }];
                //            _chooseTableView.frame = CGRectMake(0, 0, 50, 200);
                _chooseTableView.backgroundColor = [UIColor blueColor];
                
                
                
            }else{
                
                _chooseTableView.hidden = YES;
                
            }
            
            return cell;
        }else if (indexPath.row == 1){
            infoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoTwoCell"];
            cell.userCoutryLable.text = _country;
            cell.userAddressLable.text = _address;
            cell.delegile = self;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }else if(indexPath.row == 2){
            
            infoThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoThreeCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        return nil;
    }else{
        //
        static NSString *reusedID=@"reusedID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusedID];
        if(!cell)/////cell==nil
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
            
            
        }
        cell.backgroundColor = [UIColor redColor];
        return cell;
        
        
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _chooseTableView){
        
        return 1;
    }else{
        return 1;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 260.0f;
    }else if(indexPath.row == 1){
        return 162.0f;
    }else if(indexPath.row == 2){
        
        return 166.0f;
    }
    return 0.01f;
    
}
#pragma mark -------- 选择生日
-(void)chooseBirthday
{
    _isSelectBirthday = @"birthday";
    _fatherView.hidden = NO;
    _fatherTitleLable.text = @"生日";
    _date.hidden = NO;
    _sexPickerView.hidden = YES;
    _date.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
}
- (IBAction)YesAction:(id)sender {
    
    
    if([_isSelectBirthday isEqualToString:@"birthday"]){
        _fatherView.hidden = YES;
        NSDate *select  = [_date date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateAndTime = [dateFormatter stringFromDate:select];
        _birthday = dateAndTime;
        [_myTableView reloadData];
        
    }else if([_isSelectBirthday isEqualToString:@"sex"]){
        
        _fatherView.hidden = YES;
        [_myTableView reloadData];
        
    }
}
- (IBAction)cancelAction:(id)sender {
    
    _fatherView.hidden = YES;
}
#pragma mark -------- 选择性别
-(void)chooseSex
{
    _isSelectBirthday = @"sex";
    _fatherView.hidden = NO;
    _fatherTitleLable.text = @"性别";
    _date.hidden = YES;
    _sexPickerView.hidden = NO;
    
    
}
#pragma mark -------- 更换头像
-(void)changeHeadImgView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择头像" preferredStyle:UIAlertControllerStyleActionSheet];
    // 拍照
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        //设置图片源
        if(TARGET_OS_IPHONE){
            
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }else{
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        //代理
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }];
    // 从手机相册选择
    UIAlertAction *actionCancel1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        //设置图片源
        if(TARGET_IPHONE_SIMULATOR){
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }else{
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        //代理
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
    }];
    
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionCancel];
    [alert addAction:actionCancel1];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    NJLog(@"info==%@",info);
    //将图片转化为二进制
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    _headImage = UIImageJPEGRepresentation(image, 0.1);
    
    
    //退出图片选择器
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_myTableView reloadData];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -------- 选择国家编号
-(void)chooseCountryNum
{
    _isChooseDown = !_isChooseDown;
    NJLog(@"_isChooseDown value: %@" ,_isChooseDown?@"YES":@"NO");
    [_myTableView reloadData];
    [_chooseTableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES]; // 结束编辑
    if(scrollView == _myTableView){
        
        _chooseTableView.hidden = YES;
        
    }else{
        
        
        
    }
    //    _chooseTableView.hidden = YES;
    
    
    
}

/*
 
 */

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

-(void)infoOne:(NSString *)str str:(NSString *)str2{
    
    NJLog(@"----%@   %@",str,str2);
    
}
-(void)infoTwo:(NSString *)str str:(NSString *)str2
{
    NJLog(@"----®%@   %@",str,str2);
}

#pragma mark-----UIPickerViewDataSource,UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //    if (component == 0) {
    //        _provinceName=[NSString stringWithFormat:@"%@",_dataArray[row][@"state"]];
    //        return _provinceName;
    //    }else {
    //        _cityName=[NSString stringWithFormat:@"%@",_citiesArray[row]];
    //        return _cityName;
    //    }
    
    return _sexArr[row];
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    NSString *sexStr = _sexArr[row];
    _sex = sexStr.intValue;
    if([sexStr isEqualToString:@"保密"]){
        
        _sex = 0;
    }else if([sexStr isEqualToString:@"男"]){
        
        _sex = 1;
    }else if ([sexStr isEqualToString:@"女"]){
        
        _sex = 2;
    }
    
    NJLog(@"%@",_sexArr);
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _sexArr.count;
    
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
