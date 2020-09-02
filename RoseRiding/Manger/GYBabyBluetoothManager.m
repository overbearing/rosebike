//
//  GYBabyBluetoothManager.m
//  RoseRiding
//
//  Created by mac on 2020/4/21.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "GYBabyBluetoothManager.h"
#import<CommonCrypto/CommonDigest.h>
#import "NSString+ZXXExtension.h"

@interface GYBabyBluetoothManager  ()
{
  
    NSString * IMEIHash ,*IMEI, * ICCD , *BLUENAME;
    NSString * waringString;
    NSString * levelString;
}

@end

@implementation GYBabyBluetoothManager

uint8_t CalcCrc( uint8_t* data, uint32_t size) {
    int i = 0; uint8_t crc= 0;
    /* Verify the input parameters. */ if (data != NULL && size > 0)
    {
        for (i = 0; i < size; i++)
        {
            crc ^= data[i];
            
        }
    }
    return crc;

}

uint8_t equalHash(uint8_t *array1, uint8_t *array2, uint8_t len) {
      uint8_t i;

    for (i = 0; i < len; i++) {
       if (array1[i] != array2[i]) {
           return FALSE;
       }
     }
    return TRUE;
}

///lazy
- (NSMutableArray *)peripheralArr {
    if (!_peripheralArr) {
        _peripheralArr = [NSMutableArray new];
    }
    return _peripheralArr;
}


+ (GYBabyBluetoothManager *)sharedManager {
    static GYBabyBluetoothManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GYBabyBluetoothManager alloc] init];
    });
    return instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initBabyBluetooth];
    }
    return self;
}


- (void)initBabyBluetooth {
    self.babyBluetooth = [BabyBluetooth shareBabyBluetooth];
    [self babyBluetoothDelegate];
}

-(NSString *)getIMEI
{
    NSLog(@"发送前IMEI %@",IMEI);
    return IMEI;
}
-(NSString *)getICCD
{
    NSLog(@"发送前ICCD %@",ICCD);
    return ICCD;
}
-(NSString *)getBLUENAME{
    NSLog(@"bluename%@",BLUENAME);
    return BLUENAME;
}

#pragma mark 蓝牙配置
- (void)babyBluetoothDelegate {
    __weak typeof(self) weakSelf = self;
    
    // 1-系统蓝牙状态
    [self.babyBluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 从block中取到值，再回到主线程
          
            if ([weakSelf respondsToSelector:@selector(systemBluetoothState:)]) {
            
                if (@available(iOS 10.0, *)) {
                    [weakSelf systemBluetoothState:central.state];
                } else {
                    // Fallback on earlier versions
                }
              
            }
        });
    }];
    
    // 2-设置查找设备的过滤器
    [self.babyBluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
            
            // 最常用的场景是查找某一个前缀开头的设备
         if ([[advertisementData objectForKey:@"kCBAdvDataLocalName"] hasPrefix:kMyDevicePrefix] || [[advertisementData objectForKey:@"kCBAdvDataLocalName"] hasPrefix:@"B910"]) {
           
//            NSLog(@"设备名称 == %@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]);
            return YES;
         }
        }
        // 最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:kMyDevicePrefix] || [peripheralName hasPrefix:@"B910"]) {
            return YES;
        }
        return NO;
    }];
    
    // 查找的规则
    [self.babyBluetooth setFilterOnDiscoverPeripheralsAtChannel:channelOnPeropheralView
                                                         filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
            
            // 最常用的场景是查找某一个前缀开头的设备
         if ([[advertisementData objectForKey:@"kCBAdvDataLocalName"] hasPrefix:kMyDevicePrefix] || [[advertisementData objectForKey:@"kCBAdvDataLocalName"] hasPrefix:@"B910"]) {
           
//            NSLog(@"设备名称 == %@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]);
            return YES;
         }
        }
            // 最常用的场景是查找某一个前缀开头的设备
        if ([peripheralName hasPrefix:kMyDevicePrefix] || [peripheralName hasPrefix:@"B910"]) {
            return YES;
        }
            return NO;
        }];    
    //设置连接规则
    [self.babyBluetooth setFilterOnConnectToPeripheralsAtChannel:channelOnPeropheralView
                                                          filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
                                                              return NO;
                                                          }];
    //2.1-设备连接过滤器
    [self.babyBluetooth setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //不自动连接
        return NO;
    }];
