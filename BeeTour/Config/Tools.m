//
//  Tools.m
//  计算文字的高度
//
//  Created by qianfeng on 15/7/13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (CGSize)getHeightWithString:(NSString *)text width:(CGFloat)width
{
    /**
     Size 文字显示的最大区域
     options 通过什么方式来计算文字
     NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
     attributes 文字的字体，颜色
     context NULL
     */
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:NULL].size;
     //其中如果options参数为NSStringDrawingUsesLineFragmentOrigin，那么整个文本将以每行组成的矩形为单位计算整个文本的尺寸。
    //如果为NSStringDrawingTruncatesLastVisibleLine或者NSStringDrawingUsesDeviceMetric，那么计算文本尺寸时将以每个字或字形为单位来计算。
    //如果为NSStringDrawingTruncatesLastVisibleLine或者NSStringDrawingUsesDeviceMetric，那么计算文本尺寸时将以每个字或字形为单位来计算。
    
    return size;
}

@end
