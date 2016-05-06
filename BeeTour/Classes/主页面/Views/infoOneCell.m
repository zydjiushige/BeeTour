//
//  infoOneCell.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/1.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "infoOneCell.h"

@interface infoOneCell ()<UITextFieldDelegate>

@end

@implementation infoOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userNameLable.delegate = self;
    self.userLastName.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

 //   NJLog(@"%@",self.userLastName.text);
 //   NJLog(@"%@",self.userNameLable.text);

    if([self.delegile respondsToSelector:@selector(infoOne:str:)]){
    
        [self.delegile infoOne:self.userLastName.text str:self.userNameLable.text];
    }
}


@end