//    
    //3-设置扫描到设备的委托
    [self.babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 从block中取到值，再回到主线程
            if ([weakSelf respondsToSelector:@selector(scanResultPeripheral: advertisementData: rssi:)]) {
                [weakSelf scanResultPeripheral:peripheral advertisementData:advertisementData rssi:RSSI];
            }
        });
    }];
    
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    //4-设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.babyBluetooth setBlockOnConnectedAtChannel:channelOnPeropheralView
                                               block:^(CBCentralManager *central, CBPeripheral *peripheral) {
                                                   NSLog(@"【HKBabyBluetooth】->连接成功");
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       // 从block中取到值，再回到主线程
                                                       if ([weakSelf respondsToSelector:@selector(connectSuccess)]) {
                                                           [weakSelf connectSuccess];
                                                       }
                                                   });
                                               }];
    // 5-设置设备连接失败的委托
    [self.babyBluetooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView
                                                   block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
                                                       NSLog(@"【HKBabyBluetooth】->连接失败");
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           // 从block中取到值，再回到主线程
                                                           if ([weakSelf respondsToSelector:@selector(connectFailed)]) {
                                                               [weakSelf connectFailed];
                                                           }
                                                       });
                                                   }];
    // 6-设置设备断开连接的委托
    [self.babyBluetooth setBlockOnDisconnectAtChannel:channelOnPeropheralView
                                                block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
                                                    NSLog(@"【HKBabyBluetooth】->设备：%@断开连接",peripheral.name);
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        // 从block中取到值，再回到主线程
                                                        if ([weakSelf respondsToSelector:@selector(disconnectPeripheral:)]) {
                                                            [weakSelf disconnectPeripheral:peripheral];
                                                            [MBProgressHUD hideLoadingHUD];
                                                        }
                                                    });
                                                }];
    // 7-设置发现设备的Services的委托
    [self.babyBluetooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView
                                                      block:^(CBPeripheral *peripheral, NSError *error) {
                                                          [rhythm beats];
                                                      }];
    // 8-设置发现设service的Characteristics的委托
    [self.babyBluetooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView
                                                             block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
                                                                 NSString *serviceUUID = [NSString stringWithFormat:@"%@",service.UUID];
        weakSelf.serverUUIDString =serviceUUID;
//        NSLog(@"serviceUUID == %@",serviceUUID);
//                                                                 if ([serviceUUID isEqualToString:weakSelf.serverUUIDString]) {
                                                                     for (CBCharacteristic *ch in service.characteristics) {
                                                                         // 写数据的特征值
                                                                         NSString *chUUID = [NSString stringWithFormat:@"%@",ch.UUID];
//                                                                        NSLog(@"UUID == %@",chUUID);
                                                                         if ([chUUID hasPrefix:@"02362A10"]) {
                                                                             weakSelf.writeUUIDString = chUUID;
                                                                              weakSelf.writeCharacteristic = ch;
                                                                             
//                                                                              NSLog(@"writeUUIDString == %@",chUUID);
//
                                                                         }
                                                                         if ([chUUID hasPrefix:@"02362A11"]) {
                                                                             weakSelf.readUUIDString = chUUID;
                                                                             weakSelf.readCharacteristic = ch;
                                                                             
                                                                             [weakSelf.currentPeripheral setNotifyValue:YES
                                                                             forCharacteristic:weakSelf.readCharacteristic];
                                                                            
//                                                                             NSLog(@"readUUIDString == %@",chUUID);
                                                                         }
                                                                         
//                                                                         if ([chUUID isEqualToString:weakSelf.writeUUIDString]) {
//                                                                             weakSelf.writeCharacteristic = ch;
//                                                                         }
                                                                         
                                                                  
//                                                                          读数据的特征值
//                                                                         if ([chUUID isEqualToString:weakSelf.readUUIDString]) {
//                                                                             weakSelf.readCharacteristic = ch;
//
//                                                                         }
                                                                     }
//                                                                 }
                                                             }];
    
    // 9-设置读取characteristics的委托
    [self.babyBluetooth setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView
                                                                block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        // 从block中取到值，再回到主线程
                                                                        if ([weakSelf respondsToSelector:@selector(readData:)]) {
                                                                            [weakSelf readData:characteristics.value];
                                                                        }
                                                                    });
                                                                }];
    
    // 设置发现characteristics的descriptors的委托
    [self.babyBluetooth setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView
                                                                          block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) { }];
    
    // 设置读取Descriptor的委托
    [self.babyBluetooth setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView
                                                             block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {

    }];
    
    // 读取rssi的委托
    [self.babyBluetooth setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) { }];
    
    // 设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) { }];
    
    // 设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) { }];
    
    // 扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [self.babyBluetooth setBabyOptionsAtChannel:channelOnPeropheralView
                  scanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                   connectPeripheralWithOptions:connectOptions
                 scanForPeripheralsWithServices:nil
                           discoverWithServices:nil
                    discoverWithCharacteristics:nil];
    
    // 连接设备
    [self.babyBluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                                           connectPeripheralWithOptions:nil
                                         scanForPeripheralsWithServices:nil
                                                   discoverWithServices:nil
                                            discoverWithCharacteristics:nil];
}

#pragma mark 对蓝牙操作
/// 蓝牙状态


- (void)systemBluetoothState:(CBManagerState)state  API_AVAILABLE(ios(10.0)) {
    if (state == CBManagerStatePoweredOn) {
        if ([self.delegate respondsToSelector:@selector(sysytemBluetoothOpen)]) {
            [self.delegate sysytemBluetoothOpen];
        }
        self.systemBluetoothIsOpen = YES;
    }else if (state == CBManagerStatePoweredOff) {
        if ([self.delegate respondsToSelector:@selector(systemBluetoothClose)]) {
            [self.delegate systemBluetoothClose];
        }
        [self.babyBluetooth cancelAllPeripheralsConnection];
        self.systemBluetoothIsOpen = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerConnectDismiss object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@(self.bluetoohh_type),@"type", nil] ];
         
    }
}

