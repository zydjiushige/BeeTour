//
//  contentDetailVC.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/28.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contentDetailVC : UIViewController

@property(nonatomic,copy)NSString *Did;
@property(nonatomic,strong)NSMutableArray *ContentfavArr;
@property(nonatomic,strong)NSMutableArray *getInfoArr;
@property(nonatomic,copy)NSString *contentString;
@property(nonatomic,copy)NSString *requirmentString;
@property(nonatomic,copy)NSString *sysString;
@property(nonatomic,copy)NSString *destinationCity;
@property(nonatomic,copy)NSString *harvest;
@property(nonatomic,copy)NSString *beginTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *perPrice;
@property(nonatomic,copy)NSString *include;
@property(nonatomic,copy)NSString *notInclude;
@property(nonatomic,copy)NSString *picUrl;

@end
