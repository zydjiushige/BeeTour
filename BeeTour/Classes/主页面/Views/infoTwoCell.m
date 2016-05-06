//
//  infoTwoCell.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/1.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "infoTwoCell.h"
@interface infoTwoCell ()<UITextFieldDelegate>

@end@implementation infoTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAddressLable.delegate = self;
    self.userCoutryLable.delegate = self;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //   NJLog(@"%@",self.userLastName.text);
    //   NJLog(@"%@",self.userNameLable.text);
    
    if([self.delegile respondsToSelector:@selector(infoTwo:str:)]){
        
        [self.delegile infoTwo:self.userCoutryLable.text str:self.userAddressLable.text];
    }
}
@end