/// 开始扫描
- (void)startScanPeripheral {
    self.babyBluetooth.scanForPeripherals().begin();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"30");
        if (self.peripheralArr.count == 0) {
               [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerNoDeviceFound object:nil];
        }
    });
}
/// 扫描到的设备[由block回主线程]
- (void)scanResultPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)RSSI {
    for (GYPeripheralInfo *peripheralInfo in self.peripheralArr) {
        if ([peripheralInfo.peripheral.identifier isEqual:peripheral.identifier]) {
            return;
        }
    }
    GYPeripheralInfo *peripheralInfo = [[GYPeripheralInfo alloc] init];
    peripheralInfo.peripheral = peripheral;
    peripheralInfo.advertisementData = advertisementData;
    peripheralInfo.RSSI = RSSI;
    [self.peripheralArr addObject:peripheralInfo];
    
    if ([self.delegate respondsToSelector:@selector(getScanResultPeripherals:)]) {
        [self.delegate getScanResultPeripherals:self.peripheralArr];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerDevicesListUpdate object:self.peripheralArr];
}
/// 停止扫描
- (void)stopScanPeripheral {
    [self.peripheralArr removeAllObjects];
    [self.babyBluetooth cancelScan];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerConnectFailed object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@(self.bluetoohh_type),@"type", nil] ];
}


/// 连接设备
-(void)connectPeripheral:(CBPeripheral *)peripheral {
    // 断开之前的所有连接
    [self.babyBluetooth cancelAllPeripheralsConnection];
    self.currentPeripheral = peripheral;
    self.babyBluetooth.having(peripheral).and.channel(channelOnPeropheralView).
    then.connectToPeripherals().discoverServices().
    discoverCharacteristics().readValueForCharacteristic().
    discoverDescriptorsForCharacteristic().
    readValueForDescriptors().begin();
}


