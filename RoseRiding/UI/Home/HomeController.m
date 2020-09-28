//
//  HomeController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/15.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HomeController.h"
#import "EditDeviceInfoNewController.h"
#import "BikeDeviceModel.h"
#import "MyDeviceController.h"
#import "DHGuidePageHUD.h"
#import "LoginController.h"
#import "BlueBindingViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <GMUHeatmapTileLayer.h>
#import <GMUWeightedLatLng.h>
//#import <gmuh>
@interface HomeController ()<GMSMapViewDelegate,CLLocationManagerDelegate>{
     float sec;
    float second;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UIButton *indicate_lock;
@property (weak, nonatomic) IBOutlet UIButton *indicate_connect;
@property (weak, nonatomic) IBOutlet UIButton *cancelbtn;
@property (weak, nonatomic) IBOutlet UIButton *indicate_battery;
@property (weak, nonatomic) IBOutlet UILabel *indicate_level;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIView *indicate_content;
- (IBAction)Disblue:(UIButton *)sender;
- (IBAction)cancelalarm:(UIButton *)sender;
- (IBAction)changecolor:(UIButton *)sender;
- (IBAction)backcolor:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *rightarrow;
@property (weak, nonatomic) IBOutlet UIView *alarmView;
@property (nonatomic,assign) BOOL isLock;
@property (nonatomic,assign) BOOL autolock;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,strong)GMSMapView *mapView;
@property (nonatomic,strong)GMUHeatmapTileLayer * heatMapLayer;
@property (nonatomic,strong)GMSMarker *marker;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL firstLocationUpdate;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate2D;
@property (nonatomic,strong)NSMutableArray <BikeDeviceModel *>*list;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;
@property (weak, nonatomic) NSTimer* timer;
@property (weak, nonatomic) NSTimer* reconnect;
- (IBAction)stop:(UIButton *)sender;
@property (nonatomic, strong) GYBabyBluetoothManager * babyMgr;
@property (nonatomic, assign)BOOL isAutoConnect;
@property (nonatomic, assign)BOOL isConnecting;
@property (nonatomic,strong)NSArray <GYPeripheralInfo *>*bluetoothList;
- (IBAction)goactivate:(UIButton *)sender;
@property (nonatomic, strong)BikeDeviceModel *currentDeviceInfo;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@property (weak, nonatomic) IBOutlet UIButton *workMode;
@property (weak, nonatomic) IBOutlet UIButton *activate_button;
@property (strong, nonatomic) UIButton *add;
@property (nonatomic , assign)BOOL  isCurrenPageBluetoothOperation;
@property (nonatomic , assign)BOOL  isreloadlocation;
@property (nonatomic, assign)BOOL isair;
- (IBAction)touchdown:(UIButton *)sender;
@property (nonatomic , assign)BatteryLevel batteryLevel;
@property (nonatomic , strong)GYPeripheralInfo *currentConnectDevice;//当前连接的蓝牙硬件
@property (nonatomic , strong)NSString * deviceimei;
@property (nonatomic , strong)NSString * deviceID;
@property (nonatomic , strong)NSString * deivce_equipment;
@property (nonatomic , strong)NSString * levelstring;
@property (nonatomic , strong)NSString * lat;
@property (nonatomic , strong)NSString * lng;
@property (nonatomic , strong)NSString * is_theft;
@property (nonatomic , strong)NSString * devicelat;
@property (nonatomic , strong)NSString * devicelong;
@property (nonatomic , assign)NSInteger isfirstconnect;
@property (nonatomic, strong) NSString *currentlocation;
@property (nonatomic, strong) NSString * bluename;
@property (nonatomic, strong) NSDictionary *currentLocationDetailInfo;
@property (nonatomic, strong) NSMutableArray * hisarray;
@property (nonatomic, strong) UILocalNotification *localNotification;
@end

static NSString *serverURL = @"http://rose.leopardtech.co.uk.twil.io/register-binding";
@implementation HomeController
{
    int times;
}
-(NSMutableArray *)hisarray{
    if (!_hisarray) {
        _hisarray = [NSMutableArray new];
    }
    return  _hisarray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"token--------------%@",[UserInfo shareUserInfo].token);
    self.isreloadlocation = YES;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
    self.reconnect = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reconnect:) userInfo:nil repeats:YES];
    self.deviceID = @"";
    self.deviceimei = @"";
    self.lat = @"";
    self.lng = @"";
    self.isShow = NO;
    sec = 0;
    self.isLock = YES;
    self.is_theft = @"2";
    times = 10;
    second = 0;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"]isEqualToString:@"0"]) {
        self.isfirstconnect = 0;
    }else if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"]isEqualToString:@""]){
        self.isfirstconnect = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"] integerValue];
    }
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(loaddata)
//                                                  name:UIApplicationDidBecomeActiveNotification
//                                                object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showdevicestate) name:@"devicecannotused" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReciveBluetoothConnectSuccessMessage:) name:GYBabyBluetoothManagerConnectSuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkbluetooth:) name:@"checktheBluetooth" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerout:) name:@"closethetimer" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editbikenamesuccess:) name:@"editNamesuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReciveBluetoothConnectFailMessage:) name:GYBabyBluetoothManagerConnectFailed
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReciveBluetoothMessageAction:)
                                                 name:GYBabyBluetoothManagerRead object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectDismiss:) name:GYBabyBluetoothManagerConnectDismiss object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectDismiss:)
                                                 name:BabyNotificationAtDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBikeSuccess)
                                                 name:@"addBikeSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlarmViewbackgroundcolor) name:@"nowarning" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothReconnect) name:BabyNotificationAtCentralManagerEnable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:@"loginSuccess"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDeviceSuccess) name:@"deleteDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(activatesuccess)
                                                name:@"activatesuccess"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterairmode:) name:@"enterairplanemode" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothDeviceListUpdate:)
                                                name:GYBabyBluetoothManagerDevicesListUpdate
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelUpDate:)
                                                 name:GYBabyBluetoothMangerBatteryLevel
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trytologin) name:@"loginfailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLanguage) name:@"changeLanguage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noDeviceconnect) name:GYBabyBluetoothManagerNoDeviceFound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcartheftsuccess:) name:GYBabyBluetoothMangerOpenCartheftSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect:) name:@"CBPeripheralManagerStatePoweredOn" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcarRolloversuccess:) name:GYBabyBluetoothMangerOpenCarRolloverSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jpushNotificationCenter:) name:@"jpushNotificationCenter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Vibartion:) name:GYBabyBluetoothManagerOpenCarVibartion object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(theftover:) name:GYBabyBluetoothManagertheftover object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Bluttoothdisconnectedreally:) name:@"Bluttoothdisconnectedreally" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"refreshUI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poweroff) name:@"CBPeripheralManagerStatePoweredOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterairmode:) name:@"air" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poweron) name:@"CBPeripheralManagerStatePoweredOn" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vibartionalert) name:GYBabyBluetoothManagerVIBRATION_Bluetooth object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startblue) name:@"Appisloading" object:nil];
    // Do any additional setup after loading the view from its nib.
       self.babyMgr = [GYBabyBluetoothManager sharedManager];
       //防止程序上次因未知原因退出蓝牙连接未断开导致被系统占用问题(crash或者其他原因)
       [self checkLastExitBluetoothConnecting];
       [self setStaticGuidePage];
       [self initUI];
       [self starLoaction];
       [self loadMyDevice];
       
//       [self getimei];
    self.marker = [[GMSMarker alloc]init];
//       [self loadlocation];
       if (Device_iPhone5) {
           self.leftCons.constant = self.rightCons.constant = 15;
       }
       //监听当前页面要显示的设备的变化
