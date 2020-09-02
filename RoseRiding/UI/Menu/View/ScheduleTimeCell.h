//
//  ScheduleTimeCell.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScheduleTimeCellSelect)(void);
typedef void(^ScheduleTimeCellDelete)(void);
@interface ScheduleTimeCell : UITableViewCell
@property (nonatomic , copy)ScheduleTimeCellSelect choose;
@property (nonatomic , copy)ScheduleTimeCellSelect deletetime;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
- (void)configureWithIndexpath:(NSIndexPath *)indexPath showSelect:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
