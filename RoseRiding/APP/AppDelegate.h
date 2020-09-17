//
//  AppDelegate.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kHelloMapAppID @"J4m8BfWxh9shXN4GdogW"
  #define kHelloMapAppCode @"BGuPpon6lWvrDR9hoeuakA"
  #define kHelloMapLicenseKey @"FhZnJMx+KkDcV9ycyxhgEvvyJ/IMY/6YObrsWTRiACZ63U0JsRrwzp2g89xSc1oGIguXvo7tMeZxKsxwYZz56eW4PMOM5+kIlRm8eZC75f5jI16xi2zTDV2ASbyNdQFN3tFysPrPOD/bABYXs9aAJE5GxpeqEMkNb+SZCMsgOL6nVfSfgEV5WtoJ9ePtMdd0RtaogUoD84UWmAQ8dE/4CCnebAg8pooxiSXeQZWKthaprM80gci8f30KPXx+u/TfDQ3UIWPLl7upGFOoSf7M9+lxyP9F/yr/k3Fo4LK7U4yNssjBc8+6Awh2wRSYQwsiycDFejMm2SOD0RVjiD2sevIZWtAq8Z2FtpWOGilo1ZEMn1x79Uq5PMBJy5b/qPASGX7WZ9Pt//TT9yMUo/bUcMuOc+JuzCdvv536220KF+JKeMbtnH4HvF7qXeQxa6QTaLzkKgOOUuHjxFBGeMOwecifZHps1rr32iqar/esyU1V7urFQ3adUeRzg7gXQyM5CR+2W8OYLPrVMMRwJcSECfIWGhaL/fZbFku3SXs7P2Yd1KFY3t+pzkrzTw8O2loraqvezyEvTOTt8EHCoJxOc6srvJWX3x3UmHrIDmou6iL9hJz8ZyY6oVmYILlAT9UX5ymF5jpUdPlLCsCSKFprb52EtpTm2os41TotW+hdLHU="
#define App Store @"App Store"
#define AppDevelopment @"APPDevelopment"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)NSMutableDictionary * notDic;
@property (nonatomic, strong) NSData *deviceToken;
+ (void)initWithAppkey:(NSString *)appKey channel:(NSString *)channel;
@end

