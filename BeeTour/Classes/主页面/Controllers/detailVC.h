//
//  detailVC.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/23.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailVC : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property(nonatomic,copy)NSString *catetoryID;
@property(nonatomic,copy)NSString *ntitle;
@end
