//
//  recordsView.h
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/8/7.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface recordsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *recorddetail;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *costtime;
@property (weak, nonatomic) IBOutlet UILabel *begintime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *avgspeed;
@property (weak, nonatomic) IBOutlet UILabel *clambheight;

@end

NS_ASSUME_NONNULL_END
