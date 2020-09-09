//
//  BikeDeviceModel.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/24.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BikeDeviceModel : NSObject

@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *is_default; //是否上次链接过1：是2：否
@property (nonatomic , strong)NSString *is_blue; //是否蓝牙连接1：未连接2：已连接
@property (nonatomic , strong)NSString *activation; //sim卡激活状态1：未激活2：激活中3：已激活
@property (nonatomic , strong)NSString *equipment;   //     设备名称
@property (nonatomic , strong)NSString *device_imei;  //设备imei
@property (nonatomic , strong)NSString *photo;  //设备名称
@property (nonatomic , assign)BOOL      is_auth; //1：被授权 0：授权
@property (nonatomic , assign)BOOL      isConnecting; //当前蓝牙是否已经连接
@property (nonatomic , assign)int      status ;  //1：未授权2：已授权
@property (nonatomic , assign)BOOL is_autolock;
@property (nonatomic , strong)NSString *mac_id; //设备的物理地址
@property (nonatomic , strong)NSString * version; //当前版本号
@property (nonatomic , strong)NSString * lastversion; //最新版本号

@end

NS_ASSUME_NONNULL_END
