//
//  mainInfoModel.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/8.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainInfoModel : NSObject

@property(nonatomic,copy)NSString *InfoId; //ID
@property(nonatomic,copy)NSString *title; // 标题
@property(nonatomic,copy)NSString *destination;//地点
@property(nonatomic,copy)NSString *PicUrl; // 图片链接
@property(nonatomic,copy)NSString *subTitle; // 置顶项目标题
@property(nonatomic,copy)NSString *requirement;
@property(nonatomic,copy)NSString *contentS;
@property(nonatomic,copy)NSString *synopsis;
@property(nonatomic,copy)NSString *harvest;
@property(nonatomic,copy)NSString *beginTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *perPrice;
@property(nonatomic,copy)NSString *include;
@property(nonatomic,copy)NSString *notInclude;
//@property(nonatomic,copy)NSString *picUrl;
@end
