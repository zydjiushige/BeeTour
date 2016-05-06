//
//  signUpCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/11.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *namelable;
@property (weak, nonatomic) IBOutlet UITextField *phoneOrEmailLable;
@property (weak, nonatomic) IBOutlet UITextField *passwordLable;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end
