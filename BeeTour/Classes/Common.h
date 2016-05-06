//
//  Common.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/21.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>
@interface Common : NSObject

// 判断是否登录
+(BOOL)isSignIn;

+(NSString *)getUserSpecialID;
//qiniu
+ (QNUploadManager*)shareInstance;


@end
