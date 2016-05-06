//
//  Common.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/4/21.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "Common.h"

@implementation Common


+(BOOL)isSignIn
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSString *state = [myDefault objectForKey:@"登录状态"];
    if([state isEqualToString:@"已登录"]){
    
        return YES;
    }else{
    
        return NO;
    }
}
+(NSString *)getUserSpecialID
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [myDefault objectForKey:@"userId"];
    return userID;
}
+ (QNUploadManager *)shareInstance
{
    static QNUploadManager *sharedQNUploadManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedQNUploadManagerInstance = [[QNUploadManager alloc] init];
    });
    return sharedQNUploadManagerInstance;
    
    
   

}
@end