/// 连接成功[由block回主线程]
- (void)connectSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerConnectSuccess object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@(self.bluetoohh_type),@"type", nil] ];
}
/// 连接失败[由block回主线程]
- (void)connectFailed {
//    if ([self.delegate respondsToSelector:@selector(connectFailed)]) {
//        [self.delegate connectFailed];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerConnectFailed object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@(self.bluetoohh_type),@"type", nil] ];
}
/// 获取当前断开的设备[由block回主线程]
- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
//    if ([self.delegate respondsToSelector:@selector(disconnectPeripheral:)]) {
//        [self.delegate disconnectPeripheral:peripheral];
//    }
      [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerConnectDismiss object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@(self.bluetoohh_type),@"type", nil] ];
}
/// 获取当前连接
- (NSArray *)getCurrentPeripherals {
    return [self.babyBluetooth findConnectedPeripherals];
}
///获取设备的服务跟特征值[当已连接成功时]
- (void)searchServerAndCharacteristicUUID {
    self.babyBluetooth.having(self.currentPeripheral).and.channel(channelOnPeropheralView).
    then.connectToPeripherals().discoverServices().discoverCharacteristics()
    .readValueForCharacteristic().discoverDescriptorsForCharacteristic().
    readValueForDescriptors().begin();
}
///断开所有连接
- (void)disconnectAllPeripherals {
    [self.babyBluetooth cancelAllPeripheralsConnection];
}
///断开当前连接
- (void)disconnectLastPeripheral:(CBPeripheral *)peripheral {
    [self.babyBluetooth cancelPeripheralConnection:peripheral];
}
///发送数据
- (void)write:(NSData *)msgData {
    if (self.writeCharacteristic == nil) {
        NSLog(@"【HKBabyBluetooth】->数据发送失败");
        return;
    }
        //若最后一个参数是CBCharacteristicWriteWithResponse
    //则会进入setBlockOnDidWriteValueForCharacteristic委托
    [self.currentPeripheral writeValue:msgData
                     forCharacteristic:self.writeCharacteristic
                                  type:CBCharacteristicWriteWithoutResponse];
}
-(void)writeState:(BluetoothType)type widthFence:(NSString*)fence andLng:(NSString*)lng andLat:(NSString*)lat andImei:(NSString*)imei{
    NSString * str;
    NSString * fen;
    NSString * Lng ;
    NSString * Lat ;
    NSString * Lngg;
    NSString * Latt;
    NSArray *array = [lng componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    NSString * newlng = @"";
    for (int i = 0 ;i<array.count; i++) {
            newlng = [newlng stringByAppendingFormat:@"%@", [array objectAtIndex:i]];
       }
    NSArray *array1 = [lat componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
    NSString * newlat = @"";
    for (int i = 0 ;i<array1.count; i++) {
            newlat = [newlat stringByAppendingFormat:@"%@", [array1 objectAtIndex:i]];
       }
    if ([newlat hasPrefix:@"-"]) {
        newlat=[newlat stringByReplacingOccurrencesOfString:@"-"withString:@""];
        Latt = @"1";
    }else{
        Latt = @"0";
    }
    if ([newlng hasPrefix:@"-"]){
        newlng = [newlng stringByReplacingOccurrencesOfString:@"-" withString:@""];
        Lngg = @"1";
    }else{
        Lngg = @"0";
    }
    
    NSString * lnglat = [NSString stringWithFormat:@"%@%@00",Lngg,Latt];
    lnglat = [self twoConvertSixteen:lnglat];
    Lng = [self hexStringFromString:newlng];
    Lat = [self hexStringFromString:newlat];
    fen =  [self hexStringFromString:fence];
    if (type == SET_ELECTRONIC_FENCE_Bluetooth) {
        str = [NSString stringWithFormat: @"5555272f000106080001010000%@000%@%@%@000000000000000001",lnglat,Lat,Lng,fen];
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"%@%lxAAAA",str,(long)ints];
        
//        NSLog(@"%@",str);
//        NSLog(@"%@,%@,%@,%@",Lat,Lng,fen,str);
   }
    if (str != nil) {
    //        NSLog(@"----------------%@",str);
        if ([str isEqualToString:@"0"]) {
            return;
        }
        if (imei.length <= 0) {
            return;
        }
            [[NetworkingManger shareManger] postDataWithUrl:host(@"users/bluetoothMsg") para:@{@"msg":str,@"imei":imei} success:^(NSDictionary * _Nonnull result) {
    //            NSLog(@"%@",result[@"code"]);
//                if(![result[@"msg"] isEqualToString:@""]){
//                    [Toast showToastMessage:result[@"msg"]];
//                }
               
            } fail:^(NSError * _Nonnull error) {
                
            }];
        }
    if ([str isEqualToString:@"0"]) {
        return;
    }
        NSData *data = [self convertHexStrToData:str];
        
        [self write:data];
}

-(NSString*)twoConvertSixteen:(NSString*)string{

NSString* strTen =[NSString stringWithFormat:@"%lu", strtoul ( [string UTF8String],0,2)];

int num = [strTen intValue];

NSString* sixTeenString = [NSString stringWithFormat:@"%x",num];

return sixTeenString;

}

/**
 发送数据
 */
-(void)writeState:(BluetoothType)type
{
//     self.bluetoohh_type = type;
    NSString * str;
    if (type == DEFAULT_Bluetooth) {
        return;
    }
    if(type == IMEI_Bluetooth)
    {
       self.bluetoohh_type = type;
        str =@"55550A010001010BAAAA";
        self.bluetoohh_type = type;
    }else if(type == ICCID_Bluetooth){
        self.bluetoohh_type = type;
        str =@"55550A0200010108AAAA";
    }else if (type == AUTHEBTICATION_Bluetooth)
    {
        self.bluetoohh_type = type;
        if (IMEIHash.length <= 0) {
            NSLog(@"IMEI不合法");
            [MBProgressHUD hideLoadingHUD];
            return;
        }
        str = [NSString stringWithFormat:@"55550A030001%@01AAAA",IMEIHash];
        
        NSData *datas = [self convertHexStrToData:str];
        
        NSInteger length =datas.length;
        str = [NSString stringWithFormat:@"5555%lx030001%@",(unsigned long)length,IMEIHash];
               
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        
        str = [NSString stringWithFormat:@"5555%lx030001%@%lxAAAA",(unsigned long)datas.length,IMEIHash,(long)ints];
    }
//    else if (type == VIBRATION_Bluetooth) {
//        /**
//                2.3.1 震动告警
//                通知:0x10,0x0001,0x01
//                回复:0x10,0x0001,0x01
//                */
//        str =waringString;
//
//    }
    else if (type == CLOSE_VIBRATION_Bluetooth) {
        /**
              2.4.6.2 打开震动告警开关 // 0x00关闭/0x01打开
               请求：0x2F,0x0001, 0x02,0x01,0x01 // 0x01 : 打开告警开关,其他为关闭告警开关
               回复：0x2F,0x0001,0x02,0x01
                */
        str = @"55550C2f0001020001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001020001%lxAAAA",(long)ints];

    }else if (type == OPEN_CAR_VIBRATION_Bluetooth) {
        /**
              2.4.6.2 打开震动告警开关 // 0x00关闭/0x01打开
               请求：0x2F,0x0001, 0x02,0x01,0x01 // 0x01 : 打开告警开关,其他为关闭告警开关
               回复：0x2F,0x0001,0x02,0x01
                */
        str = @"55550C2f0001020101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001020101%lxAAAA",(long)ints];

    }else if (type == CLOSE_ROLLOVER_Bluetooth) {
        /**
              2.4.6.11 打开翻车告警开关//关闭
              请求：0x2F,0x0001, 0x0b,0x01,0x01 //0x01: 打开
              回复：0x2F,0x0001,0x0b,0x01
                */
        str = @"55550C2f00010b0001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f00010b0001%lxAAAA",(long)ints];

    }else if(type == OPEN_AUTOLOCK_Bluetooth){
        /**
         2.4.6.10 打开自动开启防盗模式开关
        请求：0x2F,0x0001, 0x0a,0x01,0x01 //0x01: 打开
        回复：0x2F,0x0001,0x0a,0x01
         */
        
        str = @"55550C2f00010a0101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f00010a0101%lxAAAA",(long)ints];
        
    }else if(type == CLOSE_AUTOLOCK_Bluetooth){
        /**
         2.4.6.10 关闭自动开启防盗模式开关
        请求：0x2F,0x0001, 0x0a,0x01,0x01 //0x01: 打开
        回复：0x2F,0x0001,0x0a,0x01
         */
        
        str = @"55550C2f00010a0001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f00010a0001%lxAAAA",(long)ints];
        
    }else if (type == OPEN_CAR_ROLLOVER_Bluetooth) {
        /**
              2.4.6.11 打开翻车告警开关//打开
              请求：0x2F,0x0001, 0x0b,0x01,0x01 //0x01: 打开
              回复：0x2F,0x0001,0x0b,0x01
                */
        str = @"55550C2f00010b0101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f00010b0101%lxAAAA",(long)ints];

    }else if (type == CLOSE_CAR_THIEF_Bluetooth) {
        /**
              2.4.6.7 打开盗车告警开关//关闭
              请求：0x2F,0x0001, 0x07,0x00,0x01 // 0x00 : 打开
              回复：0x2F,0x0001,0x07,0x01
                */
      
          str = @"55550C2f0001070101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001070101%lxAAAA",(long)ints];

    }else if (type == OPEN_CAR_THIEF_Bluetooth) {
        /**
              2.4.6.7 打开盗车告警开关//打开
              请求：0x2F,0x0001, 0x07,0x00,0x01 // 0x00 : 打开
              回复：0x2F,0x0001,0x07,0x01
                */
      
          str = @"55550C2f0001070001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001070001%lxAAAA",(long)ints];

    }else if (type == NOT_WARING_Bluetooth)
    {
        /**
         取消告警 请求:0x24,0x0001,0x01
         回复:0x24,0x0001,0x01
        
         */
        str = @"55550A24000101";

        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];

        str = [NSString stringWithFormat:@"55550A24000101%lxAAAA",(long)ints];

        
    }else if (type == GPS_SRTART_Bluetooth)
    {
        /**
         打开设备的 GPS 开关(用于骑行中上报车辆位置信息)
         请求:0x2F,0x0001,0x03,0x01,0x01 // 0x01 : 打开,其他为关闭告警开关 回复:0x2F,0x0001,0x01
         */
    }else if (type == OPEN_PAWERSAVING_Bluetooth )
    {
        /**
         2.4.6.4 打开省电模式
         请求：0x2F,0x0001, 0x04,0x01,0x01 // 0x01 : 打开
         回复：0x2F,0x0001,0x04,0x01
         */
        str = @"55550C2f0001040101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001040101%lxAAAA",(long)ints];
        
    }else if (type == CLOSE_PAWERSAVING_Bluetooth )
    {
        /**
         2.4.6.4 关闭省电模式
         请求：0x2F,0x0001, 0x04,0x01,0x01 // 0x00 : 关闭
         回复：0x2F,0x0001,0x04,0x01
         */
        str = @"55550a2f0001040001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001040001%lxAAAA",(long)ints];
        
    }else if (type == OPEN_ELECTRONIC_FENCE_Bluetooth)
    {
        /**
      2.4.6.8 打开电子围栏开关
       请求：0x2F,0x0001, 0x08,0x01,0x01 // 0x01 : 打开
       回复：0x2F,0x0001,0x08,0x01
         */
         str = @"55550C2f0001080101";
         NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
         str = [NSString stringWithFormat:@"55550C2f0001080101%lxAAAA",(long)ints];
    }
    else if (type == CLOSE_ELECTRONIC_FENCE_Bluetooth)
    {
        /**
      2.4.6.8 关闭电子围栏开关
       请求：0x2F,0x0001, 0x08,0x01,0x01 // 0x01 : 打开
       回复：0x2F,0x0001,0x08,0x01
         */
         str = @"55550C2f0001080001";
         NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
         str = [NSString stringWithFormat:@"55550C2f0001080001%lxAAAA",(long)ints];
    }else if (type == BATTERY_LOW_Bluetooth)
    {
        /**
         2.3.4 低电告警
         通知:0x18,0x0001,0x01
         回复:0x18,0x0001,0x01
         */
        str =waringString;
    }else if (type == GPS_NOT_POST_Bluetooth){
        /**
         2.3.5 GPS 长时间不定位告警
         通知:0x19,0x0001,0x01
         回复:0x19,0x0001,0x01
         */
        str =waringString;
    }else if (type == ROLLOVER_Bluetooth){
        str = waringString;
    }else if (type == LOOKING_CAR_Bluetooth){
        /**
         2.4.1 找车 请求:0x20,0x0001,0x01
         回复:0x20,0x0001,0x01
         */
        str = @"55550A20000101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550A20000101%lxAAAA",(long)ints];
    }else if (type ==AIRPLANE_MODE_Bluetooth){
        /**
         2.4.2 打开飞行模式
         请求:0x21,0x0001,0x01
         回复:0x21,0x0001,0x01
         */
        str = @"55550A21000101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550A21000101%lxAAAA",(long)ints];

    }else if (type ==OPEN_CAR_Anti_theft_mode){
        /**
         2.4.6.17 蓝牙设防
         请求：0x2F,0x0001, 0x11,0x01,0x01// 0x01 打开设防开关
         回复：0x2F,0x0001,0x11,0x01
         */
        str = @"55550C2f0001110101";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001110101%lxAAAA",(long)ints];

    }else if (type ==CLOSE_CAR_Anti_theft_mode){
        /**
         2.4.6.17 蓝牙设防
         请求：0x2F,0x0001, 0x11,0x01,0x01// 0x01 关闭设防开关
         回复：0x2F,0x0001,0x11,0x01
         */
        str = @"55550C2f0001110001";
        NSInteger ints = [self contentCheckValue:[self convertHexStrToData:str]];
        str = [NSString stringWithFormat:@"55550C2f0001110001%lxAAAA",(long)ints];

    }
    if (![str isEqualToString:@""]  && str.length> 0) {
//        NSLog(@"----------------%@",str);
        if ([str hasPrefix:@"0000000000000000000000000000000000000000"]) {
            NSLog(@"imei不合法");
            return;
        }
        if (IMEI.length != 0) {
            [[NetworkingManger shareManger] postDataWithUrl:host(@"users/bluetoothMsg") para:@{@"msg":str,@"imei":IMEI} success:^(NSDictionary * _Nonnull result) {
            } fail:^(NSError * _Nonnull error) {
            }];
        }
    }
    NSData *data = [self convertHexStrToData:str];
    [self write:data];
}
- (int)contentCheckValue:(NSData *)contentData {
    
    Byte *testByte = (Byte *)[contentData bytes];
    int checksum = 0;
    for(int i=0; i<[contentData length]; i++) {
        checksum ^= testByte[i];
    }
    return checksum;
}

