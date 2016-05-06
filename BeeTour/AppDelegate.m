//
//  AppDelegate.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/16.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//
//                        internshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship
//internshipinternshipinternshipinternshipinternshipinternshipinternship




#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define paypalLiveID @"ARu​​ElN49ZWv5SB2_VvH-Y_fC4H5404FoxL9Y565Qj8FkWCmWFS18o87qttT9JltqzvbZky7YV-D-3d4W"
#define paypalSandboxID @"Adbw3qjLTBxa7Cxr-S0sUEbwb4dkpuZ_BuPiTevhnNjAdjRYPFdumlryHnCusk6a3carmaz36gEtCsgb"

#define UmengID @"57047d6b67e58e077d0000f2"
#define ShareSDKID @"12570b7b30140"


#import "AppDelegate.h"
#import "startVC.h"
#import <UMSocial.h>
#import <UMSocialFacebookHandler.h>
#import "mainVC.h"
#import <PayPalMobile.h>
#import <ShareSDK/ShareSDK.h>
//#import "UMSocialFacebookHandler.h"
//#import "UMSocialTwitterHandler.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <Twitter/Twitter.h>
@interface AppDelegate ()
{
    NSTimer *myTimer;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 如果用户已登录,就跳转到主页面,未登录跳转到引导页面
    if([Common isSignIn]){
    
        mainVC *main = [[mainVC alloc] initWithNibName:@"mainVC" bundle:nil];
        self.window.rootViewController = main;
    }else{
    
    startVC * theRVC = [[startVC alloc]initWithNibName:@"startVC" bundle:nil];
    self.window.rootViewController = theRVC;
        
    }
   [self.window makeKeyAndVisible];
    
  
   
    
    // paypal
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : paypalLiveID,
                                                           PayPalEnvironmentSandbox :
                                                               paypalSandboxID}];
    
  
    // 集成友盟分享
    [UMSocialData setAppKey:UmengID];

    
    // 集成shareSDK第三方授权登录
    [ShareSDK registerApp:ShareSDKID
     
          activePlatforms:@[
                       
                          
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeLinkedIn)
                          ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeFacebook:
                 [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                 break;
          
                 break;
             default:
                 break;
         }
     }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeFacebook:
                 [appInfo SSDKSetupFacebookByApiKey:@"507985369392680" appSecret:@"ef3ab78164c389ecfb08332ecd0e24a3" authType:SSDKAuthTypeBoth];
                 break;
                 case SSDKPlatformTypeTwitter:
                 [appInfo SSDKSetupTwitterByConsumerKey:@"dGXTLSsqUhQtLPx58CTlU52pK" consumerSecret:@"xqF2lRi4HYfUKxeenWpfJxMlSYBBGNiHLlNmxsuDugMXvtBUGu" redirectUri:@"http://sharesdk.cn"];
                 break;
             case SSDKPlatformTypeLinkedIn:
                 [appInfo SSDKSetupLinkedInByApiKey:@"75qnsocd7vj3sy" secretKey:@"8wlyObjKcFWsUE8I" redirectUrl:@"http://sharesdk.cn"];
                 break;
             default:
                 break;
         }
     }];
    
    
    
    return YES;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options
{
    return YES;
}
/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [UMSocialSnsService  applicationDidBecomeActive];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
