//
//  EditWorkScheduleNameController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"
#import "ScheWorkModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditWorkScheduleNameControllerComplteInput)(NSString * _Nullable str);

@interface EditWorkScheduleNameController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *nameText;
- (instancetype)initWithWorkModel:(ScheWorkModel  * _Nullable)model;

@property (nonatomic , copy)EditWorkScheduleNameControllerComplteInput inputResult;

@end

NS_ASSUME_NONNULL_END
