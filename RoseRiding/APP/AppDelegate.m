//
//  AppDelegate.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//
//蒲公英
#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "HomeController.h"
#import "MessageListController.h"
#import "MainNavController.h"
#import<GoogleSignIn/GoogleSignIn.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <Bugly/Bugly.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "BlueToothAlertManger.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "LoginController.h"
#import <UserNotifications/UserNotifications.h>
#import <AuthenticationServices/AuthenticationServices.h>
//#import <FirebaseAuth/FirebaseAuth.h>
//#import <Twitter/Twitter.h>
//#import <MapKit/MapKit.h>
//#import <SafariServices/SafariServices.h>
//#import <CoreLocation/CoreLocation.h>

#endif
//@import NMAKit;
@interface AppDelegate ()<JPUSHRegisterDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic,strong)MessageListController * mess;
@property (nonatomic,strong)MainTabbarController * MTabbar;
@property (nonatomic,strong)NSString * msgid;
@end
@implementation AppDelegate
static NSString * const UMkey = @"5f112d48978eea08cad1355a";
static NSString * const kFacebookAppID = @"273200134099388";
static NSString * const kClientID =
@"1013931763401-1cqb0uoo3g8funn8d8p2jdoh4aap9j5h.apps.googleusercontent.com";
static NSString * const  twitterID = @"https://api.twitter.com/oauth/authorize?oauth_token=1260152678191112193-vwOYR7q87vbgVSziZaW1Q08yH1neFP";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(2);
    [self registerAPN];
        // UMConfigure 通用设置，请参考SDKs集成做统一初始化。
        // 以下仅列出U-Share初始化部分
//     [UMConfigure initWithAppkey:@"5f112d48978eea08cad1355a" channel:@"App Store"];
//        // U-Share 平台设置
////        [self confitUShareSettings];
//        [self configUSharePlatforms];
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
//    [application registerUserNotificationSettings:settings];
    
    if (launchOptions) {
            /** 用一个label来显示通知 */
//            UILabel *label = [[UILabel alloc]init];
//            label.frame = CGRectMake(0, 100, 320, 200);
//            label.numberOfLines = 0;
//            label.text = [launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] description];
//            label.font = [UIFont systemFontOfSize:11];
//            [self.window.rootViewController.view addSubview:label];
            //清空角标
            
        }
 if (@available(iOS 13.0, *)) {
     NSString *userIdentifier = @"leopard (com.leopard.lockheed)";
     if (userIdentifier) {
         ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
         [appleIDProvider getCredentialStateForUserID:userIdentifier
                                           completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState,
                                                        NSError * _Nullable error)
         {
             switch (credentialState) {
                 case ASAuthorizationAppleIDProviderCredentialAuthorized:
                     // The Apple ID credential is valid
                     break;
                 case ASAuthorizationAppleIDProviderCredentialRevoked:
                     // Apple ID Credential revoked, handle unlink
                     break;
                 case ASAuthorizationAppleIDProviderCredentialNotFound:
                     // Credential not found, show login UI
                     break;
                 case ASAuthorizationAppleIDProviderCredentialTransferred:
                     NSLog(@"...");
                     break;
             }
         }];
     }
 }
        // Custom code


    // 为了使用 Facebook SDK 应该调用如下方法
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    // 注册 FacebookAppID
    [FBSDKSettings setAppID:kFacebookAppID];
   
       //地图***************heremap
