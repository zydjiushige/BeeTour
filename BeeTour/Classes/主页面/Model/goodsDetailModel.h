//
//  goodsDetailModel.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/11.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsDetailModel : NSObject

@property(nonatomic,copy)NSString *destinationCity;
@property(nonatomic,copy)NSString *synopsis;
@property(nonatomic,copy)NSString *entityContext; // 内容
@property(nonatomic,copy)NSString *requirement;
@property(nonatomic,copy)NSString *harvest;
@property(nonatomic,copy)NSNumber *endTime;
@property(nonatomic,copy)NSNumber *beginTime;
@property(nonatomic,copy)NSNumber *perPrice;
@property(nonatomic,copy)NSString *include;
@property(nonatomic,copy)NSString *notInclude;
@property(nonatomic,copy)NSString *picUrl;
@end
