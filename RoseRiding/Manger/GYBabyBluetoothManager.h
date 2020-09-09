//
//  GYBabyBluetoothManager.h
//  RoseRiding
//
//  Created by mac on 2020/4/21.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYPeripheralInfo.h"
NS_ASSUME_NONNULL_BEGIN




// 设置蓝牙的前缀【开发者必须改为自己的蓝牙设备前缀】
#define kMyDevicePrefix (@"LP")
// 设置蓝牙的channel值【开发者可不做修改】
#define channelOnPeropheralView @"peripheralView"
#define GYBabyBluetoothManagerConnectFailed @"GYBabyBluetoothManagerConnectFailed"  //蓝牙链接失败
#define GYBabyBluetoothManagerConnectSuccess @"GYBabyBluetoothManagerConnectSuccess" //蓝牙连接成功
#define GYBabyBluetoothManagerConnectDismiss @"GYBabyBluetoothManagerConnectDismiss" //蓝牙断开连接
#define GYBabyBluetoothManagerRead @"GYBabyBluetoothManagerRead"  //收到蓝牙发送过来的信息
#define GYBabyBluetoothManagerDevicesListUpdate @"GYBabyBluetoothManagerDevicesListUpdate"  //扫描蓝牙设备列表更新
#define GYBabyBluetoothManagerNoDeviceFound @"GYBabyBluetoothManagerNoDeviceFound"  //扫描不到蓝牙设备
#define GYBabyBluetoothManagerSetGeoFence @"GYBabyBluetoothManagerSetGeoFence"//设置电子围栏成功
#define GYBabyBluetoothManagerWaring @"GYBabyBluetoothManagerWaring"  // 告警
#define GYBabyBluetoothMangerBatteryLevel @"GYBabyBluetoothMangerBatteryLevel"  // 电量
#define GYBabyBluetoothManagerActivate @"GYBabyBluetoothManagerActivateFailed"//蓝牙激活失败
#define GYBabyBluetoothMangerOpenSuccess @"GYBabyBluetoothMangerOpenSuccess"//电子围栏打开
#define GYBabyBluetoothMangerOpenCartheftSuccess @"GYBabyBluetoothMangerOpenCartheftSuccess"//盗车开关
#define GYBabyBluetoothMangerOpenCarRolloverSuccess @"GYBabyBluetoothMangerOpenCarRolloverSuccess"//翻车开关
#define GYBabyBluetoothManagerOpenCarVibartion @"GYBabyBluetoothManagerOpenCarVibartion"//震动开关
#define GYBabyBluetoothManagertheftover @"GYBabyBluetoothManagertheftover" //盗车结束
#define GYBabyBluetoothManagerVIBRATION_Bluetooth @"GYBabyBluetoothManagerVIBRATION_Bluetooth"//震动告警
/**
 蓝牙消息类型
 */
typedef NS_ENUM(
NSUInteger, BluetoothType) {
    DEFAULT_Bluetooth = 0,
    IMEI_Bluetooth = 1,
    ICCID_Bluetooth = 2,
    AUTHEBTICATION_Bluetooth= 3, //蓝牙鉴权
    VIBRATION_Bluetooth =4, // 震动告警
    GPS_NOT_POST_Bluetooth=5,  //GPS 长时间不定位告警
    GPS_SRTART_Bluetooth = 6,//   打开设备的 GPS 开关(用于骑行中上报车辆位置信息)
    NOT_WARING_Bluetooth = 7,   // 取消告警
    BATTERY_LOW_Bluetooth = 8,    //低电告警
    ROLLOVER_Bluetooth= 9,  //翻车警告
    LOOKING_CAR_Bluetooth = 10,  //找车
    AIRPLANE_MODE_Bluetooth =11,//开启飞行
    CAR_THIEF_Bluetooth = 12,  //盗车告警
    UnKonwnMessageType = 13 ,  //未知警告消息
    BEEP_TIME_INTERVAL = 14, //设置蜂鸣器时间
    BATTERY_LEVEL = 15, //电量信息
    ELECTRONIC_FENCE_Bluetooth = 16,//电子围栏告警
    SET_ELECTRONIC_FENCE_Bluetooth = 17,//设置电子围栏
    PAWERSAVING_Bluetooth = 18,//省电模式
    CLOSE_CAR_THIEF_Bluetooth = 19,//关闭盗车警告
    CLOSE_ROLLOVER_Bluetooth = 20,//关闭翻车警告
    CLOSE_VIBRATION_Bluetooth = 21,//关闭震动警告
    OPEN_CAR_THIEF_Bluetooth = 22,//打开盗车告警
    OPEN_CAR_ROLLOVER_Bluetooth = 23,//打开翻车告警
    OPEN_ELECTRONIC_FENCE_Bluetooth = 24,//打开电子围栏
    CLOSE_ELECTRONIC_FENCE_Bluetooth = 25,//关闭电子围栏
    OPEN_AUTOLOCK_Bluetooth = 26,//打开自动开启防盗模式开关
    OPEN_PAWERSAVING_Bluetooth = 27,//打开省电模式
    CLOSE_PAWERSAVING_Bluetooth = 28,//关闭省电模式
    OPEN_CAR_VIBRATION_Bluetooth = 29,//打开震动告警
    OPEN_CAR_Anti_theft_mode = 30,//打开防盗模式
    CLOSE_CAR_Anti_theft_mode = 31,//关闭防盗模式
    CLOSE_AUTOLOCK_Bluetooth = 32,//关闭自动上锁
    GEOFEN_Bluetooth = 33//电子围栏告警
    
};