//    NMAApplicationContextError error = [NMAApplicationContext setAppId:kHelloMapAppID
//                                                                  appCode:kHelloMapAppCode
//                                                               licenseKey:kHelloMapLicenseKey];
//       assert(error == NMAApplicationContextErrorNone);
    
          
//    [[TWTRTwitter sharedInstance] startWithConsumerKey:@"nw5JVwNKiquqM2ndOIKhCWnXj" consumerSecret:@"HkoIUtpqLKScX8wja0g2SFSbO75GeqbqH9mgahFxbieylVtmPF"];
  //Jpush
  JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
  if (@available(iOS 12.0, *)) {
      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
  } else {
      // Fallback on earlier versions
  }
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    // 可以添加自定义 categories
    // NSSet<UNNotificationCategory *> *categories for iOS10 or later
    // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
  }
  [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
  [JPUSHService setupWithOption:launchOptions appKey:@"f13d335c6913974de1ceaa2a"
                channel:AppDevelopment
               apsForProduction:false
  advertisingIdentifier:nil];
  [[BlueToothAlertManger shareManger] startMonitor];
  
  [Bugly startWithAppId:@"348d4a7823"];
    //googlelogin
    [GIDSignIn sharedInstance].clientID = kClientID;
    [IQKeyboardManager sharedManager].enable = YES;
                //注册谷歌地图
    [GMSPlacesClient provideAPIKey:@"AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo"];
   BOOL isSuccess =  [GMSServices provideAPIKey:@"AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo"];
    [self checkoutAutoLoginCallback:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.backgroundColor = [UIColor whiteColor];
            self.window.rootViewController = [[MainTabbarController alloc] init];
            self.notDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
//            NSLog(@"launchOptions--------%@",self.notDic);
            if (self.notDic[@"msg_id"]!= nil) {
                 self.msgid = self.notDic[@"msg_id"];
                           [self recivetime];
            }
            [self badgenumber];
            if (self.notDic) {
                
               [[NSNotificationCenter defaultCenter]postNotificationName:@"jpushNotificationCenter" object:self.notDic];
//                 这里就是告诉程序我要跳转到哪里
                MessageListController *hello = [[MessageListController alloc]init];
                //            hello.userInfo = launchOptions;
                [self.window.rootViewController  presentViewController:hello animated:YES completion:nil];
               hello.modalPresentationStyle = UIModalPresentationFullScreen;
//                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//                  [JPUSHService setBadge:0];
            }
            [self.window makeKeyAndVisible];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Appisloading" object:nil];
        });
    }];
    if (isSuccess) {
        NSLog(@"谷歌地图初始化成功");
    }else{
        NSLog(@"谷歌地图初始化失败");
    }
    return YES;
}
 // 注册通知
- (void)registerAPN {
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UIUserNotificationTypeBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
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

        //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
////    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
//                                                        @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139"
//                                                        };


}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*设置小程序回调app的回调*/
//        [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse, NSError *error) {
//        NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

    /* 钉钉的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];

    /* 支付宝的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];


    /* 设置易信的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置点点虫（原来往）的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];

    /* 设置领英的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];

    /* 设置Twitter的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"ePFWVkgksASzukq8VFSGCGAVF"  appSecret:@"DHtiPurR6QTkZYdAUuyJiTlUhDWEP2v5wmIvzVAuJjIpz5LJiv" redirectURL:nil];

    /* 设置Facebook的appKey和UrlString */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];

    /* 设置Pinterest的appKey */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];

    /* dropbox的appKey */
//    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];

    /* vk的appkey */
//    [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];

}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
     NSDictionary * userInfo = notification.request.content.userInfo;
//     NSLog(@"ios10userinfo%@",userInfo);
    if (userInfo[@"msg_id"]!= nil) {
        self.msgid = userInfo[@"msg_id"];
        [self recivetime];
    }
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"jpushNotificationCenter" object:userInfo];
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
       [JPUSHService handleRemoteNotification:userInfo];
      
    //从通知界面直接进入应用
      
      [self badgenumber];
//      [JPUSHService setBadge:0];
      NSLog(@"从通知界面直接进入应用");
  }else{
    //从通知设置界面进入应用
      NSLog(@"从设置界面直接进入应用");
  }
}
- (void)badgenumber{
        NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        badge += 1;
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge];
        [JPUSHService setBadge:badge];
   
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
    if (userInfo[@"msg_id"]!= nil) {
          self.msgid = userInfo[@"msg_id"];
          [self recivetime];
    }
  
//    NSLog(@"ios10userinfo%@",userInfo);
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
      NSLog(@"iOS 10 点击通知栏收到远程通知:%@",userInfo);
      
       [[NSNotificationCenter defaultCenter]postNotificationName:@"jpushNotificationCenter" object:userInfo];
      
//      [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
      [self badgenumber];
      
//      [JPUSHService setBadge:0];
        //判断应用是在前台还是后台
  }else{
          NSLog(@"iOS 10 点击通知栏收到本地通知:%@",userInfo);
  }
completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
  // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
     [[NSNotificationCenter defaultCenter]postNotificationName:@"jpushNotificationCenter" object:userInfo];
    
    if (userInfo[@"msg_id"]!= nil) {
          self.msgid = userInfo[@"msg_id"];
          [self recivetime];
    }
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      [JPUSHService handleRemoteNotification:userInfo];
     
       [self badgenumber];
      
     
                   //第二种情况后台挂起时
                   MessageListController * VC = [[MessageListController alloc] init];
