//
//  goodsCell.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/18.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *moreGoodsButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *titleBigButton;
@end
