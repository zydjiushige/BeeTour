//
//  catetoryModel.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/12.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface catetoryModel : NSObject

@property(nonatomic,copy)NSString *categoryID;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,copy)NSString *BigPicUrl;
@property(nonatomic,copy)NSArray *itemIds;
@property(nonatomic,copy)NSString *categoryName;
@property(nonatomic,copy)NSMutableArray *bannerArr;
@end
