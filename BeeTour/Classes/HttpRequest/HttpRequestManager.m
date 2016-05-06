//
//  HttpRequestManager.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/8.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "HttpRequestManager.h"

@implementation HttpRequestManager

+(instancetype)shareInstance
{
    static HttpRequestManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager=[[HttpRequestManager alloc] init];
    });
    return  manager;
}

//-(void)getMainInfoByPage:(int)page success:(httpSuccess)success failure:(httpFailure)failure
//{
//
//    NSString *urlString=[NSString stringWithFormat:mainUrl,page];
//    
//    //请求
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *arr=responseObject[@"data"];
//        
//        success(arr);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NJLog(@"error%@",error);
//    }];
//
//
//
//}
-(void)getQiniuTokenFromNetSuccess:(httpSuccess)success failure:(httpFailure)failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:getQiniuToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            NSDictionary *dic=responseObject;
    
            success(dic);
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error%@",error);
        }];

}
@end
