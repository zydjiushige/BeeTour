//
//  Helper.h
//  Coding_iOS
//
//  Created by Elf Sundae on 14-12-22.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

+(void)ChiperRC4:(NSData*)input;
+(int)GZip:(NSData*)pUncompressedData Out:(NSData**)outdata;
+(int)GUnzip:(NSData*)pcompressedData Out:(NSData**)outdata;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;

//获取今天的日期：年月日
+(NSDictionary *)getTodayDate;

//邮箱
+ (BOOL) justEmail:(NSString *)email;

//手机号码验证
+ (BOOL)validatePhone:(NSString *)phone;

//用户名
+ (BOOL) justUserName:(NSString *)name;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//昵称
+ (BOOL) justNickname:(NSString *)nickname;


//是否是纯数字(验证QQ)
+ (BOOL)validateNumber:(NSString *)textString;
@end
