//
//  MajorDeviceStatusController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BatteryLevelDafault,
    BatteryLevel1,
    BatteryLevel2,
    BatteryLevel3,
    BatteryLevel4,
    BatteryLevel5
} BatteryLevel;
@interface MajorDeviceStatusController : RootViewController

@end

NS_ASSUME_NONNULL_END