@protocol GYBabyBluetoothManagerDelegate <NSObject>

@optional

/**
 蓝牙被关闭
 */
- (void)systemBluetoothClose;


/**
 蓝牙已开启
 */
- (void)sysytemBluetoothOpen;


/**
 扫描到的设备回调
 
 @param peripheralInfoArr 扫描到的蓝牙设备数组
 */
- (void)getScanResultPeripherals:(NSArray <GYPeripheralInfo *>*)peripheralInfoArr;


/**
 连接成功
 */
- (void)connectSuccess;


/**
 连接失败
 */
- (void)connectFailed;


/**
 当前断开的设备
 
 @param peripheral 断开的peripheral信息
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;


- (void)disconnectAllPeripherals;


/**
 读取蓝牙数据
 
 @param valueData 蓝牙设备发送过来的data数据
 */
- (void)readData:(NSData *)valueData;

/**
 接收到的命令  用于调试蓝牙通知的参数
 
 @param string 接收到的指令
 */
- (void)getBLue:(NSString *)string;

@end

typedef void(^GYBabyBluetoothManagerDidReciveMessage)(BluetoothType bluetoothType,NSString *message);


@interface GYBabyBluetoothManager : NSObject

@property (nonatomic, strong) BabyBluetooth    *babyBluetooth;
//扫描到的外设设备数组
@property (nonatomic, strong) NSMutableArray   *peripheralArr;
//写数据特征值
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
//读数据特征值
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
//当前连接的外设设备
@property (nonatomic, strong) CBPeripheral     *currentPeripheral;

@property (nonatomic, assign) BOOL systemBluetoothIsOpen;


//蓝牙消息类型
@property (nonatomic,assign) BluetoothType bluetoohh_type;


//外设的服务UUID值
@property (nonatomic, copy) NSString *serverUUIDString;
//外设的写入UUID值
@property (nonatomic, copy) NSString *writeUUIDString;
//外设的读取UUID值
@property (nonatomic, copy) NSString *readUUIDString;

@property (nonatomic, copy) GYBabyBluetoothManagerDidReciveMessage reciveMessage;
/**
 单例
 
 @return 单例对象
 */
+ (GYBabyBluetoothManager *)sharedManager;


@property (nonatomic, weak) id<GYBabyBluetoothManagerDelegate> delegate;


/**
 开始扫描周边蓝牙设备
 */
- (void)startScanPeripheral;


/**
 停止扫描
 */
- (void)stopScanPeripheral;


/**
 连接所选取的蓝牙外设
 
 @param peripheral 所选择蓝牙外设的perioheral
 */
-(void)connectPeripheral:(CBPeripheral *)peripheral;


/**
 获取当前连接成功的蓝牙设备数组
 
 @return 返回当前所连接成功蓝牙设备数组
 */
- (NSArray *)getCurrentPeripherals;


/**
 获取设备的服务跟特征值
 当已连接成功时调用有效
 */
- (void)searchServerAndCharacteristicUUID;


/**
 断开当前连接的所有蓝牙设备
 */
- (void)disconnectAllPeripherals;


/**
 断开所选择的蓝牙设备
 
 @param peripheral 所选择蓝牙外设的perioheral
 */
- (void)disconnectLastPeripheral:(CBPeripheral *)peripheral;

/**
 向蓝牙设备发送数据
 
 @param msgData 数据data值
 */
- (void)write:(NSData *)msgData;


/**
 向蓝牙发送数据
 
 @param type 发送蓝牙命令类型
 */
-(void)writeState:(BluetoothType)type;
-(void)writeState:(BluetoothType)type widthFence:(NSString*)fence andLng:(NSString*)lng andLat:(NSString*)lat andImei:(NSString*)imei;



-(NSString *)getIMEI;
-(NSString *)getICCD;
-(NSString *)getIMEIHash;
-(NSString *)getBLUENAME;
- (NSString *)gettimestr:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
