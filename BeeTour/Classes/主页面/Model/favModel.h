//
//  favModel.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/21.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface favModel : NSObject

@property(nonatomic,assign)NSString *favID; // 收藏专有ID
@property(nonatomic,copy)NSString *favGoodsID;// 收藏栏目的ID,用于获取信息

@end
