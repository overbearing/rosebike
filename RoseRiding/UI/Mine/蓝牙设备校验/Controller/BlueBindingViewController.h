//
//  BlueBindingViewController.h
//  RoseRiding
//
//  Created by mac on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef void(^ActivatingSuccess)(void);

@interface BlueBindingViewController : RootViewController

//@property (nonatomic, strong) NSString * idString;
//@property (nonatomic, strong) NSString * titleString;
@property (nonatomic , copy)ActivatingSuccess success;

@property (nonatomic , strong)BikeDeviceModel * activeBike;//要激活的设备
@property (nonatomic , assign)NSString * bluename;
@end

NS_ASSUME_NONNULL_END
