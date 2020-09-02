//
//  GYPeripheralInfo.h
//  RoseRiding
//
//  Created by mac on 2020/4/21.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BabyBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@interface GYPeripheralInfo : NSObject
@property (nonatomic, strong) NSNumber     *RSSI;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSDictionary *advertisementData;
@end

NS_ASSUME_NONNULL_END
