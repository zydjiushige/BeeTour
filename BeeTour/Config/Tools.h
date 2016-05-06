//
//  Tools.h
//  计算文字的高度
//
//  Created by qianfeng on 15/7/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+ (CGSize)getHeightWithString:(NSString *)text width:(CGFloat)width;

@end
