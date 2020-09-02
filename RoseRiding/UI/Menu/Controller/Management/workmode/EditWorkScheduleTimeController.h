//
//  EditWorkScheduleTimeController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"
#import "ScheWorkModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditWorkScheduleTimeControllerComplteSelect)(NSMutableArray * _Nullable str,NSArray *_Nullable index);

@interface EditWorkScheduleTimeController : RootViewController

- (instancetype)initWithWorkModel:(ScheWorkModel  * _Nullable)model;

@property (nonatomic , copy)EditWorkScheduleTimeControllerComplteSelect selectResult;
@property (nonatomic , strong)NSArray * defaultSelectIndex;

@end

NS_ASSUME_NONNULL_END
