//
//  AuthDeviceCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/10.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AuthDeviceCellSelectTime)(NSInteger index);
typedef void(^AuthDeviceCellGoAuth)(void);
typedef void(^AuthDeviceCellCancelAuth)(NSString *) ;
@interface AuthDeviceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *authTime;
@property (nonatomic , strong)BikeDeviceModel *model;
@property (nonatomic , copy)AuthDeviceCellSelectTime selectTime;
@property (nonatomic , copy)AuthDeviceCellGoAuth goAuth;
@property (nonatomic , copy)AuthDeviceCellCancelAuth cancelAuth;
@property (weak, nonatomic) IBOutlet UISwitch *authSwitch;
@property (nonatomic, copy)NSString *modelId;
- (IBAction)deleteAuthSwitch:(UISwitch *)sender;

@end

NS_ASSUME_NONNULL_END