//    [RACObserve([MyDevicemanger shareManger], mainDevice) subscribeNext:^(id  _Nullable x) {
//               if (x == nil) {
//                   return;
//               }else{
//                   //更新显示内容
//                   [self loadMyDevice];
//               }
//           }];
}
- (void)checkbluetooth:(NSNotification *)notify{
    if (CBCentralManagerStatePoweredOn && [self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]]) {
    [self.reconnect setFireDate:[NSDate distantPast]];
    }
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)refreshUI{
    [self loadMyDevice];
}
- (void)timerout:(NSNotification *)notify{
    NSLog(@"停止扫描");
    times = 10;
    [self.reconnect setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)setAlarmViewbackgroundcolor{
//    self.cancelbtn.userInteractionEnabled = YES;
//    self.alarmView.backgroundColor = [UIColor whiteColor];
}

- (void)connect:(NSNotification*)notify{
    if ( [self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]]) {
    [self.reconnect setFireDate:[NSDate distantPast]];
    }
}
//- (void)showdevicestate{
//
//}
//飞行模式通知
- (void)enterairmode:(NSNotification *)notify{
    self.isair = YES;
 [self.workMode setTitle:[GlobalControlManger enStr:@"Airplane Mode" geStr:@"Airplane Mode"] forState:UIControlStateNormal];
    [self requestWaring];
    [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]
                                                 forState:UIControlStateNormal];
           [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth_gray"] forState:UIControlStateNormal];
      if([self.currentDeviceInfo.activation isEqualToString:@"3"]){
          if(self.autolock) {
               [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#15BA39"] forState:UIControlStateNormal];
             [self lockbike];
          }else {
              if([[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"]integerValue]>0 && self.isLock == NO && self.isShow) {
                  [self showAlert];
              }
          else{
              [self lockbike];
          }
          }
      }
     self.currentDeviceInfo.isConnecting = NO;
        [MyDevicemanger shareManger].mainDevice = self.currentDeviceInfo;
        [[NetworkingManger shareManger] postDataWithUrl:host(@"users/disconnectBle") para:@{@"id":self.currentDeviceInfo.Id,@"imei":self.currentDeviceInfo.device_imei} success:^(NSDictionary * _Nonnull result) {
    //        [self loadMyDevice];
    //        if (![[result objectForKey:@"msg"]isEqualToString:@""]) {
    //            [Toast showToastMessage:[result objectForKey:@"msg"]];
    //            NSLog(@"disconnectBle------------%@",[result objectForKey:@"msg"]);
    //        }
        } fail:^(NSError * _Nonnull error) {
            
        }];
    return;
}
#pragma mark //Traffic accident
- (void)accident{
    NSString * url = host(@"api/accident");
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"year":@"2018",@"type":@""} success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
        } fail:^(NSError * _Nonnull error) {
           NSLog(@"%@",error
                 );
        }];
}
#pragma mark - Networking

- (NSString*) createDeviceTokenString:(NSData*) deviceToken {
    const unsigned char *tokenChars = deviceToken.bytes;

    NSMutableString *tokenString = [NSMutableString string];
    for (int i=0; i < deviceToken.length; i++) {
        NSString *hex = [NSString stringWithFormat:@"%02x", tokenChars[i]];
        [tokenString appendString:hex];
    }
    return tokenString;
}

