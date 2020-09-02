//
//  UserDeviceInfo.h
//  RoseRiding
//
//  Created by LaoSun on 2020/4/14.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoModel:NSObject<NSCoding>

@property (nonatomic, copy) NSString *macAddress;

@property (nonatomic, copy) NSString *deviceName;

@end

@interface UserDeviceInfo : NSObject

+ (UserDeviceInfo *)shareUserInfo;

/**保存新设备
 */
- (void)saveNewDeviceInfoWithMacAddress:(NSString *)macAddress name:(NSString *)name;
/**获取所有已保存设备
 */
- (NSMutableArray *)getAllDevice;
/**
 保存临时新设备，未完成激活，以及校验IMEI时，临时保存，等完全绑定成功则 再添加设备到本地
 */
- (void)saveTemporaryDeviceWithMacAddress:(NSString *)macAddress name:(NSString *)name;
/**获取临时设备信息
 */
- (DeviceInfoModel *)getTemporaryDeviceData;
/**保存默认连接设备
 */
- (void)saveDefaultDeviceWithMacAddress:(NSString *)macAddress;
/**获取默认设备mac
 */
- (NSString *)getDefaultDeviceMacaddress;
/**本地是否保存有设备
 */
- (BOOL)isHaveDevice;

@end

NS_ASSUME_NONNULL_END
