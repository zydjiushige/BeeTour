//
//  infoTwoCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/1.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol infotwoCelldel <NSObject>

-(void)infoTwo:(NSString*)str str:(NSString*)str2;

@end
@interface infoTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *userAddressLable;
@property (weak, nonatomic) IBOutlet UITextField *userCoutryLable;
@property(nonatomic,assign)id<infotwoCelldel> delegile;
@end
