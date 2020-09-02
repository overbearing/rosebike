//
//  RidingTopView.h
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RidingTopViewSearch)(void);
typedef void(^RidingTopViewStartRiding)(void);
typedef void(^RidingTopViewStopRiding)(void);
typedef void(^RidingTopViewPauseRiding)(void);

@interface RidingTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (nonatomic , copy)RidingTopViewSearch searchAction;
@property (nonatomic , copy)RidingTopViewStartRiding startRidingAction;
@property (nonatomic , copy)RidingTopViewStopRiding  stopRidingAction;
@property (nonatomic , copy)RidingTopViewPauseRiding pauseRidingAction;

@end

NS_ASSUME_NONNULL_END