//                   [VC requestSetWaring];
                   UITabBarController *tab = (UITabBarController *)_window.rootViewController;
                   if (tab != nil && tab.childViewControllers.count != 0) {
                       tab.selectedIndex = 1;
                       UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
                       VC.hidesBottomBarWhenPushed = YES;
                       //             VC.isnotify = YES;
                       [nav pushViewController:VC animated:YES];
                   }
//         [JPUSHService setBadge:0];
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
  }else{
      if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
          MessageListController * VC = [[MessageListController alloc] init];
          //                   [VC requestSetWaring];
                             UITabBarController *tab = (UITabBarController *)_window.rootViewController;
          if (tab != nil && tab.childViewControllers.count != 0) {
                                 tab.selectedIndex = 1;
                                 UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
                                 VC.hidesBottomBarWhenPushed = YES;
                                 //             VC.isnotify = YES;
                                 
                                 [nav pushViewController:VC animated:YES];
                                 
                             }
      }
  }
  completionHandler();  // 系统要求执行这个方法
}
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  // Required, For systems with less than or equal to iOS 6
  [JPUSHService handleRemoteNotification:userInfo];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
//    NSLog(@"点击了接收到了本地通知");
//    NSLog(@"%@",notification);
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"checktheBluetooth" object:nil];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closethetimer" object:nil];
//    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
//    [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
}
-(void)applicationWillTerminate:(UIApplication *)application {
    [Toast showToastMessage:@"退出"];
    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isfirstconnect"];
    [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
}
- (void)checkoutAutoLoginCallback:(void(^)(void))callback{
    NSMutableArray *localAccounts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy];
    if (localAccounts == nil) {
        if (callback) {
            callback();
        }
        LoginController * lo = [[LoginController alloc]init];
        [self.window.rootViewController  presentViewController:lo animated:YES completion:nil];
        return;
    }else{
        for (NSDictionary *userInfo in localAccounts) {
               if ([userInfo[@"isMain"] isEqual:@"1"]) {
                   [[NetworkingManger shareManger] postDataWithUrl:host(@"user/mesg") para:@{@"userid":userInfo[@"id"],@"token":userInfo[@"token"]} success:^(NSDictionary * _Nonnull result) {
                       if ([result[@"code"] integerValue] != 1) {
                       }else{
                           [[UserInfo shareUserInfo] setUserData:result[@"data"]];
                           [[UserInfo shareUserInfo] setToken: userInfo[@"token"]];
                           [JPUSHService setAlias:[NSString stringWithFormat:@"imei_%@",[result[@"data"] objectForKey:@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                           } seq:1];
                       }
                       if (callback) {
                           callback();
                       }
                       
                   } fail:^(NSError * _Nonnull error) {
                       if (callback) {
                           callback();
                       }
                   }];
               }
           }
    }
//    for (NSDictionary *userInfo in localAccounts) {
//        if ([userInfo[@"isMain"] isEqual:@"1"]) {
//            [[NetworkingManger shareManger] postDataWithUrl:host(@"user/mesg") para:@{@"userid":userInfo[@"id"],@"token":userInfo[@"token"]} success:^(NSDictionary * _Nonnull result) {
//                if ([result[@"code"] integerValue] != 1) {
//                }else{
//                    [[UserInfo shareUserInfo] setUserData:result[@"data"]];
//                    [[UserInfo shareUserInfo] setToken: userInfo[@"token"]];
//                    [JPUSHService setAlias:[NSString stringWithFormat:@"imei_%@",[result[@"data"] objectForKey:@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                    } seq:1];
//                }
//                if (callback) {
//                    callback();
//                }
//                
//            } fail:^(NSError * _Nonnull error) {
//                if (callback) {
//                    callback();
//                }
//            }];
//        }
//    }
   
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
     if([url.absoluteString containsString: kClientID]){
        return [[GIDSignIn sharedInstance] handleURL:url];
     }else if ([url.absoluteString containsString: kFacebookAppID]) {
            if (@available(iOS 9.0, *)) {
                return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
            } else {
                // Fallback on earlier versions
            }
         return NO;
     }else{
           BOOL result=[[UMSocialManager defaultManager]handleOpenURL:url];
            if (!result) {
                // 其他如支付等SDK的回调
            }
            return result;
     }
}
- (void)recivetime{
    NSString * url = host(@"users/p_time");
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"id":self.msgid,@"time":[self currentTimeStr]} success:^(NSDictionary * _Nonnull result) {
//        if (result[@"msg"]!= nil) {
////            [Toast showToastMessage:result[@"msg"]];
//        }
    } fail:^(NSError * _Nonnull error) {
//        [Toast showToastMessage:error.description];
    }];
}
//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
@end


