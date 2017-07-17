//
//  AppDelegate.m
//  VpnTest
//
//  Created by Pellet Mo on 15/12/14.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "AppDelegate.h"
#import "MLBUserHomeViewController.h"
//分享功能
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    MLBUserHomeViewController *rootView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _gStatue = VPN_DISCONNECTED;
    
    //分享功能
    [ShareSDK registerApp:@"1e29e7dde0dfa"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1103580890"
                                           appSecret:@"c771b8ff56786331f1225735005ee559"
                                         redirectUri:@"http://mengyoutu.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxada2383d7254df47"
                                       appSecret:@"90fd4eb486ae3c9cfe51701157341600"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    //分享功能结束
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : MLBNavigationBarTitleTextColor}];
    [[UINavigationBar appearance] setTintColor:MLBLightGrayTextColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    NSString *version = [MLBUtilities appCurrentVersion];
    NSString *build = [MLBUtilities appCurrentBuild];
    NSString *versionAndBuild = [NSString stringWithFormat:@"%@_%@", version, build];
    //if (![[UserDefaults objectForKey:MLBLastShowIntroduceVersionAndBuild] isEqualToString:versionAndBuild]) {
    //    _window.rootViewController = [[MLBIntroduceViewController alloc] init];
    //} else {
    rootView = [[MLBUserHomeViewController alloc] init];
    _window.rootViewController = rootView;
    //}
    
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateStatue:(VPNSTATUE)s{
    _gStatue = s;
    switch (_gStatue) {
        case VPN_DISCONNECTED:
            [rootView updateTitleAndIcon:@"点击连接" iconName:@"moon2_88"];
            break;
        case VPN_CONNECTING:
            [rootView updateTitleAndIcon:@"正在连接..." iconName:@"more_link"];
            break;
        case VPN_CONNECTED:
            [rootView updateTitleAndIcon:@"VPN已连接" iconName:@"sun_88"];
            break;
        case VPN_DISCONNECTING:
            [rootView updateTitleAndIcon:@"正在断开..." iconName:@"more_link"];
            break;
            
        default:
            break;
    }
}
@end
