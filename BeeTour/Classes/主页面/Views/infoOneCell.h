//
//  infoOneCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/1.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol infoOneCelldel <NSObject>

-(void)infoOne:(NSString*)str str:(NSString*)str2;

@end



@interface infoOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userEmailLable;

@property (weak, nonatomic) IBOutlet UILabel *userTelLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *editHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *downChooseButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *telLable;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;

@property (weak, nonatomic) IBOutlet UITextField *userLastName;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *sexLable;

@property(nonatomic,assign)id<infoOneCelldel> delegile;

@end
