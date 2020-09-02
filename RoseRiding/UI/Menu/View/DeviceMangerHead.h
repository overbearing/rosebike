//
//  DeviceMangerHead.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DeviceMangerHeadClick)(NSInteger index);

@interface DeviceMangerHead : UIView

@property (nonatomic , copy)DeviceMangerHeadClick click;

@end

NS_ASSUME_NONNULL_END
