//
//  UserInfoCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/5/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UserInfoCellAdd)(void);

@interface UserInfoCell : UITableViewCell
@property (nonatomic , strong)UserModel *model;
@property (nonatomic , copy)UserInfoCellAdd add;
@property (nonatomic , strong)GYPeripheralInfo *blueInfo;
@end

NS_ASSUME_NONNULL_END
