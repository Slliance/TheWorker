//
//  AppDelegate.m
//  TheWorker
//
//  Created by yanghao on 8/9/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDBHandle.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "ReverseGeoCode.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UserNotifications/UserNotifications.h>
#import "JGProgressHUD.h"
#import <Contacts/Contacts.h>
#import <NIMSDK/NIMSDK.h>
#import "UserModel.h"
#import "NTESNotificationCenter.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define USHARE_DEMO_APPKEY @"59a947eaae1bf87b9f001468"

@interface AppDelegate ()<BMKLocationServiceDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate>
{
    BMKMapManager               *_mapManager;
    BMKLocationService          *_locService;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:@"完成"];
    //拷贝数据库文件到沙盒中
    FMDBHandle *handle = [FMDBHandle sharedManager];
    
    [handle copySqliteFileToDocmentWithFileName:sql_file_name];
    /* 打开日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    
    
    //JPush================
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {  // 点击消息进来的
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tuisong" object:nil];
        // 重置服务器端徽章
        [JPUSHService resetBadge];
    }
    
#if defined(DEBUG)||defined(_DEBUG)
    [JPUSHService setupWithOption:launchOptions appKey:@"da9acc33278daac111d73976" channel:@"App Store debug" apsForProduction:NO];
#else
    [JPUSHService setupWithOption:launchOptions appKey:@"da9acc33278daac111d73976" channel:@"App Store" apsForProduction:YES];
#endif

    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    //    id province = [UserDefaults readUserDefaultObjectValueForKey:CURRENT_PROVINCE_DATA];
    
    //    if (!province) {
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    //启动LocationService
//    [_locService startUserLocationService];
//
//    //    }
//
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"4i4ijn4tbnW3ISMGDP0vjTtlG0Zkvvi1"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self setupNIMSDK];
    [self requestAuthorizationForAddressBook];
    return YES;
    
    //OG8zIB3HpuSnL4ZA74X43EhnxZgwZG5b百度key
}

- (void)requestAuthorizationForAddressBook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            } else {
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     
}



- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx58eeff2765021857" appSecret:@"42e9b993cdd95a91c5d721abf6e005ff" redirectURL:nil];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106456729"/*设置QQ平台的appID*/  appSecret:@"opMUptqFBZSyRQW5" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3516415621"  appSecret:@"354199225c83c44fff4af8a18533da48" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}





#pragma mark 离线消息推送
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //步骤三：同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    [JPUSHService registerDeviceToken:deviceToken];
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"收到推送消息。这里主要起到通知的作用，用户进入应用后，服务器会再次推送即时通讯消息");
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送失败，原因：%@",error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    int badge =[userInfo[@"aps"][@"badge"] intValue];
    badge--;
    [JPUSHService setBadge:badge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService resetBadge];
        return;
    }
    // 处于后台运行状态时
    NSLog(@"---UIApplicationStateInactive---");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tuisong" object:nil];
    //    }
    // badge清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    int badge =[userInfo[@"aps"][@"badge"] intValue];
    badge--;
    [JPUSHService setBadge:badge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    // 处于后台运行状态时
    NSLog(@"---UIApplicationStateInactive---");
    if (application.applicationState == UIApplicationStateActive) {
        [application setApplicationIconBadgeNumber:0];
        [JPUSHService resetBadge];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tuisong" object:nil];
    //    }
    // badge清零
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}



- (void)setupNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数等
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    
    
    //推荐在程序启动的时候初始化 NIMSDK
    NSString *appKey        = @"e4bbb7180a5c465bc306795e05f73571";
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
#if defined(DEBUG)||defined(_DEBUG)
    option.apnsCername      = @"devpushCertificates";
#else
    option.apnsCername      = @"dispushCertificates";
#endif
    
    option.pkCername        = nil;

    [[NIMSDK sharedSDK] registerWithOption:option];

    NSDictionary *userDic = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    if (userDic) {
        NSString *im_token = [UserDefaults readUserDefaultObjectValueForKey:im_token_key];
        UserModel *userModel = [[UserModel alloc] initWithDict:userDic];
        NSString *account = [NSString stringWithFormat:@"%@",userModel.mobile];
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account token:im_token];

    }
    [[NTESNotificationCenter sharedCenter] start];

}

#pragma MARK - aliPay

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result) {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);

        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (result) {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [HYNotification postAliPayResultNotification:resultDic];
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {//微信支付
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
#pragma mark 微信回调方法

- (void)onResp:(BaseResp *)resp
{
    
    
    
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    NSLog(@"errStr: %@",errStr);
    
    
    NSString * strTitle;
    //判断是微信消息的回调 --> 是支付回调回来的还是消息回调回来的.
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付成功";
                NSLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
                NSLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                strMsg =  @"支付失败";//[NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"faile";
                break;
            }
        }
        [HYNotification postWeixinPayResultNotification:@{@"weixinpay": wxPayResult,@"strMsg":strMsg}];
    }
}




@end
