//
//  DeviceMangerCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeDeviceModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DeviceMangerCellEdit)(void);
typedef void(^DeviceMangerCellDel)(void);
@interface DeviceMangerCell : UITableViewCell

@property (nonatomic , copy)DeviceMangerCellEdit edit;
@property (nonatomic , copy)DeviceMangerCellDel del;
@property (nonatomic , strong)BikeDeviceModel *model;

@end

NS_ASSUME_NONNULL_END