-(void) registerDevice:(NSData *) deviceToken identity:(NSString *) identity {
  // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
    
 NSString * url = host(@"users/twilioregister");
  NSString *deviceTokenString = [self createDeviceTokenString:deviceToken];
  NSDictionary *params = @{@"identity": identity,
                           @"endpoint": [NSString stringWithFormat:@"%@,%@", identity, deviceTokenString],
                        @"bindingType": @"apn",
                            @"address": deviceTokenString};
    [[NetworkingManger shareManger] postDataWithUrl:url para:params success:^(NSDictionary * _Nonnull result) {
//        NSLog(@"twilio-----%@",result);
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark //关闭蓝牙
- (void)poweroff{
    [self.reconnect setFireDate:[NSDate distantFuture ]];
//      times = 5;
        [self requestWaring];
        [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
        [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
        self.isreloadlocation = YES;
        [self loadlocation];
    //     NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"autolock"]);
        if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
       [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]
                                                   forState:UIControlStateNormal];
             [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth_gray"] forState:UIControlStateNormal];
        if([self.currentDeviceInfo.activation isEqualToString:@"3"]){
            if (self.autolock) {
                 [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#15BA39"] forState:UIControlStateNormal];
               [self lockbike];
            }else {
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"]integerValue]>0 && self.isLock == NO && self.isShow) {
                    [self showAlert];
                    UILocalNotification *localNotice = [UILocalNotification new];
                                 //                localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
                    localNotice.alertBody = [GlobalControlManger enStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'." geStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'."];
                               
                    localNotice.alertTitle =  [GlobalControlManger enStr:@"Do you want to enter anti-theft mode?" geStr:@"Do you want to enter anti-theft mode?"];
                    //            NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
                    //            badge += 1;
                    //              localNotice.applicationIconBadgeNumber = badge;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
                }
            else{
                [self lockbike];
            }
            }
        }
        }
}
//- (void)poweron{
//    [self.reconnect setFireDate:[NSDate distantPast]];
//}
- (void)reconnectbluetooth{
    if (!self.isCurrenPageBluetoothOperation) {
        return;
    }
    [self loadMyDevice];
}
-(void)trytologin{
    LoginController *loginVC = [LoginController new];
     loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}
#pragma mark //震动指令回复提醒
- (void)Vibartion:(NSNotification*)notify{
//     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.currentDeviceInfo.activation isEqualToString:@"3"]) {
      if (self.isLock) {
          [Toast showToastMessage:@"Vibartion Warning switch is on"];
      }else{
          [Toast showToastMessage:@"Vibartion Warning switch is off"];
      }
      }
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

//盗车结束通知
- (void)theftover:(NSNotification*)notify{
//    NSLog(@"盗车结束%@",notify);
     [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)Bluttoothdisconnectedreally:(NSNotification*)notify{
//    NSLog(@"Bluttoothdisconnectedreally=====%@",notify);
}
- (void)Timered:(NSTimer*)timer {
   
    if (sec < 60) {
         sec += 1;
    }else{
        sec = 0;
        [self loadlocation];
    }
//    [self.mapView clear];
//    self.marker.map = nil;
//    self.marker = nil;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self loadlocation];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark //自动重连
- (void)reconnect:(NSTimer*)timer{
    if (times> 0) {
        if (second < 30) {
            second += 1;
            self.isCurrenPageBluetoothOperation = YES;
            if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]]) {
                if (self.currentDeviceInfo != nil && [self.currentDeviceInfo.activation isEqualToString:@"3"]) {
                    [self deailAutoConnect];
                }
            }
        }else{
            second = 0;
            times -= 1;
        }
        
    }else{
        return;
    } 
}
- (void)didChangeLanguage{
    [self loadMyDevice];
}
- (void)startblue{
    self.isAutoConnect = NO;
         [Toast showToastMessage:@"Start connecting to bluetooth" inview:self.view interval:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           });
        self.isCurrenPageBluetoothOperation = YES;
        [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
        [self.babyMgr stopScanPeripheral];
        [self.babyMgr startScanPeripheral];
    //    [Toast showToastMessage:@"Blueteeth Connecting..."];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
}
- (void)loaddata{
//    [self loadMyDevice];
//    if (self.currentDeviceInfo != nil && [self.currentDeviceInfo.activation isEqualToString:@"3"] && self.babyMgr.systemBluetoothIsOpen) {
//            [self deailAutoConnect];
//    }
}
- (void)noDeviceconnect{
//    [Toast showToastMessage:@"Bluetooth Not Found"];
//    self.currentDeviceInfo.isConnecting = NO;
//    if ([self.currentDeviceInfo.activation isEqualToString:@"3"]) {
//        if (self.autolock == YES) {
//             [self lockbike];
//        }
//    }
}
#pragma mark //收到通知显示状态
- (void)jpushNotificationCenter:(NSNotification*)notify{
//    NSLog(@"%@",notify);
//    [self loadMyDevice];
    [self requestWaring];
    if (notify.object[@"type"] != nil) {
         if ([notify.object[@"type"]integerValue] == 19) {
               [self.workMode setTitle:[GlobalControlManger enStr:@"Normal Mode" geStr:@"Normal Mode"] forState:UIControlStateNormal];
           }else if ([notify.object[@"type"]integerValue] == 18) {
               [self.workMode setTitle:[GlobalControlManger enStr:@"Sleep Mode" geStr:@"Sleep Mode"] forState:UIControlStateNormal];
           }
    }
   
//    NSLog(@"%@",notify.object[@"type"]);
//    [];
}
#pragma mark //连接蓝牙状态电量更新
- (void)batteryLevelUpDate:(NSNotification *)notify{
    if ([notify.object integerValue] == 0) {
        self.batteryLevel = BatteryLevel1;
    }else if ([notify.object integerValue] == 1){
         self.batteryLevel = BatteryLevel2;
    }else if ([notify.object integerValue] == 2){
         self.batteryLevel = BatteryLevel3;
    }else if ([notify.object integerValue] == 3){
         self.batteryLevel = BatteryLevel4;
    }else if ([notify.object integerValue] == 4){
         self.batteryLevel = BatteryLevel5;
    }
    if (![self.levelstring isEqualToString:@""]) {
        [self setbuttonImage];
    }
}
#pragma mark //盗车指令回复提醒
- (void)setcartheftsuccess:(NSNotification *)notify{
//    NSLog(@"notify-----------%@",notify.object);
//     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.currentDeviceInfo.activation isEqualToString:@"3"]) {
        if (self.isLock) {
            [Toast showToastMessage:@"Anti-theft switch is on"];
        }else{
            [Toast showToastMessage:@"Anti-theft switch is off"];
        }
    }
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark //翻车指令回复提醒
- (void)setcarRolloversuccess:(NSNotification *)notify{
//    NSLog(@"notify-----------%@",notify.object);
//     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.currentDeviceInfo.activation isEqualToString:@"3"]) {

    if (!self.isLock) {
        [Toast showToastMessage:@"Rollover Warning switch is on"];
    }else{
        [Toast showToastMessage:@"Rollover Warning switch is off"];
    }
    }
//     [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)deleteDeviceSuccess{
    [self loadMyDevice];
}
- (void)bluetoothReconnect{
    [self loadMyDevice];
    if (self.currentDeviceInfo != nil && [self.currentDeviceInfo.activation isEqualToString:@"3"]) {
        [self deailAutoConnect];
    }
    if([self.currentDeviceInfo.activation isEqualToString:@"3"]){
        [self requestCheckBluetooth];
    }
}
- (void)editbikenamesuccess:(NSNotification*)notify{
    self.deivce_equipment = [notify.userInfo objectForKey:@"name"];
    self.currentDeviceInfo.equipment = [notify.userInfo objectForKey:@"name"];
}
#pragma mark------//蓝牙连接成功
- (void)didReciveBluetoothConnectSuccessMessage:(NSNotification *)notify{
     NSLog(@"success--------------%ld",(long)CBCentralManagerStatePoweredOn);
    if (!self.isCurrenPageBluetoothOperation) {
        return;
    }
    if ([self.currentDeviceInfo.activation isEqualToString:@"3"]) {
        [self requestCheckBluetooth];
    }
    self.currentDeviceInfo.isConnecting = YES;
    self.isreloadlocation = YES;
//    [self.mapView clear];
//    self.marker = nil;
//    self.marker.map = nil;
    [self loadlocation];
    [self loadMyDevice];
//    [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"] forState:UIControlStateNormal];
//    [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth"] forState:UIControlStateNormal];
//    [MyDevicemanger shareManger].mainDevice = self.currentDeviceInfo;
//    NSArray <GYPeripheralInfo *>*peripheralInfoArr = notify.object;
//    for (GYPeripheralInfo *info in peripheralInfoArr) {
//        if (info.peripheral.state == CBPeripheralStateConnected) {
//           [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelPeripheralConnection:info.peripheral];
//        }
//    }
//    self.bluetoothList = peripheralInfoArr;
//        for (GYPeripheralInfo *info in peripheralInfoArr) {
//            if ([[self macstring:info.advertisementData] isEqualToString:self.currentDeviceInfo.mac_id]) {
//                //连接蓝牙
//                 self.currentConnectDevice = info;
//                [self.babyMgr connectPeripheral:info.peripheral];
//            }
//        }
    [MyDevicemanger shareManger].mainDevice = self.currentDeviceInfo;
    [self.reconnect  setFireDate:[NSDate distantFuture]];
//        [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"] forState:UIControlStateNormal];
//            [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth"] forState:UIControlStateNormal];
    [self unlockbike];
    [self showconnect];
    return;
}
- (void)getimei{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"user/mesg") para:@{@"userid":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:result[@"data"][@"imei"] forKey:@"device_imei"];
            self.deviceimei = result[@"data"][@"imei"];
//            NSLog(@"imei--------------%@",result[@"data"][@"imei"]);
        }
        } fail:^(NSError * _Nonnull error) {
        }];
}
- (void)showconnect{
//    [self.workMode setTitle:[GlobalControlManger enStr:@"Normal Mode" geStr:@"Normal Mode"] forState:UIControlStateNormal];
    [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"] forState:UIControlStateNormal];
    self.currentDeviceInfo.isConnecting = YES;
//    [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#4b4b4b"] forState:UIControlStateNormal];
//    [self.indicate_lock setTitle:[GlobalControlManger enStr:@"Unsecured" geStr:@"Unsecured"] forState:UIControlStateNormal];
//    [self.indicate_lock setImage:[UIImage imageNamed:@"unlocked icon"] forState:UIControlStateNormal];
//    [self.lockBtn setTitle:[GlobalControlManger enStr:@"LockBike" geStr:@"LockBike"] forState:UIControlStateNormal];
//    [self.lockBtn setImage:[UIImage imageNamed:@"unlcok"] forState:UIControlStateNormal];
//             self.isLock = NO;
    [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth"] forState:UIControlStateNormal];
    self.isfirstconnect += 1;
    if (self.isShow && self.list.count>0) {
    [self dismissViewControllerAnimated:YES completion:nil];
    }
     [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)self.isfirstconnect] forKey:@"isfirstconnect"];
}
#pragma mark------//检测蓝牙状态（后台）
-(void)requestCheckBluetooth
{
//    kWeakSelf
    NSString *url = host(@"users/checkBluetooth");
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"token":[UserInfo shareUserInfo].token,@"id":self.currentDeviceInfo.Id,@"mac_id":self.currentDeviceInfo.mac_id} success:^(NSDictionary * _Nonnull result) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (stateCode == 1) {
        }else{
            if (![msg isEqualToString:@""]) {
//                NSLog(@"checkBluetooth--------------%@",msg);
                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}
#pragma mark------//蓝牙连接失败
- (void)didReciveBluetoothConnectFailMessage:(NSNotification * )notify{
    if (!self.isCurrenPageBluetoothOperation) {
        return;
    }
//     [self.indicate_connect setTitle:[GlobalControlManger enStr:[self.indicate_connect.titleLabel.text isEqualToString:@"connected"]?@"connected":@"Disconnected" geStr:[self.indicate_connect.titleLabel.text isEqualToString:@"connected"]?@"connected":@"Disconnected"] forState:UIControlStateNormal];
    self.currentDeviceInfo.isConnecting = NO;
    self.isreloadlocation = YES;
   [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]
                                                 forState:UIControlStateNormal];
    [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth_gray"] forState:UIControlStateNormal];
//    [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_THIEF_Bluetooth];
    [Toast showToastMessage:[GlobalControlManger enStr:@"Connnected Fail" geStr:@"Connnected Fail"]];
    [self lockbike];
    [self.reconnect setFireDate:[NSDate distantPast]];
}
#pragma mark------//电池按钮
- (void)setbuttonImage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//      CGFloat imageWidth = self.indicate_battery.imageView.width+1;
//      CGFloat leftlab = self.indicate_battery.titleLabel.width+1;
//      [self.indicate_battery setImageEdgeInsets:UIEdgeInsetsMake(.0,leftlab , .0, -leftlab)];
//      [self.indicate_battery setTitleEdgeInsets:UIEdgeInsetsMake(.0, -imageWidth, .0,imageWidth )];
        self.indicate_battery.hidden = NO;
        self.indicate_level.hidden = NO;
        self.indicate_level.text = self.levelstring;
        return;
//        self.indicate_battery.hidden = NO;
    });
}
#pragma mark------//检察蓝牙状态
- (void)checkLastExitBluetoothConnecting{
    self.isCurrenPageBluetoothOperation = YES;
    [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
    [[GYBabyBluetoothManager sharedManager] startScanPeripheral];
}
#pragma mark------//关闭蓝牙提示
- (void)showAlert{
    self.isShow = YES;

    NSString * apnCount = [GlobalControlManger enStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'." geStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'."];
    NSString * title = [GlobalControlManger enStr:@"Do you want to enter anti-theft mode?" geStr:@"Do you want to enter anti-theft mode?"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:apnCount preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"no" geStr:@"no"] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"yes" geStr:@"yes"]
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
         [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#15BA39"] forState:UIControlStateNormal];
        [self lockbike];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark------//蓝牙断开连接
- (void)deviceConnectDismiss:(NSNotification *)notify{
  times = 5;
    [self requestWaring];
    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
    [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
    self.isreloadlocation = YES;
    [self loadlocation];
  
          
           
//     NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"autolock"]);
    if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
   [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]
                                               forState:UIControlStateNormal];
         [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth_gray"] forState:UIControlStateNormal];
    if([self.currentDeviceInfo.activation isEqualToString:@"3"]){
        if (self.autolock) {
             [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#15BA39"] forState:UIControlStateNormal];
           [self lockbike];
        }else {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"isfirstconnect"]integerValue]>0 && self.isLock == NO && self.isShow) {
                [self showAlert];
                UILocalNotification *localNotice = [UILocalNotification new];
                                       //                localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
                        
                               localNotice.alertBody = [GlobalControlManger enStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'." geStr:@"If you want to automatically enter anti-theft mode, please tap 'Menu -> Anti-theft' and turn on 'Auto-lock or not'."];
                                                
                                     localNotice.alertTitle =  [GlobalControlManger enStr:@"Do you want to enter anti-theft mode?" geStr:@"Do you want to enter anti-theft mode?"];
                                     //            NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
                                     //            badge += 1;
                                     //              localNotice.applicationIconBadgeNumber = badge;
                                     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
            }
        else{
            [self lockbike];
        }
        }
    }
    }
    if (self.babyMgr.systemBluetoothIsOpen == YES ){
        [self.reconnect setFireDate:[NSDate distantPast]];
    }else{
        [self.reconnect setFireDate:[NSDate distantFuture]];
    return;
    }
//    [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_THIEF_Bluetooth];
    //失去连接
    if (self.currentDeviceInfo == nil) {
        return;
    }
    if (self.currentDeviceInfo.device_imei == nil) {
        return;
    }
    self.currentDeviceInfo.isConnecting = NO;
    [MyDevicemanger shareManger].mainDevice = self.currentDeviceInfo;
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/disconnectBle") para:@{@"id":self.currentDeviceInfo.Id,@"imei":self.currentDeviceInfo.device_imei} success:^(NSDictionary * _Nonnull result) {
//        [self loadMyDevice];
//        if (![[result objectForKey:@"msg"]isEqualToString:@""]) {
//            [Toast showToastMessage:[result objectForKey:@"msg"]];
//            NSLog(@"disconnectBle------------%@",[result objectForKey:@"msg"]);
//        }
    } fail:^(NSError * _Nonnull error) {
    }];
}
- (void)setanti_theftalarm{
    
}
#pragma mark------//添加车辆成功
- (void)addBikeSuccess{
   [self loadMyDevice];
}
#pragma mark------//登录成功
- (void)loginSuccess{
//    NSLog(@"%@",  [UserInfo shareUserInfo].token);
    if (self.currentDeviceInfo == [MyDevicemanger shareManger].mainDevice) {
        [self loadMyDevice];
        return;;
    }else{
        if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
            [self.indicate_connect setTitle:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"] forState:UIControlStateNormal];
            [self.indicate_connect setImage:[UIImage imageNamed:@"np_bluetooth_gray"] forState:UIControlStateNormal];
        }
    }
//    [self.mapView clear];
//    self.marker = nil;
//    self.marker.map = nil;
    [self loadlocation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self starLoaction];
    [self loadMyDevice];
//    [self loadhislocation];
    self.isreloadlocation = NO;
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"autolock"]isEqualToString:@"1"]) {
        self.isShow = YES;
    }
    self.isCurrenPageBluetoothOperation = YES;
    if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Disconnected" geStr:@"Disconnected"]]) {
        if (self.currentDeviceInfo != nil && [self.currentDeviceInfo.activation isEqualToString:@"3"]) {
            [self deailAutoConnect];
        }
    }
    if (self.isLock) {
        [self.timer setFireDate:[NSDate distantPast]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self changeUI];
    self.isShow = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[GYBabyBluetoothManager sharedManager]stopScanPeripheral];
    self.isCurrenPageBluetoothOperation = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.reconnect setFireDate:[NSDate distantFuture]];
}
- (void)didReciveBluetoothMessageAction:(NSNotification *)notify{
    if (!self.isCurrenPageBluetoothOperation) {
         return;
     }
  id obj = [[notify userInfo] objectForKey:@"type"];
    if([obj isEqual: @(PAWERSAVING_Bluetooth)]){
          [self.workMode setTitle:@" Pawersaving Mode " forState:UIControlStateNormal];
    }
}
#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        if ([UserInfo shareUserInfo].token == nil) {
            LoginController *loginVC = [LoginController new];
            loginVC.islogout = NO;
             loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if ([UserInfo shareUserInfo].userid != nil) {
               [self registerDevice:appDelegate.deviceToken identity:[NSString stringWithFormat:@"imei_%@",[UserInfo shareUserInfo].userid]];
            }

        }
       
        return;
    }
    NSArray *imageNameArray =  @[@"startup1",@"startup2",@"startup3"];
    NSArray *imageNameArray_iphoneX =  @[@"startup1_X",@"startup2_X",@"startup3_X"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight) imageNameArray:Device_iPhoneX ? imageNameArray_iphoneX : imageNameArray buttonIsHidden:NO backGronudImage:Device_iPhoneX ? @"guideImage_X":@"guideImage"];
    guidePage.slideInto = YES;
    [self.tabBarController.view addSubview:guidePage];
    kWeakSelf
    guidePage.dismiss = ^{
        LoginController *loginVC = [LoginController new];
         loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:loginVC animated:YES completion:nil];
    };
}