/**
 十六进制转NSData
 */
-(NSData *)convertHexStrToData:(NSString*)str
{
    if (!str || [str length] == 0)

        return nil ;

    NSMutableData *hexData = [ [NSMutableData alloc] initWithCapacity:8];
    NSRange  range;
    if ([str length] %2 == 0)
    {

       range = NSMakeRange(0, 2);
    }else
    {
      range = NSMakeRange(0, 1);
    }



   for (NSInteger i = range.location; i < [str length]; i += 2)
   {
       unsigned int anInt;
      NSString *hexCharStr = [str substringWithRange:range];
      NSScanner *scanner = [[NSScanner alloc] initWithString : hexCharStr];
      [scanner scanHexInt:&anInt] ;

      NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
       [hexData appendData:entity];
       
       range.location +=range.length;
       range.length = 2;

   }

    NSLog (@"hexdata: %@", hexData);
    return hexData;
}
//电子围栏转16进制
- (NSString *)convertDataToHexString:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = byteRange.length-1; i >=0 ; i--) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
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
//读取数据
- (void)readData:(NSData *)valueData {
    NSString * readString=  [self convertDataToHexStr:valueData];
    NSLog(@"readstring --- %@",readString);
    if (![readString isEqualToString:@""]  && readString.length> 0){
        if ([MyDevicemanger shareManger].mainDevice.device_imei.length != 0) {
           [[NetworkingManger shareManger] postDataWithUrl:host(@"users/bluetoothMsg") para:@{@"back_msg":readString, @"imei":[MyDevicemanger shareManger].mainDevice.device_imei} success:^(NSDictionary * _Nonnull result) {
//               NSLog(@"bluetoothMsg-------%@",readString);
           } fail:^(NSError * _Nonnull error) {
           }];
        }
    }
//    if ([readString intValue] == 0) {
//        return;
//    }
    if (valueData.length >= 9 && readString.length > 0) {
        if ([readString hasPrefix:@"55550a10"]) {
            /**
            2.3.1 震动告警
            通知:0x10,0x0001,0x01
            回复:0x10,0x0001,0x01
            */
//          self.bluetoohh_type = VIBRATION_Bluetooth;
            waringString =readString;
           UILocalNotification *localNotice = [UILocalNotification new];
             //                localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
           localNotice.alertBody = [GlobalControlManger enStr:@"ALERT: Your bike has detected a vibration while is it connected to your phone via Bluetooth. We suggest you check your bike for security reasons." geStr:@"ALERT: Your bike has detected a vibration while is it connected to your phone via Bluetooth. We suggest you check your bike for security reasons."];
           localNotice.alertTitle =  [GlobalControlManger enStr:@"Bike Vibration Alarm - Bluetooth" geStr:@"Bike Vibration Alarm - Bluetooth"];
//            NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
//            badge += 1;
//              localNotice.applicationIconBadgeNumber = badge;
              [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
//             [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerVIBRATION_Bluetooth object:nil];
            [self waringNotif:readString];
        }else if ([readString hasPrefix:@"55550a2f"]){
            /**
             打开设备的 GPS 开关(用于骑行中上报车辆位置信息)
             请求:0x2F,0x0001,0x03,0x01,0x01 // 0x01 : 打开,其他为关闭告警开关
             回复:0x2F,0x0001,0x01
             */
//            self.bluetoohh_type = GPS_SRTART_Bluetooth;
            [self waringNotif:readString];
            
        }else if ([readString hasPrefix:@"55550a18"]){
         //[readString isEqualToString:@"55550a1800020111AAAA"]
            /**
             2.3.4 低电告警
             通知:0x18,0x0001,0x01 回复:0x18,0x0001,0x01
             */
//            self.bluetoohh_type = BATTERY_LOW_Bluetooth;
            waringString =readString;
            [self waringNotif:readString];
            [[NetworkingManger shareManger] postDataWithUrl:host(@"users/updateMode") para:@{@"id":@"3",@"inc_type":@"1"} success:^(NSDictionary * _Nonnull result) {
            } fail:^(NSError * _Nonnull error) {
            }];
        }else if ([readString hasPrefix:@"55550a19"]){
            /**
             2.3.5 GPS 长时间不定位告警 通知:0x19,0x0001,0x01
             回复:0x19,0x0001,0x01
             */
//            self.bluetoohh_type =GPS_NOT_POST_Bluetooth;
            waringString = readString;
            [self waringNotif:readString];
        }else if([readString hasPrefix:@"55550a12"]){
            /**
             2.3.3 电子围栏告警
             通知：0x12,0x0001,0x01
             回复：0x12,0x0001,0x01
             */
            waringString =readString;
            UILocalNotification *localNotice = [UILocalNotification new];
                        //                localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
                      localNotice.alertBody = [GlobalControlManger enStr:@"ALERT: Your bike has registered a geofence alarm that your bike has left the designated area." geStr:@"ALERT: Your bike has registered a geofence alarm that your bike has left the designated area."];
                      localNotice.alertAction =  [GlobalControlManger enStr:@"Geofence Alarm - Bluetooth" geStr:@"Geofence Alarm - Bluetooth"];
//                       NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
//                       badge += 1;
//                         localNotice.applicationIconBadgeNumber = badge;
                         [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
            [self waringNotif:readString];
        }
        else if ([readString hasPrefix:@"55550a1b"]){
            /**
             2.3.7 翻车告警 通知:0x1B,0x0001,0x01
             回复:0x1B,0x0001,0x01
             */
//             self.bluetoohh_type = ROLLOVER_Bluetooth;
             waringString =readString;
            [self waringNotif:readString];
            
        }else if ([readString hasPrefix:@"55550b11"]){
//            self.bluetoohh_type = CAR_THIEF_Bluetooth;
            waringString =readString;
            
        }else if ([readString hasPrefix:@"55550a24"]){
//            self.bluetoohh_type = NOT_WARING_Bluetooth;
            waringString =readString;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"nowarning" object:nil];
        }else if([readString hasPrefix:@"55550a21"]){
            //飞行模式
            waringString = readString;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"enterairplanemode" object:nil];
        }
        else if ([readString hasPrefix:@"55550a020"]){
        //            self.bluetoohh_type = LOOKING_CAR_Bluetooth;
                    
            waringString = readString;
                    
        }else if ([readString hasPrefix:@"55550a12"]){
//                    self.bluetoohh_type = ELECTRONIC_FENCE_Bluetooth;
           /**
            2.3.3 电子围栏告警  通知：0x12,0x0001,0x01
            回复：0x12,0x0001,0x01
            */
            waringString = readString;
        }else if ([readString hasPrefix:@"55550b11"]){
             NSString *targetStr = [readString substringWithRange:NSMakeRange(12, 2)];
//            NSLog(@"targetstr%@",targetStr);
            if (![targetStr isEqualToString:@"01"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagertheftover object:nil];
            }
            /*
             2.3.2 盗车告警
             回复:0x11,0x0001,0x01,0x01   //0x01开始
             */            
        }else if([readString hasPrefix:@"55550b2f"]){
            NSString *targetStr = [readString substringWithRange:NSMakeRange(12, 2)];
//            NSLog(@"targetStr--------------%@",targetStr);
            NSString *OnroOff = [readString substringWithRange:NSMakeRange(14, 2)];
//            NSLog(@"OnroOff----------------%@",OnroOff);
            if ([targetStr isEqualToString:@"08"]) {//电子围栏开关
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothMangerOpenSuccess object:OnroOff];
            }else if ([targetStr isEqualToString:@"07"]){//盗车开关
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothMangerOpenCartheftSuccess object:OnroOff];
            }else if ([targetStr isEqualToString:@"0b"]){//翻车开关
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothMangerOpenCarRolloverSuccess object:OnroOff];
            }else if([targetStr isEqualToString:@"06"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerSetGeoFence object:nil];
            }else if([targetStr isEqualToString:@"02"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerOpenCarVibartion object:OnroOff];
            }
        }else if ([readString hasPrefix:@"555518010001"]){
//            self.bluetoohh_type = IMEI_Bluetooth;
        }else if ([readString hasPrefix:@"55551d020001"]){
//            self.bluetoohh_type = ICCID_Bluetooth;
        }else if ([readString hasPrefix:@"55550b1c"]){
//            self.bluetoohh_type = BATTERY_LEVEL;
            NSString *targetStr = [readString substringWithRange:NSMakeRange(12, 2)];
            NSInteger level = 0;
//            NSLog(@"targetStr        %@",targetStr);
            if ([targetStr isEqualToString:@"00"]) {
                level = 1;
            }else if ([targetStr isEqualToString:@"01"]){
                level = 2;
            }else if ([targetStr isEqualToString:@"02"]){
                level = 3;
            }else if ([targetStr isEqualToString:@"03"]){
                level = 4;
            }else if ([targetStr isEqualToString:@"04"]){
                level = 5;
            }
            levelString = [NSString stringWithFormat:@"%lu",(long)level];
            [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothMangerBatteryLevel object:@(level)];
        }else{
            if (self.bluetoohh_type == IMEI_Bluetooth && [readString containsString:@"0000000000000000000000000000000000000000"]){
               
                [self writeState:IMEI_Bluetooth];
                return;
            }else{
                
            }
        }
