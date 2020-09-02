//
//  BlueToothAlertManger.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "BlueToothAlertManger.h"

@implementation BlueToothAlertManger

+ (BlueToothAlertManger *)shareManger{
    static dispatch_once_t onceToken;
    static BlueToothAlertManger *userinfo;
    dispatch_once(&onceToken, ^{
        userinfo = [[BlueToothAlertManger alloc] init];
    });
    return userinfo;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)startMonitor{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:GYBabyBluetoothManagerWaring object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showAlert:(NSNotification *)notify{
    
    NSString *readString = notify.object;

     if ([readString hasPrefix:@"55550a10"]) {
                /**
                2.3.1 震动告警
                通知:0x10,0x0001,0x01
                回复:0x10,0x0001,0x01
                */
         [BlueToothAlert showAlertWith:NormalWaring Clcik:^(BlueToothAlertType type) {
              [[GYBabyBluetoothManager sharedManager] writeState:VIBRATION_Bluetooth];
         }];
            }else if ([readString hasPrefix:@"55550a2f"]){
                /**
                 打开设备的 GPS 开关(用于骑行中上报车辆位置信息)
                 请求:0x2F,0x0001,0x03,0x01,0x01 // 0x01 : 打开,其他为关闭告警开关
                 回复:0x2F,0x0001,0x01
                 */

                
            }
            else if ([readString hasPrefix:@"55550a12"]){
             //[readString isEqualToString:@"55550a1800020111AAAA"]
              
                /**
                2.3.3 电子围栏告警
                 通知：0x12,0x0001,0x01
                 回复：0x12,0x0001,0x01
                 */
//              [BlueToothAlert showAlertWith:ElectricFence Clcik:^(BlueToothAlertType type) {
//                   [[GYBabyBluetoothManager sharedManager] writeState:ELECTRONIC_FENCE_Bluetooth];
//              }];
            }else if([readString hasPrefix:@"55550a18"]){
             //[readString isEqualToString:@"55550a1800020111AAAA"]
              
                /**
                 2.3.4 低电告警
                 通知:0x18,0x0001,0x01 回复:0x18,0x0001,0x01
                 */
                [BlueToothAlert showAlertWith:LowBatteryRemian30 Clcik:^(BlueToothAlertType type) {
                     [[GYBabyBluetoothManager sharedManager] writeState:BATTERY_LOW_Bluetooth];
                }];


            }else if ([readString hasPrefix:@"55550a19"]){
                /**
                 2.3.5 GPS 长时间不定位告警 通知:0x19,0x0001,0x01
                 回复:0x19,0x0001,0x01
                 */

            }else if ([readString hasPrefix:@"55550a1b"]){
                /**

                 2.3.7 翻车告警 通知:0x1B,0x0001,0x01
                 回复:0x1B,0x0001,0x01
                 */
                [BlueToothAlert showAlertWith:NormalWaring Clcik:^(BlueToothAlertType type) {
                     [[GYBabyBluetoothManager sharedManager] writeState:ROLLOVER_Bluetooth];
                }];
                
            }else if ([readString hasPrefix:@"55550b11"]){
                //盗车警告
                [BlueToothAlert showAlertWith:NormalWaring Clcik:^(BlueToothAlertType type) {
                     [[GYBabyBluetoothManager sharedManager] writeState:CAR_THIEF_Bluetooth];
                }];
            }

    if ([[notify.userInfo objectForKey:@"type"] isEqual:@(BATTERY_LOW_Bluetooth)]) { //低电告警 //低电量 (根据需求是否要弹出alert)
        //eg
        [BlueToothAlert showAlertWith:LowBatteryRemian30 Clcik:^(BlueToothAlertType type) {
             [self requestSetCancelalarm];
        }];

    }else if ([[notify.userInfo objectForKey:@"type"] isEqual:@(CAR_THIEF_Bluetooth)]){//震动告警/盗车告警

        [BlueToothAlert showAlertWith:NormalWaring Clcik:^(BlueToothAlertType type) {

            [self requestSetCancelalarm];
        }];
    }else if ([[notify.userInfo objectForKey:@"type"] isEqual:@(AUTHEBTICATION_Bluetooth)]){//蓝牙鉴权失败

        [BlueToothAlert showAlertWith:BluetoothLow Clcik:^(BlueToothAlertType type) {

            }];
    }else if ([[notify.userInfo objectForKey:@"type"] isEqual:@(ELECTRONIC_FENCE_Bluetooth)]){//电子围栏

        [BlueToothAlert showAlertWith:ElectricFence Clcik:^(BlueToothAlertType type) {
            [self requestSetCancelalarm];

            }];
    }
   
    
}


//取消告警
-(void)requestSetCancelalarm
{
    
    NSString *url = host(@"users/setCancelalarm");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:[GYBabyBluetoothManager sharedManager].getIMEI forKey:@"imei"];
    
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        
        if (stateCode == 1) {
            
            
            [[GYBabyBluetoothManager sharedManager] writeState:NOT_WARING_Bluetooth];
            
        }else{
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

@end