- (IBAction)addBike:(id)sender {
    MyDeviceController *VC = [[MyDeviceController alloc] init];
    VC.isNeedLoadDevice = NO;
    self.isShow = NO;
    self.isCurrenPageBluetoothOperation = NO;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark------//关闭防盗开关
- (void)closeRolloverwarning{
     NSString *url = host(@"users/closeSecurity");
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"imei":self.currentDeviceInfo.device_imei} success:^(NSDictionary * _Nonnull result) {
        if (![result[@"code"] isEqual:@"1"]) {
            if (![result[@"msg"] isEqual:@""]) {
//                [Toast showToastMessage:result[@"msg"]];
            }
        }
//        NSLog(@"setSecurity-------%@",result[@"msg"]);
        } fail:^(NSError * _Nonnull error) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}
#pragma mark------//开启防盗开关
- (void)openRolloverwarning{
    NSString *url = host(@"users/setSecurity");
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"imei":self.currentDeviceInfo.device_imei} success:^(NSDictionary * _Nonnull result) {
//           if (![result[@"code"] isEqual:@"1"]) {
//               if (![result[@"msg"] isEqual:@""]) {
//                   [Toast showToastMessage:result[@"msg"]];
//               }
//           }
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//           NSLog(@"%@",result[@"code"]);
//           NSLog(@"setSecurity-------%@",result[@"msg"]);
           } fail:^(NSError * _Nonnull error) {
           //        [MBProgressHUD hideHUDForView:self.view animated:YES];
           }];
}
#pragma mark------//手动锁车
- (IBAction)lockAction:(id)sender {
    self.lockBtn.userInteractionEnabled = NO;
       [self.lockBtn setBackgroundColor:[UIColor lightGrayColor]];
    //TODO
    self.isLock = !self.isLock;
    kWeakSelf
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(weakSelf.isLock){
            [self.timer setFireDate:[NSDate distantPast]];
            [self openLockalarm];
            [self.indicate_lock setTitle:[GlobalControlManger enStr:@"Secured" geStr:@"Secured"] forState:UIControlStateNormal];
            [self.indicate_lock setImage:[UIImage imageNamed:@"locked icon"] forState:UIControlStateNormal];
            [self.lockBtn setTitle:[GlobalControlManger enStr:@"UnlockBike" geStr:@"UnlockBike"]forState:UIControlStateNormal];
            [self.lockBtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        }else{
            [self.timer setFireDate:[NSDate distantFuture]];
            [self closeLockalarm];
            [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#4b4b4b"] forState:UIControlStateNormal];
            [self.indicate_lock setTitle:[GlobalControlManger enStr:@"Unsecured" geStr:@"Unsecured"] forState:UIControlStateNormal];
            [self.indicate_lock setImage:[UIImage imageNamed:@"unlocked icon"] forState:UIControlStateNormal];
            [self.lockBtn setTitle:[GlobalControlManger enStr:@"LockBike" geStr:@"LockBike"] forState:UIControlStateNormal];
            [self.lockBtn setImage:[UIImage imageNamed:@"unlcok"] forState:UIControlStateNormal];
        }
//        if (self.currentDeviceInfo.Id != nil) {
//           [self requestSetWaring];
//        }
    });
//    NSLog(@"%d",self.isLock);
}
#pragma mark------//关闭防盗
- (void)closeLockalarm{
//    [self.timer setFireDate:[NSDate distantFuture]];
    if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GYBabyBluetoothManager sharedManager]writeState:CLOSE_CAR_THIEF_Bluetooth];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [[GYBabyBluetoothManager sharedManager]writeState:CLOSE_CAR_Anti_theft_mode];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GYBabyBluetoothManager sharedManager]writeState:CLOSE_VIBRATION_Bluetooth];
        });
        });
        });
        [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_ROLLOVER_Bluetooth];
        
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lockBtn.userInteractionEnabled = YES;
        [self.lockBtn setBackgroundColor:[UIColor blackColor]];
            });
    }else{
       if (self.currentDeviceInfo.device_imei != nil && ![self.currentDeviceInfo.device_imei isEqualToString:@""]) {
            [self closeRolloverwarning];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           self.lockBtn.userInteractionEnabled = YES;
           [self.lockBtn setBackgroundColor:[UIColor blackColor]];
                  });
           return;
        }
    }
    
}
#pragma mark------//开启防盗
- (void)openLockalarm{
   
    if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
         [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#33B6F8"] forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_THIEF_Bluetooth];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_Anti_theft_mode];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[GYBabyBluetoothManager sharedManager]writeState:OPEN_CAR_VIBRATION_Bluetooth];
                });
            });
        });
        [[GYBabyBluetoothManager sharedManager]writeState:CLOSE_ROLLOVER_Bluetooth];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lockBtn.userInteractionEnabled = YES;
        [self.lockBtn setBackgroundColor:[UIColor blackColor]];
            });
        return;
    }else{
         [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#15BA39"] forState:UIControlStateNormal];
        if (self.currentDeviceInfo.device_imei != nil && ![self.currentDeviceInfo.device_imei isEqualToString:@""]) {
           [self openRolloverwarning];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.lockBtn.userInteractionEnabled = YES;
            [self.lockBtn setBackgroundColor:[UIColor blackColor]];
                   });
            return;
        }
    }
}
#pragma mark------//加载地图
- (void)initUI{
    [self accident];
    self.indicate_connect.userInteractionEnabled = NO;
    self.indicate_lock.userInteractionEnabled = NO;
    self.workMode.userInteractionEnabled = NO;
    self.cancelbtn.adjustsImageWhenHighlighted = YES;
    //x预定一个维度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
    longitude:151.2086
         zoom:16];
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight) camera:camera];
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;//是否启用指南针
    [self.view addSubview:_mapView];
    self.mapView.settings.myLocationButton = YES;
    self.mapView.padding = UIEdgeInsetsMake(0, 0, 225, 0);
    self.mapView.myLocationEnabled = YES;
    self.isreloadlocation = YES;
    self.heatMapLayer = [[GMUHeatmapTileLayer alloc] init];
        NSMutableArray* colors = @[].mutableCopy;
        [colors addObject:[UIColor colorWithHexString:@"#FFD800"]];
        [colors addObject:[UIColor
                           colorWithHexString:@"#F03F05"]];
    //赋值热力图的权重色值，权重从低到高
        self.heatMapLayer.gradient = [[GMUGradient alloc] initWithColors:colors startPoints:@[@0.01,@0.5] colorMapSize:256];
    //透明度，设置太高会遮住地图，太低会看不清
        self.heatMapLayer.opacity =0.7;
    //热力图半径，设置太高热力图会比较大，根据需求来自己调
        self.heatMapLayer.radius =25;
    NSOperationQueue* queue = [NSOperationQueue new];
        NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
            NSMutableArray* locationArr =@[].mutableCopy;