//        //收到该类蓝牙命令 需要主动回复该类型消息 否则蓝牙会重复发送该类命令
//        if (self.bluetoohh_type == BATTERY_LOW_Bluetooth || self.bluetoohh_type ==VIBRATION_Bluetooth || self.bluetoohh_type ==CAR_THIEF_Bluetooth || self.bluetoohh_type ==GPS_NOT_POST_Bluetooth || self.bluetoohh_type ==ROLLOVER_Bluetooth || self.bluetoohh_type == NOT_WARING_Bluetooth) {
//             NSLog(@"告警信息 == %@",readString);
//            [self waringNotif];
//        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:GYBabyBluetoothManagerActivate object:nil];
       return;
    }
    
    if (self.bluetoohh_type == IMEI_Bluetooth) {
        
        if (readString.length < 6) {
            return;
        }
        NSString * ox =[readString substringWithRange:NSMakeRange(4, 2)];
        if (strtoul(ox.UTF8String, 0, 16) != valueData.length || valueData.length <23) {
//            [self writeState:IMEI_Bluetooth];
            NSLog(@"IMEI不合法");
            [MBProgressHUD hideLoadingHUD];
            return;
        }
        if (readString.length == 0) {
//            [self writeState:IMEI_Bluetooth];
            NSLog(@"IMEI获取失败");
            return;
        }
        readString = [self getIMEI:readString];
        
        NSLog(@"IMEI值为 == %@",readString);
        NSString * strippedBbox = [readString stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [readString length])];
        IMEI =[self stringFromHexString:strippedBbox];
        NSMutableString * reverseString = [NSMutableString string];
        for(int i = 0 ; i < strippedBbox.length/2; i ++){
            //倒序读取字符并且存到可变数组数组中
            NSString * c =[strippedBbox substringWithRange:NSMakeRange(strippedBbox.length-(2*(i+1)), 2)];
            [reverseString appendFormat:@"%@",c];
        }
        strippedBbox = reverseString;
