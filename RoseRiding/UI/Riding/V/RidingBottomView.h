//
//  RidingBottomView.h
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RidingBottomShow)(void);
typedef void(^RidingBottomStart)(void);
typedef void(^RidingBottomPaused)(void);
typedef void(^RidingBottomStop)(void);

@interface RidingBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *triangel;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (nonatomic , copy)RidingBottomShow showAction;
@property (weak, nonatomic) IBOutlet UIView *ridingDataView;
@property (weak, nonatomic) IBOutlet UILabel *minutes;
@property (weak, nonatomic) IBOutlet UILabel *seconds;

@end

NS_ASSUME_NONNULL_END
