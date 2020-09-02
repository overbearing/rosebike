//
//  BlueToothAlert.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    ActivateDeviceWait,
    ActivateDeviceFail,
    ActivateDeviceSuccess,
    NormalWaring,
    LowBatteryRemian30,
    LowBatteryRemian15,
    BuleAuthFailContact,
    ServiceExpired,
    Nodevice,
    RemianDays,
    BluetoothLow,
    ElectricFence,
} BlueToothAlertType;

@interface BlueToothAlert : UIView

+ (void)showAlertWith:(BlueToothAlertType)type Clcik:( void(^)(BlueToothAlertType type))click;


@end

NS_ASSUME_NONNULL_END