//        NSLog(@"反序之后的值为 == %@",strippedBbox);
        reverseString = [NSMutableString string];
        for(int i = 0 ; i < strippedBbox.length/2; i++){
            //倒序读取字符并且存到可变数组数组中
            NSString * c =[strippedBbox substringWithRange:NSMakeRange(i*2, 2)];
            
            if (i == 1) {
                [reverseString appendFormat:@"%@",[strippedBbox substringWithRange:NSMakeRange(strippedBbox.length -4, 2)]];
            }else if (i == 2)
            {
                [reverseString appendFormat:@"%@",[strippedBbox substringWithRange:NSMakeRange(strippedBbox.length -2, 2)]];
            }
            else if (i == (strippedBbox.length/2)-2)
            {
                [reverseString appendFormat:@"%@",[strippedBbox substringWithRange:NSMakeRange(2, 2)]];
            }
            else if (i == (strippedBbox.length/2)-1)
            {
                [reverseString appendFormat:@"%@",[strippedBbox substringWithRange:NSMakeRange(4, 2)]];
            }else
            {
                [reverseString appendFormat:@"%@",c];
            }
            
        }
        
        strippedBbox = reverseString;
        
//        NSLog(@"反序交替位置之后的值为 == %@",strippedBbox);
        
        NSString * liu = [self stringFromHexString:strippedBbox];
        
        NSString * hash = [self sha1:liu];
        
        IMEIHash =hash;
        
