//
//  MyDevicemanger.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MyDevicemanger.h"

@implementation MyDevicemanger

+ (MyDevicemanger *)shareManger{
    static dispatch_once_t onceToken;
    static MyDevicemanger *manger;
    dispatch_once(&onceToken, ^{
        manger = [[MyDevicemanger alloc] init];
    });
    return manger;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)setDevices:(NSMutableArray<BikeDeviceModel *> *)Devices{
    _Devices = Devices;
    for (BikeDeviceModel *m in Devices) {
        if ([m.Id isEqualToString:self.mainDevice.Id]) {
            m.isConnecting = self.mainDevice.isConnecting;
        }else{
            m.isConnecting = NO;
        }
    }
    
}

- (void)setMainDevice:(BikeDeviceModel *)mainDevice{
    _mainDevice = mainDevice;
    for (BikeDeviceModel *m in self.Devices) {
        if ([m.Id isEqualToString:mainDevice.Id]) {
            m.isConnecting = mainDevice.isConnecting;
        }else{
            m.isConnecting = NO;
        }

    }
}

@end
