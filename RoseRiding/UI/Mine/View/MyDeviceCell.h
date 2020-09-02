//
//  MyDeviceCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BikeDeviceModel;
typedef void(^AttachAction)(void);

@interface MyDeviceCell : UITableViewCell

@property (nonatomic , assign)BOOL showAttach;
@property (nonatomic , copy)AttachAction  attach;
@property (nonatomic, strong) BikeDeviceModel * model;
@end

NS_ASSUME_NONNULL_END