//        NSLog(@"hash值 == \n%@",hash);
        
        
    }else if (self.bluetoohh_type == ICCID_Bluetooth)
    {
        NSString * _bbox =[self convertDataToHexStr:valueData];
        
        if (_bbox.length < 6) {
            return;
        }
        NSString * ox =[_bbox substringWithRange:NSMakeRange(4, 2)];
        if (strtoul(ox.UTF8String, 0, 16) != valueData.length || valueData.length <23) {
            
            NSLog(@"ICCID不合法");
            return;
        }
        if (_bbox.length == 0) {
            NSLog(@"ICCID获取失败");
            return;
        }
//        NSLog(@"iccid十六进制str == %@",[self getICCD:_bbox]);
        ICCD = [self stringFromHexString:[self getICCD:_bbox] ];
//        NSLog(@"ICCID数据解析 == %@ \n 提取之后的值 == %@",[self convertDataToHexStr:valueData],ICCD);
        
    }else if (self.bluetoohh_type == AUTHEBTICATION_Bluetooth || self.bluetoohh_type == NOT_WARING_Bluetooth || self.bluetoohh_type == LOOKING_CAR_Bluetooth || self.bluetoohh_type == AIRPLANE_MODE_Bluetooth ||self.bluetoohh_type == PAWERSAVING_Bluetooth){
        
        NSString * content =[self convertDataToHexStr:valueData];
      
        if (content.length < 14 ) {
            
//            [self waringNotif];
            //                    NSLog(@"失败");
            return;
        }
        NSString * auth =[content substringWithRange:NSMakeRange(12, 2)];
        if ([auth isEqualToString:@"00"]) {
            NSLog(@"成功");
        } else {
//            [self waringNotif];
            //                     NSLog(@"失败");
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerRead object:nil userInfo:[NSDictionary dictionaryWithObject:@(self.bluetoohh_type) forKey:@"type"]];
}
//告警通知
-(void)waringNotif:(NSString *)readStr
{
      [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerWaring object:nil userInfo:[NSDictionary dictionaryWithObject:@(self.bluetoohh_type) forKey:@"type"]];
    if (self.bluetoohh_type == AUTHEBTICATION_Bluetooth) { //蓝牙授权失败通知

          [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerWaring object:nil userInfo:[NSDictionary dictionaryWithObject:@(self.bluetoohh_type) forKey:@"type"]];
    } else if(self.bluetoohh_type == BATTERY_LOW_Bluetooth){ //低电告警通知

         [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerWaring object:nil userInfo:[NSDictionary dictionaryWithObject:@(self.bluetoohh_type) forKey:@"type"]];
    }else if (self.bluetoohh_type == VIBRATION_Bluetooth || self.bluetoohh_type == CAR_THIEF_Bluetooth) //盗车 震动
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerWaring object:nil];
    }
//    else if(self.bluetoohh_type == ELECTRONIC_FENCE_Bluetooth){//电子围栏
//         [[NSNotificationCenter defaultCenter] postNotificationName:GYBabyBluetoothManagerWaring object:nil];
//
//    }
}
//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(NSString *)string{
    
    int intstr = [string intValue];
    NSData *nsstr = [NSData dataWithBytes: &intstr length:sizeof(intstr)];
//    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    hexStr = [self convertDataToHexString:nsstr];
    return hexStr;
}

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}
-(NSString *)getIMEI:(NSString *)string
{
        
    NSString * imeiString = [NSString new];
    @try {
        imeiString =  [string substringWithRange:NSMakeRange(12, string.length - 18) ];

    } @catch (NSException *exception) {
            imeiString=@"";
    } @finally {
           
    }
    return imeiString;

}


-(NSString *)getICCD:(NSString *)string
{
    NSString * iccdString = [NSString new];
    @try {
        iccdString =  [string substringWithRange:NSMakeRange(12, string.length - 18) ];

    } @catch (NSException *exception) {
            iccdString=@"";
    } @finally {
           
    }
    return iccdString;
}
- (NSString *)getIMEIHash{
    return IMEIHash;
}
//sha1加密方式
- (NSString *) sha1:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}




@end