//            for (HeatMapLocation* location in self.locationCollection.orderCoordinates) {
//    //将经纬度和权重添加到数组中。intensity是权重
//                [locationArr addObject:[[GMUWeightedLatLng alloc] initWithCoordinate:CLLocationCoordinate2DMake(location.lat, location.lon) intensity:0.666]];
//            }
//            for (HeatMapLocation* location in self.locationCollection.cancelCoordinates) {
//                [locationArr addObject:[[GMUWeightedLatLng alloc] initWithCoordinate:CLLocationCoordinate2DMake(location.lat, location.lon) intensity:1]];
//            }
//            for (HeatMapLocation* location in self.locationCollection.openCoordinates) {
//                [locationArr addObject:[[GMUWeightedLatLng alloc] initWithCoordinate:CLLocationCoordinate2DMake(location.lat, location.lon) intensity:0.333]];
//            }
           //GMUWeightedLatLng
           dispatch_async(dispatch_get_main_queue(), ^{
               self.heatMapLayer.weightedData = locationArr;
               self.heatMapLayer.map =self.mapView;
          });
        }];
        [queue addOperation:operation];

//    [self lockbike];
//    CLLocationCoordinate2D position =  CLLocationCoordinate2DMake(51.5, -0.127);
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.title = @"Hello World";
//    marker.map = self.mapView;
//    marker.icon = [UIImage imageNamed:@"np_bicycle"];

    [self.view bringSubviewToFront:self.indicate_content];
    [self.view bringSubviewToFront:self.alarmView];
    [self.cancelbtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.cancelbtn setBackgroundImage:[self imageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
//    self.indicate_content.hidden = YES;
//    [self.mark addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goActive)]];
}
//地图移动后的代理方法，我这里的需求是地图移动需要刷新网络请求

-(void)mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition*)position{
    
//    [self requestWaring];
}
- (void)starLoaction{
    if (![CLLocationManager locationServicesEnabled]) {
         self.lat = self.lng = @"";
        NSLog(@"您的设备暂未开启定位服务");
        return;
    }
       // 2、初始化定位服务
       _locationManager = [[CLLocationManager alloc] init];
       // 3、请求定位授权*
       // 请求在使用期间授权（弹框提示用户是否允许在使用期间定位）,需添加NSLocationWhenInUseUsageDescription到info.plist
       [_locationManager requestWhenInUseAuthorization];
       // 请求在后台定位授权（弹框提示用户是否允许不在使用App时仍然定位）,需添加NSLocationAlwaysUsageDescription添加key到info.plist
       [_locationManager requestAlwaysAuthorization];
       // 4、设置定位精度
       _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       // 5、设置定位频率，每隔多少米定位一次
//       _locationManager.distanceFilter = 10.0;
       // 6、设置代理
       _locationManager.delegate = self;
       // 7、开始定位
       // 注意：开始定位比较耗电，不需要定位的时候最好调用 [stopUpdatingLocation] 结束定位。
       [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {
    if(!_firstLocationUpdate){
        _firstLocationUpdate = YES;//只定位一次的标记值
        // 获取最新定位
        CLLocation*location = locations.lastObject;
        // 打印位置信息
//        NSLog(@"经度：%.2f, 纬度：%.2f", location.coordinate.latitude,location.coordinate.longitude);
        self.lat = [NSString stringWithFormat:@"%.6f",location.coordinate.latitude];
        self.lng = [NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
        // 停止定位
        [_locationManager stopUpdatingLocation];
         [self loadCurentLocation];
        
//        self.coordinate2D = location.coordinate;
        self.coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        self.marker = [GMSMarker markerWithPosition:self.coordinate2D];
        //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
        _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D
                                                                               zoom:16];
//        [self.mapView clear];
        [self loadlocation];
        
    }
}
- (void)loadhislocation{
    NSString * url = host(@"bicycle/eq_gps");
    if ([MyDevicemanger shareManger].mainDevice.device_imei == nil) {
//        NSLog(@"没有主设备");
        return;
    }
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"id":[MyDevicemanger shareManger].mainDevice.device_imei,@"time":@""} success:^(NSDictionary * _Nonnull result) {
//        NSLog(@"历史位置%@",result);
        if ([result[@"code"]intValue]==1) {
            if (result[@"data"] != nil) {
                for (NSDictionary * dic  in result[@"data"]) {
                    NSDictionary * dict = @{@"position": [[CLLocation alloc]initWithLatitude:[dic[@"lat"] floatValue] longitude:[dic[@"lng"] floatValue]]};
                    [self.hisarray addObject:dict];
                }
                [self showhistory];
            }
        }
//        NSLog(@"%@",result[@"msg"]);
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)showhistory{
    if (self.hisarray == nil) {
        return;
    }
        for (NSDictionary* dictt in self.hisarray){
                                GMSMarker *marker = [[GMSMarker alloc] init];
                                marker.icon = [UIImage imageNamed:@"point"];
                                marker.position = [(CLLocation*)dictt[@"position"] coordinate];
                                marker.appearAnimation = kGMSMarkerAnimationPop;
                             marker.map = _mapView;
                         }
}
#pragma mark------//加载设备列表
- (void)loadMyDevice{
    self.name.text = [GlobalControlManger enStr:@"MyBike" geStr:@"MyBike"];
    NSString *url = host(@"bicycle/equimentList");
    if ([UserInfo shareUserInfo].token.length == 0 ) {
        return;
    }
//     NSLog(@"%@",  [UserInfo shareUserInfo].token);
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token};
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (stateCode == 1) {
//            NSLog(@"equimentList%@",result[@"data"][@"list"]);
            self.list = [BikeDeviceModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
            [MyDevicemanger shareManger].Devices = [self.list mutableCopy];
            if (self.list.count == 0) {//没有设备
                [self deailNoDeviceCase];
                return;
            }else{
                for (BikeDeviceModel *m in self.list) {
                    if ([MyDevicemanger shareManger].mainDevice == nil) {
                      if ([m.activation isEqualToString:@"3"]) { //发现主设备
                        self.currentDeviceInfo = m;
//                          [MyDevicemanger shareManger].mainDevice = m;
//                          if ([m.mac_id isEqualToString:self.currentDeviceInfo.mac_id]) {
                              if (![self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
                                  [self deailAutoConnect];
//                              }
                          }
//                          NSLog(@"发现主设备");
                      }else{
                          self.currentDeviceInfo = self.list.firstObject;
                      }
                    }else{
                        if ([m.activation isEqualToString:@"3"] && [m.is_default isEqualToString:@"2"] && [m.Id isEqualToString:[MyDevicemanger shareManger].mainDevice.Id]){
                            self.currentDeviceInfo = m;
//                          [MyDevicemanger shareManger].mainDevice = m;
                        }else{
                            self.currentDeviceInfo = self.list.firstObject;
//                            [MyDevicemanger shareManger].mainDevice = self.list.lastObject;
                        }
                    }
                }
                if ([self.currentDeviceInfo.activation isEqualToString:@"1"]) {
                   [self cancelNoDeviceViewDeactivated];
                }else if ([self.currentDeviceInfo.activation isEqualToString:@"2"]){
                }else if([self.currentDeviceInfo.activation isEqualToString:@"3"]){
                    [self cancelNoDeviceViewActivated];
                }
                 self.area.text = self.currentDeviceInfo.equipment;
                [MyDevicemanger shareManger].mainDevice = self.currentDeviceInfo;
                [self loadlocation];
//                return;
            }
           
//              [self loadlocation];
        }else{
            if (![msg isEqualToString:@""]) {
//                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark------//设置报警信息
-(void)requestSetWaring
{
    NSString *url = host(@"users/setDevicemsg");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:self.currentDeviceInfo.Id forKey:@"id"];
    [para setValue:self.isLock?@"2":@"1" forKey:@"is_alarm"];
       //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSInteger stateCode = [result[@"code"] integerValue];
    NSString *msg = result[@"msg"];
    if (stateCode == 1) {
        NSLog(@"开关");
//           self.showareaButton.enabled = YES;
    }else{
      if (![msg isEqualToString:@""]){
//         [Toast showToastMessage:msg];
      }
//         NSLog(@"setDevicemsg-----------%@",msg);
    }
    } fail:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark------//获取当前位置信息
- (void)loadCurentLocation{
    NSString * lattt = @"";
    NSString * longgg = @"";
    if ([self.indicate_connect.currentTitle isEqualToString:[GlobalControlManger enStr:@"Connected" geStr:@"Connected"]]) {
        lattt = self.lat;
        longgg = self.lng;
    }else{
    lattt = self.devicelat;
    longgg = self.devicelong;
    }
    NSLog(@"loadlocation   lat--%@  lng--%@",self.devicelat, self.devicelong);
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyABQXPBUnlE_DzVKG7ga0ZJhx9QmlygldU",lattt,longgg];
    [[NetworkingManger shareManger] postDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        self.currentLocationDetailInfo = [result[@"results"] firstObject];
//        NSLog(@"%@",result);
         NSString *currentLocationName = @"";
         NSArray *locationinfos = [[self.currentLocationDetailInfo[@"address_components"] reverseObjectEnumerator] allObjects];
        for (NSDictionary *dic in locationinfos) {
            if ([dic[@"types"] containsObject:@"postal_code"]){
                continue;
            }
            currentLocationName = [NSString stringWithFormat:@"%@,%@",dic[@"long_name"],currentLocationName];
        }
        if (currentLocationName.length > 1) {
            currentLocationName = [currentLocationName //替换某段字符
            stringByReplacingCharactersInRange:NSMakeRange(currentLocationName.length-1, 1) withString:@""];
        }
        NSLog(@"currentLocationName---------%@",currentLocationName);
        self.currentlocation = currentLocationName;
        if (currentLocationName == nil) {
            return;
        }
    } fail:^(NSError * _Nonnull error) {
        return;
    }];
}
#pragma mark------//获取位置信息
- (void)loadlocation{
     if (self.list.count == 0) {
         _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D
                                                                        zoom:16];
            return;
        }
    //  self.firstLocationUpdate = NO;
        if (self.currentDeviceInfo.Id == nil) {
            return;
        }
    if ([UserInfo shareUserInfo].token == nil) {
        return;
    }
//        NSLog(@"%@",self.currentDeviceInfo.Id);
        NSString *url = host(@"users/deviceSet");
        NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
        [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
        [para setValue:self.currentDeviceInfo.Id forKey:@"id"];
        [para setValue:self.lat forKey:@"lat"];
        [para setValue:self.lng forKey:@"lng"];
        [para setValue:self.currentlocation forKey:@"location"];
        //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                   NSInteger stateCode = [result[@"code"] integerValue];
                   NSString *msg = result[@"msg"];
                   NSDictionary * data =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       if (stateCode == 1){
                           self.devicelat = [data objectForKey:@"lat"];
                           self.devicelong = [data objectForKey:@"lng"];
                           CLLocation *location = [[CLLocation alloc] initWithLatitude:[[data objectForKey:@"lat"] floatValue ]longitude:[[data objectForKey:@"lng"] floatValue]];
                                  //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
                           [self.mapView clear];
//                           self.coordinate2D = location.coordinate;
                           self.coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
                                  //移动地图中心到当前位置
                           
                           self.marker.map = nil;
                           self.marker = nil;
                           self.marker = [GMSMarker markerWithPosition:self.coordinate2D];
    //                       marker.title = [GlobalControlManger enStr:@"Hello World" geStr:@"Hello World"];
                           if (![self.indicate_connect.currentTitle isEqualToString:@"Connected"]) {
                               
                               self.marker.map = self.mapView;
                               self.marker.icon = [UIImage imageNamed:@"home_bicycle"];
                               self->_mapView.camera = [GMSCameraPosition cameraWithTarget:self.coordinate2D
                                                                                                      zoom:16];
                           }else{
                               CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.lat floatValue] longitude:[self.lng floatValue]];
                               self.coordinate2D = location.coordinate;
                               self->_mapView.camera = [GMSCameraPosition cameraWithTarget:self.coordinate2D
                               zoom:16];
                           }
                           [self loadhislocation];
                           
                           }else{
                               if (![msg isEqualToString:@""]) {
//                                   NSLog(@"deviceSet--------------%@",msg);
//                                   [Toast showToastMessage:msg];
                               }
                           }
                                });
                   
                       } fail:^(NSError * _Nonnull error) {
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                       }];
}
#pragma mark------//获取电量信息
-(void)requestWaring
{
//    if (self.isreloadlocation) {
       
//    }
    if (self.list.count == 0) {
        return;
    }
//  self.firstLocationUpdate = NO;
    if (self.currentDeviceInfo.Id.length == 0) {
        return;
    }
    if ([UserInfo shareUserInfo].token.length == 0) {
        return;
    }
//    NSLog(@"%@",self.currentDeviceInfo.Id);
    NSString *url = host(@"users/deviceSet");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
//    NSLog(@"%@",[UserInfo shareUserInfo].token);
    [para setValue:self.currentDeviceInfo.Id forKey:@"id"];
//    NSLog(@"%@",self.currentDeviceInfo.Id);
    //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
//           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
//                 [MBProgressHUD hideHUDForView:self.view animated:YES];
               NSInteger stateCode = [result[@"code"] integerValue];
               NSString *msg = result[@"msg"];
               NSDictionary * data =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
                NSInteger is_effect = [[data objectForKey:@"is_effect"] intValue];
//                                   NSInteger is_fence = [[data objectForKey:@"is_fence"] intValue];
               //                   self.areaLabel.text = [data objectForKey:@"electronic_fence"];
//
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               if (stateCode == 1){
                   self.autolock = is_effect == 1?NO:YES;
//                   NSLog(@"%@",[data objectForKey:@"is_dormancy"]);
                   if (!self.isair) {
                       if ([[data objectForKey:@"is_dormancy"] integerValue]== 1) {
                           [self.workMode setTitle:[GlobalControlManger enStr:@"Sleep Mode" geStr:@"Sleep Mode"] forState:UIControlStateNormal];
                       }
                       else if ([[data objectForKey:@"is_dormancy"] integerValue]== 2){
                           
                           [self.workMode setTitle:[GlobalControlManger enStr:@"Normal Mode" geStr:@"Normal Mode"] forState:UIControlStateNormal];
                       }
                   }
                   [MyDevicemanger shareManger].mainDevice.is_autolock = is_effect == 1?NO:YES;
//                   NSLog(@"electric%@",[data objectForKey:@"electric"]);
                                     if ([[data objectForKey:@"electric"] integerValue] > 75 && [[data objectForKey:@"electric"] integerValue] <= 100) {
                                         self.batteryLevel = BatteryLevel5;
                                     }else if ([[data objectForKey:@"electric"] integerValue] > 50 && [[data objectForKey:@"electric"] integerValue] <= 75){
                                         self.batteryLevel = BatteryLevel4;
                                     }else if ([[data objectForKey:@"electric"] integerValue] > 30 && [[data objectForKey:@"electric"] integerValue] <= 50){
                                         self.batteryLevel = BatteryLevel3;
                                     }else if ([[data objectForKey:@"electric"] integerValue] > 15 && [[data objectForKey:@"electric"] integerValue] <= 30){
                                         self.batteryLevel = BatteryLevel2;
                                     }else if ([[data objectForKey:@"electric"] integerValue] > 0 && [[data objectForKey:@"electric"] integerValue] <= 15){
                                         self.batteryLevel = BatteryLevel1;
                                     }
                                     if (![[data objectForKey:@"electric"] isEqualToString: @""]) {
                                          self.levelstring =[NSString stringWithFormat:@"%@%%",[data objectForKey:@"electric"]];
                                         [self setbuttonImage];
                                     }
               }else{
                   if (![msg isEqualToString:@""]) {
//                       NSLog(@"deviceSet--------------%@",msg);
//                       [Toast showToastMessage:msg];
                   }
               }
                    });
           } fail:^(NSError * _Nonnull error) {
//               [MBProgressHUD hideHUDForView:self.view animated:YES];
               
           }];
}
#pragma mark------//激活成功
- (void)activatesuccess{
    [self loadMyDevice];
     [self unlockbike];
    [self showconnect];
   
//    [self.mapView clear];
//       self.marker = nil;
//       self.marker.map = nil;
       [self loadlocation];
}
- (void)hiddenView{
    for (UIView *subView in self.indicate_content.subviews) {
        if (subView.tag == 1000) {
            subView.hidden = YES;
        }
        if (subView.tag == 1113 || subView.tag == 1111 || subView.tag == 1112 ) {
            subView.hidden = NO;
        }
    }
}
#pragma mark------//未激活
- (void)cancelNoDeviceViewDeactivated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mark.hidden = NO;
        self.activate_button.hidden = NO;
        self.lockBtn.hidden = YES;
        self.mark.text = [GlobalControlManger enStr:@"deactivated" geStr: @"deactivated"];
        [self.activate_button setTitle:[GlobalControlManger enStr:@"Activate Now ?" geStr:@"Activate Now ?"] forState:UIControlStateNormal];
        self.indicate_lock.hidden = YES;
        self.indicate_connect.hidden = YES;
        self.indicate_battery.hidden = YES;
        self.workMode.hidden = YES;
        self.add.hidden = YES;
        self.indicate_level.hidden = YES;
        [self hiddenView];
    });
