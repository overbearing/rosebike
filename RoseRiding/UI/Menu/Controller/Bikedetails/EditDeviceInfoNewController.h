//
//  EditDeviceInfoNewController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/27.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

typedef void(^AddDeviceSuccess)(void);


typedef enum : NSUInteger {
    DeviceInfoDefault,
    DeviceInfoAdd,
    DeviceInfoEdit,
} DeviceInfoType;

NS_ASSUME_NONNULL_BEGIN

@interface EditDeviceInfoNewController : RootViewController

@property (nonatomic , assign)DeviceInfoType type;
@property (nonatomic , copy)AddDeviceSuccess success;
@property (nonatomic , copy)NSString *deviceId;
@property (nonatomic , copy)NSString *url;

@end

NS_ASSUME_NONNULL_END
