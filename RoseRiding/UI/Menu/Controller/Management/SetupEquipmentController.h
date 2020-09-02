//
//  SetupEquipmentController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"
#import "BikeDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetupEquipmentController : RootViewController

- (instancetype)initWithDevide:(BikeDeviceModel *)device;

@property (nonatomic , strong)BikeDeviceModel *device;

@end

NS_ASSUME_NONNULL_END
