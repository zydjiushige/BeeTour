//
//  Helper.m
//  Coding_iOS
//
//  Created by Elf Sundae on 14-12-22.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "Helper.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "UIAlertView+BlocksKit.h"
#import <zlib.h>
@import AVFoundation;

@implementation Helper
#define swap_int(_a, _b) int _t = _a; _a = _b; _b = _t;
#define CHUNK_SIZE 8192
//+ (BOOL)checkPhotoLibraryAuthorizationStatus
//{
//    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//    if (ALAuthorizationStatusDenied == authStatus ||
//        ALAuthorizationStatusRestricted == authStatus) {
//        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
//        return NO;
//    }
//    return YES;
//}

//+ (BOOL)checkCameraAuthorizationStatus
//{
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        kTipAlert(@"该设备不支持拍照");
//        return NO;
//    }
//    
//    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (AVAuthorizationStatusDenied == authStatus ||
//            AVAuthorizationStatusRestricted == authStatus) {
//            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
//            return NO;
//        }
//    }
//    
//    return YES;
//}

//+ (void)showSettingAlertStr:(NSString *)tipStr{
//    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
//        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tipStr];
//        [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
//        [alertView bk_addButtonWithTitle:@"设置" handler:nil];
//        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
//            if (index == 1) {
//                UIApplication *app = [UIApplication sharedApplication];
//                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                if ([app canOpenURL:settingsURL]) {
//                    [app openURL:settingsURL];
//                }
//            }
//        }];
//        [alertView show];
//    }else{
//        kTipAlert(@"%@", tipStr);
//    }
//}

+(void)ChiperRC4:(NSData*)input{
    uint32_t sbox_size = 256;
    unsigned char sbox[sbox_size];
    const char* _key = "03a976511e2cbe3a7f26808fb7af3c05";
    unsigned char * key = (unsigned char *)_key;
    uint32_t keysize = (uint32_t)strlen(_key);
    
    // Sbox Initilisieren
    unsigned char j =0;
    uint32_t i = 0;
    for (i = 0; i < sbox_size; i++)
        sbox[i] = i;
    // Sbox randomisieren
    for (i = 0; i < sbox_size; i++) {
        j += sbox[i] + key[i % keysize];
        swap_int(sbox[i], sbox[j]);
    }
    
    j = 0;
    i = 0;
    int n =0;
    
    unsigned char* content = (unsigned char*)[input bytes];
    for (n = 0; n < [input length]; n++) {
        i++;
        uint32_t index = i%sbox_size;
        j += sbox[index];
        swap_int(sbox[index], sbox[j]);
        content[n] = content[n] ^ (sbox[(sbox[index] + sbox[j]) & 0xFF]);
    }
}

+(int)GZip:(NSData*)pUncompressedData Out:(NSData**)outdata{
    if ([pUncompressedData length] && NULL != outdata)
    {
        float level = -1.0f;
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[pUncompressedData length];
        stream.next_in = (Bytef *)[pUncompressedData bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)roundf(level * 9);
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:CHUNK_SIZE];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += CHUNK_SIZE;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            *outdata = data;
            return 0;
        }
    }
    return -1;
    
}
+(int)GUnzip:(NSData*)pcompressedData Out:(NSData**)outdata{
    if ([pcompressedData length] && NULL != outdata)
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[pcompressedData length];
        stream.next_in = (Bytef *)[pcompressedData bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength: [pcompressedData length] * 1.5];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [pcompressedData length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    *outdata = data;
                    return 0;
                }
                else{
                NJLog(@"Gunzip failed with status == %d", status);
                    return -1;
                
                }
            }
            else{
                NJLog(@"Gunzip inflateEnd failed.");
                return -1;
            }
        }
        else{
            NJLog(@"Failed to init gunzip.");
            return -1;
        }
    }
    return -1;
}
//字符串转成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NJLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame=frame;
    CGRect newFrame=frame;
    newFrame.origin.y=frame.size.height/2.0;
    newFrame.size.height=frame.size.height/2.0;
    newFrame.origin.x=0;
    UILabel * label=[[UILabel alloc]initWithFrame:newFrame];
    label.text=title;
    [button addSubview:label];
    label.font=[UIFont systemFontOfSize:12];
    label.backgroundColor=[UIColor clearColor];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

#pragma  mark - 获取当天的日期：年月日
+ (NSDictionary *)getTodayDate
{
    
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", (long)[components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", (long)[components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];
    
    return todayDic;
    
}
//邮箱
+ (BOOL) justEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}




//用户名
+ (BOOL) justUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) justPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) justNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


- (BOOL)validateNumber:(NSString *)textString
{
    NSString* number=@"^[0-9]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
