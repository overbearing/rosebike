//
//  EditWorkScheduleController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"
#import "ScheWorkModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    WeekdayMode,
    WeekendMode
} WorkingMode;
@interface EditWorkScheduleController : RootViewController

- (instancetype)initWithIsEdit:(BOOL)isEdit model:(ScheWorkModel * _Nullable)model;

@end

NS_ASSUME_NONNULL_END
