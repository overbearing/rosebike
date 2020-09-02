//
//  MyDevicemanger.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BikeDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDevicemanger : NSObject

+ (MyDevicemanger *)shareManger;

@property (nonatomic , strong)NSMutableArray <BikeDeviceModel *>*Devices;//所有设备（激活，未激活，激活中）
@property (nonatomic , strong,nullable)BikeDeviceModel *mainDevice; //首页要显示的设备(与蓝牙状态无关)
@end

NS_ASSUME_NONNULL_END
