//
//  HttpRequestManager.h
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/8.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import <Foundation/Foundation.h>
//成功的回调
typedef void (^httpSuccess)(id responseObject);

//失败的回调
typedef void (^httpFailure)(NSError *error);
@interface HttpRequestManager : NSObject

@property(nonatomic,copy)NSString *qiniuTokenString;
+ (instancetype)shareInstance;

//请求主页数据
//page     当前页
//rows     行数
//success  成功的回调
//failure  失败的回调
//- (void)getMainInfoByPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure;
// 获得qiqniuToken
-(void)getQiniuTokenFromNetSuccess:(httpSuccess)success failure:(httpFailure)failure;

@end