//    self.mark.userInteractionEnabled = YES;
}
#pragma mark------//已激活
- (void)cancelNoDeviceViewActivated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      self.mark.hidden = YES;
      self.activate_button.hidden = YES;
      self.lockBtn.hidden = NO;
      self.indicate_connect.hidden = NO;
      self.workMode.hidden = NO;
      self.mark.hidden = YES;
      self.indicate_lock.hidden = NO;
      self.add.hidden = YES;
      [self hiddenView];
      [self requestWaring];
//        [self.mapView clear];
//        self.marker = nil;
//        self.marker.map = nil;
//        [self loadlocation];
        self.bluename = self.currentDeviceInfo.photo;
    return;
   });
//    self.mark.userInteractionEnabled = YES;
}
#pragma mark------//锁车
- (void)lockbike{
    self.isLock = YES;
     [self.timer setFireDate:[NSDate distantPast]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openLockalarm];
            [self.indicate_lock setTitle:[GlobalControlManger enStr:@"Secured" geStr:@"Secured"] forState:UIControlStateNormal];
            [self.indicate_lock setImage:[UIImage imageNamed:@"locked icon"] forState:UIControlStateNormal];
            [self.lockBtn setTitle:[GlobalControlManger enStr:@"UnlockBike" geStr:@"UnlockBike"]forState:UIControlStateNormal];
            [self.lockBtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        return;
    });
}
#pragma mark------//解锁车
- (void)unlockbike{
   self.isLock = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
    self.lockBtn.userInteractionEnabled = NO;
    [self.lockBtn setBackgroundColor:[UIColor lightGrayColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeLockalarm];
        [self.indicate_lock setTitleColor:[UIColor colorWithHexString:@"#4b4b4b"] forState:UIControlStateNormal];
        [self.indicate_lock setTitle:[GlobalControlManger enStr:@"Unsecured" geStr:@"Unsecured"] forState:UIControlStateNormal];
        [self.indicate_lock setImage:[UIImage imageNamed:@"unlocked icon"] forState:UIControlStateNormal];
        [self.lockBtn setTitle:[GlobalControlManger enStr:@"LockBike" geStr:@"LockBike"] forState:UIControlStateNormal];
        [self.lockBtn setImage:[UIImage imageNamed:@"unlcok"] forState:UIControlStateNormal];
        return;
    });
}
#pragma mark------//没有车
- (void)deailNoDeviceCase{
//    [Toast showToastMessage:@"no deveice please add first" inview:self.view interval:3];
    
    for (UIView *subView in self.indicate_content.subviews) {
        subView.hidden = YES;
    }
    self.add = [UIButton buttonWithType:UIButtonTypeCustom];
    _add.tag = 1000;
    _add.backgroundColor = [UIColor redColor];
    [self.indicate_content addSubview:_add];
    [_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.indicate_content);
        make.top.equalTo(self.indicate_content).offset(Adaptive(74));
        make.width.equalTo(@(244));
        make.height.equalTo(@(48));
    }];
    _add.layer.cornerRadius = Adaptive(4);
    [_add setImage:[UIImage imageNamed:@"add_circle"] forState:UIControlStateNormal];
    [_add setTitle:[GlobalControlManger enStr: @"Add A New Device" geStr: @"Add A New Device"] forState:UIControlStateNormal];
    _add.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:self.indicate_content];
    [[_add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoAdd;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
#pragma mark------//自动连接
- (void)deailAutoConnect{
//    return;
    //扫描到蓝牙设备 自动连接主设备
    self.isAutoConnect = YES;
    self.isCurrenPageBluetoothOperation = YES;
    //系统蓝牙是否已经打开
    if (self.babyMgr.systemBluetoothIsOpen) {
        [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
        [self.babyMgr stopScanPeripheral];
        [self.babyMgr startScanPeripheral];
//        self.firstLocationUpdate = NO;
//        for (UIView * map in self.mapView.subviews) {
//               [self starLoaction];
//               [map reloadInputViews];
//           }
    }else{
       //系统蓝牙未开启
    }
}
#pragma mark------//蓝牙状态更新
- (void)bluetoothDeviceListUpdate:(NSNotification *)notify{
    
//     [Toast showToastMessage:@"The device did not wake up, please try again later" inview:self.view];
    if (!self.isCurrenPageBluetoothOperation) {
        return;
    }
    NSArray <GYPeripheralInfo *>*peripheralInfoArr = notify.object;
   self.bluetoothList = peripheralInfoArr;
                    for (GYPeripheralInfo *info in peripheralInfoArr) {
                        if ([[self macstring:info.advertisementData] isEqualToString:self.currentDeviceInfo.mac_id]) {
                            //连接蓝牙
                             self.currentConnectDevice = info;
                            [self.babyMgr connectPeripheral:info.peripheral];
                        }
                    }
}
//读取设备的物理地址
-(NSString *)macstring:(NSDictionary *)advertisementData
{
    NSData*data = advertisementData[@"kCBAdvDataManufacturerData"];
    return [self convertDataToHexStr:data];
}
//转化为string
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    NSString * strippedBbox= [NSString new];
    if([[NSString stringWithFormat:@"%@",[string class]] isEqualToString:@"__NSCFString"]){
        NSData* xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
        strippedBbox = [[NSString alloc] initWithData:xmlData  encoding:NSUTF8StringEncoding]; ;
    }
    return string;
}
#pragma mark------//蓝牙电量
- (void)setBatteryLevel:(BatteryLevel)batteryLevel{
//    self.indicate_battery.hidden = NO;
    _batteryLevel = batteryLevel;
    if (batteryLevel == BatteryLevel1) {
        self.levelstring = @"15%";
        [self.indicate_battery setImage:[UIImage imageNamed:@"Battery15%"] forState:UIControlStateNormal];
    }else if (batteryLevel == BatteryLevel2){
        self.levelstring = @"30%";
        [self.indicate_battery setImage:[UIImage imageNamed:@"Battery30%"] forState:UIControlStateNormal];
    }else if (batteryLevel == BatteryLevel3){
        self.levelstring = @"50%";
         [self.indicate_battery setImage:[UIImage imageNamed:@"Battery50%"] forState:UIControlStateNormal];
    }else if (batteryLevel == BatteryLevel4){
        self.levelstring = @"75%";
         [self.indicate_battery setImage:[UIImage imageNamed:@"Battery80%"] forState:UIControlStateNormal];
    }else if (batteryLevel == BatteryLevel5){
        self.levelstring = @"100%";
         [self.indicate_battery setImage:[UIImage imageNamed:@"Battery100%"] forState:UIControlStateNormal];
    }

}
#pragma mark------//激活
- (IBAction)goactivate:(UIButton *)sender {
    BlueBindingViewController *VC = [[BlueBindingViewController alloc] init];
    VC.activeBike = self.currentDeviceInfo;
    self.isCurrenPageBluetoothOperation = NO;
    if (self.bluename != nil) {
        VC.bluename = self.bluename;
    }
    [self.reconnect setFireDate:[NSDate distantFuture]];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)cancelalarm:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    self.cancelbtn.userInteractionEnabled = NO;
    if (self.currentDeviceInfo.isConnecting) {
        [[GYBabyBluetoothManager sharedManager]writeState:NOT_WARING_Bluetooth];
    }else{
        [self setCancelalarm];
    }
}
#pragma mark------//断开蓝牙
- (IBAction)Disblue:(UIButton *)sender {
//    if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
//        [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
//        [self.babyMgr stopScanPeripheral];
//    }
//    if (self.indicate_connect.selected == NO) {
//           self.indicate_connect.userInteractionEnabled = NO;
//
//
//    }else{
//           self.indicate_connect.userInteractionEnabled = YES;
//
//
//    }
//    if (self.indicate_connect.selected == YES) {
//        NSLog(@"蓝牙断开");
//        [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
//        [self.babyMgr stopScanPeripheral];
//
//    }
}
- (void)setCancelalarm{
//if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
//    NSString * i_mei = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_imei"];
    if (self.currentDeviceInfo.device_imei == nil) {
        return;
    }
    
    if ([UserInfo shareUserInfo].token == nil) {
        return;
    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:host(@"/users/setCancelalarm") para:@{@"imei":self.currentDeviceInfo.device_imei,@"token":[UserInfo shareUserInfo].token,@"id":@"",@"is_theft":self.is_theft} success:^(NSDictionary * _Nonnull result) {
//        self.alarmView.backgroundColor = [UIColor whiteColor];
//        self.cancelbtn.userInteractionEnabled = YES;
//        NSLog(@"%@",result);
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg inview:self.view];
        }
       } fail:^(NSError * _Nonnull error) {
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSLog(@"%@",error);
//           [Toast showToastMessage:@"" inview:self.view];
       }];
//}
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
   CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
   UIGraphicsBeginImageContext(rect.size);
   CGContextRef context=UIGraphicsGetCurrentContext();
   CGContextSetFillColorWithColor(context, [color CGColor]);
   CGContextFillRect(context, rect);
   
   UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return image;
}
@end
